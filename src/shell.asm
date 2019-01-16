;*********************************************************************************;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;                                      BOSS                                       ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;                           Bare Operating System Shell                           ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;                                by Maksim Korzh                                  ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;       THIS PROGRAM IS FREE SOFTWARE. IT COMES WITHOUT ANY WARRANTY, TO          ;
;        THE EXTENT PERMITTED BY APPLICABLE LAW. YOU CAN REDISTRIBUTE IT          ;
;       AND/OR MODIFY IT UNDER THE TERMS OF THE DO WHAT THE FUCK YOU WANT         ;
;          TO PUBLIC LICENCE, VERSION 2, AS PUBLISHED BY SAM HOCEVAR.             ;
;                SEE http://www.wtfpl.net/ FOR MORE DETAILS.                      ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;                   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE                   ;
;                           Version 2, December 2004                              ;
;                                                                                 ;
;        Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>                         ;
;                                                                                 ;
;        Everyone is permitted to copy and distribute verbatim or modified        ;
;        copies of this license document, and changing it is allowed as long      ;
;        as the name is changed.                                                  ;
;                                                                                 ;
;                   DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE                   ;
;          TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION        ;
;                                                                                 ;
;         0. You just DO WHAT THE FUCK YOU WANT TO.                               ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;---------------------------------------------------------------------------------;
;             please let me know if you find this code/project useful             ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;         Copyright © 2019  Maksim Korzh  <freesoft.for.people@gmail.com>         ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;

[bits 16]

;*********************************************************************************;
;---------------------------------------------------------------------------------;
;                                                                                 ;
;                                 System shell                                    ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;

%define ESC 0x01
%define LEFT 0x4B
%define RIGHT 0x4D
%define ENTER 0x1C
%define BACKSPACE 0x0E

mov ax, cs
mov ds, ax
mov es, ax

call set_video_mode
call display_prompt
    
shell_loop:
    call reset_input
    call update_shell
    call read_command

    ; check if command was printed
    cmp byte [user_input], 0
    je .no_input

    call update_shell
    
    ; search command
    call search_command

    mov ah, 0x00
    int 0x16        

    ; infinite loop
    jmp shell_loop

    .no_input:
        jmp shell_loop

reset_input:
    mov di, user_input
    mov al, 0
    times 20 stosb
    ret
   
update_shell:
    call set_video_mode
    call display_prompt
    ret

set_video_mode:
    ; 80 x 25
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; set cursor position
    mov ah, 0x02
    mov dh, 23
    mov dl, 0
    int 0x10

    ; box cursor
    mov ch, 0
 	mov cl, 7
 	mov ah, 1
 	int 10h
    ret

display_prompt:
    ; set character attribute
    mov ah, 0x09
    mov bl, 0x02
    int 0x10

    ; print command prompt
    mov si, prompt
    call print
    ret

read_command:
    mov di, user_input

    .next_byte:
        ; get user input from keyboard
        mov ah, 0x00
        int 0x16

        ; return on Enter key pressed
        cmp ah, ENTER
        je .return
        
        ; store and print input character
        stosb
        mov ah, 0x0E
        int 0x10
        jmp .next_byte

    .return:
        ret

search_command:
    mov bx, 0
    
    .next_command:
        mov ax, word [command_table + bx]
        cmp ax, end_command
        je .return
        add bx, 2
        call compare_command

        ;mov ah, 0x0E
        ;mov al, cl
        ;int 0x10

        cmp cl, 1
        je .execute
        
        jmp .next_command

        .invalid_command:
            mov si, error_no_command
            call print
            mov ah, 0x00
            int 0x16
            jmp .next_command

        .execute:
            mov si, found_command
            call print
            ret

        .return:
            mov si, error_no_command
            call print        
            ret

compare_command:
    cld
    mov di, user_input
    mov si, ax
    
    .next_byte:
        lodsb
        scasb
        jne .return_false 
        cmp al, 0
        je .return_true
        jmp .next_byte    
    
        .return_true:
            mov cl, 1
            ret

        .return_false:
            mov cl, 0
            ret

;jmp $

print:
    ;pusha
    cld
    mov ah, 0x0E

    .next_char:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .next_char
    
    .end:
    ;popa
    ret

prompt db ' BOSS $ ', 0
error_no_command db 'No such command!', 0
error_no_input db 'Enter a valid command!', 0
found_command db 'found command!', 0

user_input times 20 db 0

command_help db 'help', 0
command_clear db 'lang', 0
command_list db 'list', 0
command_view db 'view', 0
command_edit db 'edit', 0
end_command db  0
command_table dw command_help, command_clear, command_list, command_view, command_edit, end_command, 0
