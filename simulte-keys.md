查看/dev/input/eventX是什么类型的事件， cat /proc/bus/input/devices
设备有着自己特殊的按键键码，我需要将一些标准的按键，比如0－9，X－Z等模拟成标准按键，比如KEY_0,KEY-Z等，所以需要用到按键模拟，具体方法就是操作/dev/input/event1文件，向它写入个input_event结构体就可以模拟按键的输入了。
linux/input.h中有定义，这个文件还定义了标准按键的编码等
struct input_event {
struct timeval time; //按键时间
__u16 type; //类型，在下面有定义
__u16 code; //要模拟成什么按键
__s32 value;//是按下还是释放
};
code：
事件的代码.如果事件的类型代码是EV_KEY,该代码code为设备键盘代码.代码植0~127为键盘上的按键代码,0x110~0x116 为鼠标上按键代码,其中0x110(BTN_ LEFT)为鼠标左键,0x111(BTN_RIGHT)为鼠标右键,0x112(BTN_ MIDDLE)为鼠标中键.其它代码含义请参看include/linux/input.h文件. 如果事件的类型代码是EV_REL,code值表示轨迹的类型.如指示鼠标的X轴方向REL_X(代码为0x00),指示鼠标的Y轴方向REL_Y(代码为0x01),指示鼠标中轮子方向REL_WHEEL(代码为0x08).
type:
EV_KEY,键盘
EV_REL,相对坐标
EV_ABS,绝对坐标
value：
事件的值.如果事件的类型代码是EV_KEY,当按键按下时值为1,松开时值为0;如果事件的类型代码是EV_ REL,value的正数值和负数值分别代表两个不同方向的值.
/*
* Event types
*/
#define EV_SYN 0x00
#define EV_KEY 0x01 //按键
#define EV_REL 0x02 //相对坐标(轨迹球)
#define EV_ABS 0x03 //绝对坐标
#define EV_MSC 0x04 //其他
#define EV_SW 0x05
#define EV_LED 0x11 //LED
#define EV_SND 0x12//声音
#define EV_REP 0x14//repeat
#define EV_FF 0x15
#define EV_PWR 0x16
#define EV_FF_STATUS 0x17
#define EV_MAX 0x1f
#define EV_CNT (EV_MAX+1)
1。模拟按键输入
//其中0表示释放，1按键按下，2表示一直按下
//0 for EV_KEY for release, 1 for keypress and 2 for autorepeat.
void simulate_key(int fd,int value)
{
struct input_event event;
event.type = EV_KEY;
//event.code = KEY_0;//要模拟成什么按键
event.value = value;//是按下还是释放按键或者重复
gettimeofday(&event.time,0);
if(write(fd,&event,sizeof(event)) < 0){
dprintk("simulate key error~~~\n");
return ;
}
}
2。模拟鼠标输入（轨迹球）
void simulate_mouse(int fd,char buf[4])
{
int rel_x,rel_y;
static struct input_event event,ev;
//buf[0],buf[2],小于0则为左移，大于0则为右移
//buf[1],buf[3],小于0则为下移，大于0则为上移
dprintk("MOUSE TOUCH: x1=%d,y1=%d,x2=%d,y2=%d\n",buf[0],buf[1],buf[2],buf[3]);
rel_x = (buf[0] + buf[2]) /2;
rel_y = -(buf[1] + buf[3]) /2; //和我们的鼠标是相反的方向，所以取反
event.type = EV_REL;
event.code = REL_X;
event.value = rel_x;
gettimeofday(&event.time,0);
if( write(fd,&event,sizeof(event))!=sizeof(event))
dprintk("rel_x error~~~:%s\n",strerror(errno));
event.code = REL_Y;
event.value = rel_y;
gettimeofday(&event.time,0);
if( write(fd,&event,sizeof(event))!=sizeof(event))
dprintk("rel_y error~~~:%s\n",strerror(errno));
//一定要刷新空的
write(fd,&ev,sizeof(ev));
}
鼠标和键盘文件打开方法：
int fd_kbd; // /dev/input/event1
int fd_mouse; //dev/input/mouse2
fd_kbd = open("/dev/input/event1",O_RDWR);
if(fd_kbd<=0){
printf("error open keyboard:%s\n",strerror(errno));
return -1;
}
fd_mouse = open("/dev/input/event3",O_RDWR); //如果不行的话，那试试/dev/input/mice
if(fd_mouse<=0){
printf("error open mouse:%s\n",strerror(errno));
return -2;
}
}
/dev/input/mice是鼠标的抽象，代表的是鼠标，也许是/dev/input/mouse,/dev/input/mouse1，或者空，
这个文件一直会存在。
这里你也许会问，我怎么知道/dev/input/eventX这些事件到底是什么事件阿，是鼠标还是键盘或者别的，
eventX代表的是所有输入设备(input核心)的事件，比如按键按下，或者鼠标移动，或者游戏遥控器等等，
在系统查看的方法是 cat /proc/bus/input/devices 就可以看到每个eventX是什么设备的事件了。
PS: 在GTK中用的话，可以参考下gtk_main_do_event这个函数
static void simulate_key(GtkWidget *window,int keyval,int press)
{
GdkEvent *event;
GdkEventType type;
if(press)
type = GDK_KEY_PRESS;
else
type = GDK_KEY_RELEASE;
event = gdk_event_new(type);
//event->key.send_event = TRUE;
event->key.window = window->window; //一定要设置为主窗口
event->key.keyval = keyval;
//FIXME:一定要加上这个,要不然容易出错
g_object_ref(event->key.window);
gdk_threads_enter();
//FIXME: 记得用这个来发送事件
gtk_main_do_event(event);
gdk_threads_leave();
gdk_event_free(event);
}
kernel里input模块
input_dev结构:
struct input_dev {
    void *private;
    const char *name;
    const char *phys;
    const char *uniq;
    struct input_id id;
    /*
    * 根据各种输入信号的类型来建立类型为unsigned long 的数组,
    * 数组的每1bit代表一种信号类型,
    * 内核中会对其进行置位或清位操作来表示时间的发生和被处理.
    */
    unsigned long evbit[NBITS(EV_MAX)];
    unsigned long keybit[NBITS(KEY_MAX)];
    unsigned long relbit[NBITS(REL_MAX)];
    unsigned long absbit[NBITS(ABS_MAX)];
    unsigned long mscbit[NBITS(MSC_MAX)];
    unsigned long ledbit[NBITS(LED_MAX)];
    unsigned long sndbit[NBITS(SND_MAX)];
    unsigned long ffbit[NBITS(FF_MAX)];
    unsigned long swbit[NBITS(SW_MAX)];
    .........................................
};
/**
* input_set_capability - mark device as capable of a certain event
* @dev: device that is capable of emitting or accepting event
* @type: type of the event (EV_KEY, EV_REL, etc...)
* @code: event code
*
* In addition to setting up corresponding bit in appropriate capability
* bitmap the function also adjusts dev->evbit.
*/
/* 记录本设备对于哪些事件感兴趣(对其进行处理)*/
void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
{
    switch (type) {
    case EV_KEY:
        __set_bit(code, dev->keybit);//比如按键,应该对哪些键值的按键进行处理(对于其它按键不予理睬)
        break;
    case EV_REL:
        __set_bit(code, dev->relbit);
        break;
    case EV_ABS:
        __set_bit(code, dev->absbit);
        break;
    case EV_MSC:
        __set_bit(code, dev->mscbit);
        break;
    case EV_SW:
        __set_bit(code, dev->swbit);
        break;
    case EV_LED:
        __set_bit(code, dev->ledbit);
        break;
    case EV_SND:
        __set_bit(code, dev->sndbit);
        break;
    case EV_FF:
        __set_bit(code, dev->ffbit);
        break;
    default:
        printk(KERN_ERR
            "input_set_capability: unknown type %u (code %u)\n",
            type, code);
        dump_stack();
        return;
    }
    __set_bit(type, dev->evbit);//感觉和前面重复了(前面一经配置过一次了)
}
EXPORT_SYMBOL(input_set_capability);
static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
{
        int i;
        struct platform_device *pdev = dev_id;
        struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
        struct input_dev *input = platform_get_drvdata(pdev);
        for (i = 0; i < pdata->nbuttons; i++) {
                struct gpio_keys_button *button = &pdata->buttons[i];
                int gpio = button->gpio;
                if (irq == gpio_to_irq(gpio)) {//判断哪个键被按了?
                        unsigned int type = button->type ?: EV_KEY;
                        int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;//记录按键状态
                        input_event(input, type, button->code, !!state);//汇报输入事件
                        input_sync(input);//等待输入事件处理完成
                }
        }
        return IRQ_HANDLED;
}
/*
* input_event() - report new input event
* @dev: device that generated the event
* @type: type of the event
* @code: event code
* @value: value of the event
*
* This function should be used by drivers implementing various input devices
* See also input_inject_event()
*/
void input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
{
    struct input_handle *handle;
    if (type > EV_MAX || !test_bit(type, dev->evbit))//首先判断该事件类型是否有效且为该设备所接受
        return;
    add_input_randomness(type, code, value);
    switch (type) {
        case EV_SYN:
            switch (code) {
                case SYN_CONFIG:
                    if (dev->event)
                        dev->event(dev, type, code, value);
                    break;
                case SYN_REPORT:
                    if (dev->sync)
                        return;
                    dev->sync = 1;
                    break;
            }
            break;
        case EV_KEY:
            /*
            * 这里需要满足几个条件:
            * 1: 键值有效(不超出定义的键值的有效范围)
            * 2: 键值为设备所能接受(属于该设备所拥有的键值范围)
            * 3: 按键状态改变了
            */
            if (code > KEY_MAX || !test_bit(code, dev->keybit) || !!test_bit(code, dev->key) == value)
                return;
            if (value == 2)
                break;
            change_bit(code, dev->key);//改变对应按键的状态
            /* 如果你希望按键未释放的时候不断汇报按键事件的话需要以下这个(在简单的gpio_keys驱动中不需要这个,暂时不去分析) */
            if (test_bit(EV_REP, dev->evbit) && dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] && dev->timer.data && value) {
                dev->repeat_key = code;
                mod_timer(&dev->timer, jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
            }
            break;
........................................................
    if (type != EV_SYN)
        dev->sync = 0;
    if (dev->grab)
        dev->grab->handler->event(dev->grab, type, code, value);
    else
        /*
        * 循环调用所有处理该设备的handle(event,mouse,ts,joy等),
        * 如果有进程打开了这些handle(进行读写),则调用其对应的event接口向气汇报该输入事件.
        */
        list_for_each_entry(handle, &dev->h_list, d_node)
            if (handle->open)
                handle->handler->event(handle, type, code, value);
}
EXPORT_SYMBOL(input_event);
event层对于input层报告的这个键盘输入事件的处理:
drivers/input/evdev.c:
static struct input_handler evdev_handler = {
        .event =        evdev_event,
        .connect =      evdev_connect,
        .disconnect =   evdev_disconnect,
        .fops =         &evdev_fops,
        .minor =        EVDEV_MINOR_BASE,
        .name =         "evdev",
        .id_table =     evdev_ids,
};

Linux 有自己的 input 子系统，可以统一管理鼠标和键盘事件。
基于输入子系统 实现的 uinput 可以方便的在用户空间模拟鼠标和键盘事件。
当然，也可以自己造轮子， 做一个字符设备接收用户输入，根据输入，投递 input 事件。
还有一种方式就是直接 往 evnent 里写入数据， 都可以达到控制鼠标键盘的功能。

本篇文章就是演示直接写入 event 的方法。
linux/input.h中有定义，这个文件还定义了标准按键的编码等

struct input_event {
    struct timeval time;  //按键时间
    __u16 type; //类型，在下面有定义
    __u16 code; //要模拟成什么按键
    __s32 value;//是按下还是释放
};

code：
事件的代码.如果事件的类型代码是EV_KEY,该代码code为设备键盘代码.代码植0~127为键盘上的按键代码, 0x110~0x116 为鼠标上按键代码,其中0x110(BTN_ LEFT)为鼠标左键,0x111(BTN_RIGHT)为鼠标右键,0x112(BTN_ MIDDLE)为鼠标中键.其它代码含义请参看include/linux /input.h文件. 如果事件的类型代码是EV_REL,code值表示轨迹的类型.如指示鼠标的X轴方向 REL_X (代码为0x00),指示鼠标的Y轴方向REL_Y(代码为0x01),指示鼠标中轮子方向REL_WHEEL(代码为0x08).

type:
EV_KEY,键盘
EV_REL,相对坐标
EV_ABS,绝对坐标

value：
事件的值.如果事件的类型代码是EV_KEY,当按键按下时值为1,松开时值为0;如果事件的类型代码是EV_ REL,value的正数值和负数值分别代表两个不同方向的值.
/*
* Event types
*/

#define EV_SYN            0x00
#define EV_KEY            0x01 //按键
#define EV_REL            0x02 //相对坐标(轨迹球)
#define EV_ABS            0x03 //绝对坐标
#define EV_MSC            0x04 //其他
#define EV_SW            0x05
#define EV_LED            0x11 //LED
#define EV_SND            0x12//声音
#define EV_REP            0x14//repeat
#define EV_FF            0x15
#define EV_PWR            0x16
#define EV_FF_STATUS        0x17
#define EV_MAX            0x1f
#define EV_CNT            (EV_MAX+1)

下面是一个模拟鼠标和键盘输入的例子：

#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

void simulate_key(int fd,int kval)
{
    struct input_event event;
    event.type = EV_KEY;
    event.value = 1;
    event.code = kval;

    gettimeofday(&event.time,0);
    write(fd,&event,sizeof(event)) ;

        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));
        memset(&event, 0, sizeof(event));
        gettimeofday(&event.time, NULL);
        event.type = EV_KEY;
        event.code = kval;
        event.value = 0;
        write(fd, &event, sizeof(event));
        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));

}

void simulate_mouse(int fd)
{
    struct input_event event;
        memset(&event, 0, sizeof(event));
        gettimeofday(&event.time, NULL);
        event.type = EV_REL;
        event.code = REL_X;
        event.value = 10;
        write(fd, &event, sizeof(event));

        event.type = EV_REL;
        event.code = REL_Y;
        event.value = 10;
        write(fd, &event, sizeof(event));

        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));
}

int main()
{
    int fd_kbd;
    int fd_mouse;
    fd_kbd = open("/dev/input/event1",O_RDWR);
    if(fd_kbd<=0){
        printf("error open keyboard:\n");
        return -1;

    }

    fd_mouse = open("/dev/input/event2",O_RDWR);
    if(fd_mouse<=0){
        printf("error open mouse\n");
        return -2;
    }

    int i = 0;
    for(i=0; i< 10; i++)
    {
        simulate_key(fd_kbd, KEY_A + i);
        simulate_mouse(fd_mouse);
        sleep(1);
    }

    close(fd_kbd);
}
模拟了鼠标和键盘的输入事件。
关于这里 open 哪个 event ， 可以通过 cat /proc/bus/input/devices
I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=mouse0 event0
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=120013
B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/class/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0003 Vendor=046d Product=c018 Version=0111
N: Name="Logitech USB Optical Mouse"
P: Phys=usb-0000:00:1d.1-2/input0
S: Sysfs=/class/input/input24
U: Uniq=
H: Handlers=mouse1 event2
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103

我的鼠标是 罗技 的 Logitech USB Optical Mouse， 所以 鼠标是 event2
下面是一个读取 鼠标和键盘事件的例子：
#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

static void show_event(struct input_event* event)
{
        printf("%d %d %d\n", event->type, event->code, event->value);

        return;
}

int main(int argc, char* argv[])
{
        struct input_event event = {{0}, 0};
        const char* file_name = argc == 2 ? argv[1] : "/dev/input/event2";

        int fd = open(file_name, O_RDWR);

        if(fd > 0)
        {

                while(1)
                {
                        int ret = read(fd, &event, sizeof(event));
                        if(ret == sizeof(event))
                        {
                                show_event(&event);
                        }
                        else
                        {
                                break;
                        }
                }
                close(fd);
        }

        return 0;
}

很多人对于 如何模拟 CTRL + SPACE 感兴趣， 下面也给个例子，呵呵。
void simulate_ctrl_space(int fd)
{
        struct input_event event;

     //先发送一个 CTRL 按下去的事件。
        event.type = EV_KEY;
        event.value = 1;
        event.code = KEY_LEFTCTRL;
        gettimeofday(&event.time,0);
        write(fd,&event,sizeof(event)) ;

        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));

     //先发送一个 SPACE 按下去的事件。
        event.type = EV_KEY;
        event.value = 1;
        event.code = KEY_SPACE;
        gettimeofday(&event.time,0);
        write(fd,&event,sizeof(event)) ;

     //发送一个 释放 SPACE 的事件
        memset(&event, 0, sizeof(event));
        gettimeofday(&event.time, NULL);
        event.type = EV_KEY;
        event.code = KEY_SPACE;
        event.value = 0;
        write(fd, &event, sizeof(event));

        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));

     //发送一个 释放 CTRL 的事件
        memset(&event, 0, sizeof(event));
        gettimeofday(&event.time, NULL);
        event.type = EV_KEY;
        event.code = KEY_LEFTCTRL;
        event.value = 0;
        write(fd, &event, sizeof(event));

        event.type = EV_SYN;
        event.code = SYN_REPORT;
        event.value = 0;
        write(fd, &event, sizeof(event));

}

