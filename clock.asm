bits 16 ; tell NASM this is 16 bit code
org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00

; https://stackoverflow.com/questions/47277702/custom-bootloader-booted-via-usb-drive-produces-incorrect-output-on-some-compute
jmp start
resb 0x50

start:
    mov ah,0x00 ; Set Video Mode
    mov al,0x13 ; http://www.techhelpmanual.com/114-video_modes.html
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services

.loop:
    mov ah,0x02 ; Set Cursor Position
    mov bh,0 ; video page number
    mov dh,12d ; row
    mov dl,16d ; column
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services

    mov ah, 0x02 ; Read Time from Real-Time Clock
    int 0x1a ; Timer I/O

    ; Hour X.:..:..
    mov al,ch
    and al,0xF0
    SHR al, 4 ; >> 4
    call drawAlDigit

    ; Hour .X:..:..
    mov al,ch
    and al,0x0F
    call drawAlDigit

    mov al,":"
    call drawAl

    ; Minute ..:X.:..
    mov al,cl
    and al,0xF0
    SHR al, 4 ; >> 4
    call drawAlDigit

    ; Minute ..:.X:..
    mov al,cl
    and al,0x0F
    call drawAlDigit

    mov al,":"
    call drawAl

    ; Second ..:..:X.
    mov al,dh
    and al,0xF0
    SHR al, 4 ; >> 4
    call drawAlDigit

    ; Second ..:..:.X
    mov al,dh
    and al,0x0F
    call drawAlDigit

    jmp .loop

drawAlDigit:
    add al,"0"
    call drawAl
    ret

drawAl:
    mov ah,0x0e ; Write Character as TTY
    mov bl,2 ; color
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    ret

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ; magic bootloader magic - marks this 512 byte sector bootable!
