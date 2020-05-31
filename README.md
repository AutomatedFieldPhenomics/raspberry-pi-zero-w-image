# Boot Image Creation for the Raspberry Pi Zero W

[![Build Status](https://travis-ci.org/AutomatedFieldPhenomics/raspberry-pi-zero-w-image.svg?branch=master)](https://travis-ci.org/AutomatedFieldPhenomics/raspberry-pi-zero-w-image)

Note: These images are using the Canadian WLAN regulatory domain.

## Download

The boot images are compressed as a zip or xz file.
-  [raspberry-pi-zero-w.img.zip](https://github.com/AutomatedFieldPhenomics/raspberry-pi-zero-w-image/releases/latest/download/raspberry-pi-zero-w.img.zip) (larger, but more widely supported)
-  [raspberry-pi-zero-w.img.xz](https://github.com/AutomatedFieldPhenomics/raspberry-pi-zero-w-image/releases/latest/download/raspberry-pi-zero-w.img.xz) (smaller, but likely requires linux)

## Installation

Use the Raspberry Pi Imager for an easy way to install Raspbian and other operating systems to an SD card ready to use with your Raspberry Pi:
- [Raspberry Pi Imager for Windows](https://downloads.raspberrypi.org/imager/imager.exe)
- [Raspberry Pi Imager for macOS](https://downloads.raspberrypi.org/imager/imager.dmg)
- [Raspberry Pi Imager for Ubuntu](https://downloads.raspberrypi.org/imager/imager_amd64.deb)

Under Operating System, Choose OS, pick the option to `Use Custom img` file.

## Development

If you wish to contribute changes to the boot image:
- files in the directories `boot`, `etc`, `home` are copied to their respective locations,
- patches in `patches.d` are applied with respect to the base of the file system,
- scripts in `scripts.d` are executed in a chroot environment.
