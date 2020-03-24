.PHONY: qemu

clock.bin: clock.asm
	nasm -f bin clock.asm -o clock.bin

qemu: clock.bin
	qemu-system-x86_64 -drive format=raw,file=clock.bin -rtc base=localtime
