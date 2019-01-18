[bits 16]

%define SHELL 0x70
%define SOURCE 0x110

%define ESC 0x01
%define ENTER 0x1C
%define BACKSPACE 0x0E

cld

; 80 x 25
mov ah, 0x00
mov al, 0x03
int 0x10

; box cursor
mov ch, 0
mov cl, 7
mov ah, 1
int 10h

; set extra/data segments ;
mov ax, SOURCE
mov ds, ax
mov es, ax
mov si, 0
call print

mov di, 0

calc_offset:
    cmp byte [di], 0
    je edit_loop
    inc di
    jmp calc_offset

edit_loop:
    mov ah, 0x00
    int 0x16

    ; return on ESC pressed ;
    cmp ah, ESC
    je .return

    ; add new line ;
    cmp ah, ENTER
    je .new_line

    ; erase character ;
    cmp ah, BACKSPACE
    je .erase

    .echo:
        mov ah, 0x0E
        int 0x10
        stosb
            
    jmp edit_loop

    .new_line:
        mov al, 10
        mov ah, 0x0E
        int 0x10
        stosb
        mov al, 13
        jmp .echo

    .erase:
        mov ah, 0x03
        int 0x10
        cmp dl, 0
        je edit_loop
        ; erase char on screen ;
        mov ah, 0x0E
        mov al, 8
        int 0x10
        mov ah, 0x0E
        mov al, 0
        int 0x10
        mov ah, 0x0E
        mov al, 8
        int 0x10

        ; erase char in buffer ;
        mov al, 0
        dec di
        stosb
        dec di
        jmp edit_loop

    .return:
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