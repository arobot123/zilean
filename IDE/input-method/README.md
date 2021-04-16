## ibus智能拼音导入搜狗用户词库

### 下载用户词库到本地

`https://pinyin.sogou.com/dict/`。仓库已下载 scelFromSougou/

### 工具脚本引用

`scel2Db` 添加scel文件列表

### 执行脚本开始转换为db

`./scel2Db`

### 将local.db文件rsync到ibus对应目录`/usr/share/ibus-libpinyin/db`

`sudo rsync local.db /usr/share/ibus-libpinyin/db`
