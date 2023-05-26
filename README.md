# clash_pack

## Description

A simple encapsulation of the out-of-the-box version of *clash_for_windows_pkg* on Ubuntu.
在Ubuntu上对[*clash_for_windows_pkg*](https://github.com/Fndroid/clash_for_windows_pkg) 的一个**开箱即用**版本的简单封装。

## Introduction

主要由如下几部分组成：

1. `clash.tar.gz`为修改后的压缩包文件
   1. `clash_for_windows_pkg(Linux)` 来自[Github](https://github.com/Fndroid/clash_for_windows_pkg)
   2. 汉化采用`Clash_Chinese_Patch` 来自[Github](https://github.com/BoyceLig/Clash_Chinese_Patch.git)
   3. logo使用`clash_for_windows_pkg(Windows)`提供 来自[Github](https://github.com/Fndroid/clash_for_windows_pkg)
2. `Application.desktop`为桌面应用启动文件
3. `install.sh`为快捷安装脚本，默认安装位置为`/home/${USER}/clash/`

## How to use

```bash
git clone https://github.com/qdu-rm-cv/clash_pack.git
cd clash_pack
sudo chmod 777 ./install.sh
./install.sh
# Then press Alt+F2, and input r, enter.
```

## Version

| Package Name          | Description |
| :-------------------- | :---------- |
| clash_for_windows_pkg | v0.20.24    |
| Clash_Chinese_Patch   | v0.20.24    |
