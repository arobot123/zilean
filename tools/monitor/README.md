# monitor
## 目录
- [概述](#概述)
- [部署](#部署)
- [使用](#使用)
- [设计](#设计)
- [优化](#优化)
___

## 概述
Linux常用的系统监控工具很多，如glance, netdata等。按网上教程安装配置使用即可。不需要重复造轮子。  
我写这个工具的起因，只是因为自己的兴趣，加深自己对Linux的理解，并能够对自己的电脑（fedora-x64）进行日常监控。

## 部署

## 使用

## 设计
开发阶段：脚本显示 -> 后台服务 -> Web展示  
监控项: 系统信息 -> 内存 -> 磁盘 -> CPU -> 网络 -> 应用  
中间件: mysql  
微服务：Flask  
Web： Vue.js 框架  
部署: nginx  
  
每个监控服务单独运行，刷新数据，前台手动或周期性更新或事件更新。  

### 系统信息

### 内存

### 磁盘

### CPU

### 网络

### 应用

## 优化

