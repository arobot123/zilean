# vim

## 目录

- [概述](#概述)
- [部署](#部署)
- [使用](#使用)
- [设计](#设计)
- [TODO](#TODO)

___

## 概述

VIM 轻量，且功能强大，自带配置，丰富插件，支持多种语言自动补全、文本高亮、丰富配色，相较于其他IDE有很多优势。  
用户定制性强，操作效率高，绝对办公利器。  

## 部署

使用到了coc.nvim，需要安装nodejs,yarn。参考教程
[coc.nvim](https://github.com/neoclide/coc.nvim/wiki/Install-coc.nvim)  

执行部署脚本

```sh
./setup
```

等待进入vim编辑， 执行 `PlugInstall`  

然后使用coc安装其他的补全插件
参考 [安装教程](https://github.com/neoclide/coc.nvim/wiki/Language-servers)

### shell

`CocInstall coc-sh`

### Cmake

`CocInstall coc-cmake`

### Css/Less/Sass

`CocInstall coc-css`

### Dockerfile

`sudo npm install -g dockerfile-language-server-nodejs`  
vim command: CocConfig

```json
{
    "languageserver": {
      "dockerfile": {
        "command": "docker-langserver",
        "filetypes": ["dockerfile"],
        "args": ["--stdio"]
      }
    }
}
```

### Go

`CocInstall coc-go`

### Html

`CocInstall coc-html`

### Java

`CocInstall coc-java`

### Javascript/Typescript

`sudo npm install -g typescript`  
`CocInstall coc-tsserver`

### Json

`CocInstall coc-json`

### markdown

`CocInstall coc-markdownlint`

### PHP

`CocInstall coc-psalm`

### 支持python3补全

`CocInstall coc-pyright`

### R

`CocInstall coc-r-lsp`

### Ruby

`sudo gem install solargraph`  
`CocInstall coc-solargraph`

### Vue

`CocInstall coc-vetur`

### 自动补全括号

`CocInstall coc-pairs`

### 文档高亮

`CocInstall coc-highlight`

## 使用

## 设计

## TODO

