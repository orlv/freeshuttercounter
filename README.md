## FreeShutterCounter

[![Github All Releases](https://img.shields.io/github/downloads/orlv/freeshuttercounter/total.svg)](https://github.com/orlv/freeshuttercounter/releases)

FreeShutterCounter is macOS application that shows Canon EOS DSLR shutter count.

![freeshuttercounter 1.2.1 screenshot](http://orlv.github.io/freeshuttercounter/freeshuttercounter-1.2.1.png)

#### Supported cameras:

1D C, 1D X, 1D Mark IV, 7D Mark II, 7D, 5D Mark III, 5D Mark II, 6D,
70D, 60D, 50D, 700D, 650D, 600D, 550D, 500D, 100D, 1200D, 1100D, 1000D

#### Unsupported:

1D X Mark II, 5DS, 5DS R, 5D Mark IV, 5D, 80D, 750D, 760D, 1300D


## Download

[freeshuttercounter-1.2.2.dmg](https://github.com/orlv/freeshuttercounter/releases/download/1.2.2/freeshuttercounter-1.2.2.dmg) (1.6 Mb) OS X 10.7-10.12

## Usage

- copy app into the /Applications folder
- switch camera communication settings to PTP
- connect camera to mac via usb cable
- close auto-started application (Apple Photo, Image Capture, etc) then press "Get Shutter Count" button.


## Building
This app is based on [libgphoto2](https://github.com/gphoto/libgphoto2) library 
(macOS framework build script can be found here: https://github.com/lnxbil/GPhoto2.framework)
