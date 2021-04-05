# compressDOCX

### 简介

由于Mac截图较大，且从某些通讯软件中直接复制图片到Word中，图片格式会变成tiff，且体积巨大，而Word自带压图功能有时不能压缩到理想大小，于是编写了此脚本便于压缩。本脚本压缩时会自动检测扩展名，目前只支持docx和pptx格式，压缩前会自动备份原文件避免翻车。脚本需要调用第三方压图工具，所以需要安装对应压图工具。

### 安装

* 1.安装ImageOptim

  官网下载并解压到/Applications目录

  https://imageoptim.com/ImageOptim.tbz2

  或

  ```shell
  brew install imageoptim
  ```

* 2.安装ImageAlpha

  官网下载并解压到/Applications目录

  https://pngmini.com/ImageAlpha1.5.1.tar.bz2

  或

  ```shell
  brew cask install imagealpha
  ```

* 3.安装imageoptim-cli

  ```shell
  brew install imageoptim-cli
  ```

* 4.安装OptiPNG

  ```shell
  brew install OptiPNG
  ```

### 使用

```shell
chmod +x compressDOCX.sh
./compressDOCX.sh report.docx
./compressDOCX.sh report.pptx
```

