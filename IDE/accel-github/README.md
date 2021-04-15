## Github 访问加速

### 环境配置

```text
# 安装nodejs，配置npm源加速

# 安装npm包request, cheerio
npm install request cheerio
```

### 部署

```text
# 将 accel-github, githubIp 放到 /root/bin/ 目录
# /etc/profile 新增执行 /root/bin/accel-github
```

### 执行

```text
# 修改 /etc/hosts 文件，需要root权限
accel-github

# 查看/etc/hosts新增主机IP映射如下

#WIFI Huawei-Guest
# github 加速
185.199.108.133 raw.githubusercontent.com
185.199.109.133 raw.githubusercontent.com
185.199.110.133 raw.githubusercontent.com
185.199.111.133 raw.githubusercontent.com
199.232.69.194 github.global.ssl.fastly.net
185.199.108.153 assets-cdn.github.com
185.199.109.153 assets-cdn.github.com
185.199.110.153 assets-cdn.github.com
185.199.111.153 assets-cdn.github.com
140.82.113.4 github.com
140.82.113.3 gist.github.com
```
