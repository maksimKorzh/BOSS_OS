[bits 16]

%define SHELL 0x70
%define LOAD 0x90
%define SOURCE 0x110

%define source_sector 10

; 80 x 25
mov ah, 0x00
mov al, 0x03
int 0x10

; box cursor
mov ch, 0
mov cl, 7
mov ah, 1
int 10h

; load source ;
mov ax, SOURCE
mov es, ax
mov bx, 0
mov al, 50  ; 25KiB ;
mov cl, source_sector

call load_sector

; print info ;
mov ax, LOAD
mov ds, ax
mov si, info
call print

mov ah, 0x00
int 0x16
jmp SHELL:0x0000

load_sector:
    mov ch, 0
    mov dh, 0
    mov dl, 0x00    ; floppy ;
    mov ah, 0x02
    int 0x13
    jc .err
    ret
    
    .err:
    mov si, error_sector
    call print
    ret

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

info db 10, ' Source file has been loaded', 10,
     db ' Use "view" command to check out the result', 10, 10,
     db ' Press any key to exit...', 0

error_sector db 'Failed to load sector!', 0
