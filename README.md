# bootable-clock

## Emulator
If you have `qemu-system-x86_64`, simply run `make qemu`.

It also works with VMware. You probably will need to rename the `.bin` to `.img` so VMware can use this file as floppy image.

## Real hardware
This *bootloader* has been tested on real hardware, it should works on yours !

Just compile the code and use `dd` with `clock.bin` as input to create a bootable usb device.
