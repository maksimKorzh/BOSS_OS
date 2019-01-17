[bits 16]

%define SHELL 0x70
%define NEW 0x90
%define SOURCE 0x110

; 80 x 25
mov ah, 0x00
mov al, 0x03
int 0x10

; box cursor
mov ch, 0
mov cl, 7
mov ah, 1
int 10h

mov ax, NEW
mov ds, ax
mov si, info
call print

; set extra segment
mov ax, SOURCE
mov es, ax
mov di, 0

reset_source:
    mov cx, 0

    .next_char:
        mov al, 0
        stosb
        inc cx
        cmp cx, 25600   ; number of bytes to clear ;
        je .return
        jmp .next_char

    .return:
        mov ah, 0x00
        int 0x16
        jmp SHELL:0x0000

print:
    cld
    mov ah, 0x0E

    .next_char:
        lodsb
        cmp al, 10
        je .new_line

    .end_str:
        cmp al, 0
        je .end
        int 0x10
        jmp .next_char

    .new_line:
        int 0x10
        mov al, 13
        jmp .end_str 
    
    .end:
        ret

info db 10, ' Source file has been cleared', 10,
     db ' Use "view" command to check out the result', 10, 10,
     db ' Press any key to exit...', 0        