[bits 16]

%define SHELL 0x70
%define SOURCE 0x110
%define VIEW 0x90

%define ESC 0x01

; 80 x 25
mov ah, 0x00
mov al, 0x03
int 0x10

; box cursor
mov ch, 0
mov cl, 7
mov ah, 1
int 10h
 	
; set data segment
mov ax, SOURCE
mov ds, ax
mov si, 0

call print

mov ax, VIEW
mov ds, ax
mov si, info
call print

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

info db 10, ' Press any key to exit...', 0