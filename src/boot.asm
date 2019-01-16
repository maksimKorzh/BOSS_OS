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
;                                 Boot loader                                     ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;
;                                                                                 ;
;   Features:                                                                     ;
;                                                                                 ;
;       - sets segment registers                                                  ;
;       - implements stack                                                        ;
;       - loads system shell and file list to RAM                                 ;
;       - prints welcome message                                                  ;
;       - waits for key press                                                     ;
;       - executes system shell                                                   ;
;                                                                                 ;
;---------------------------------------------------------------------------------;
;*********************************************************************************;

%define FILES 0x50
%define SHELL 0x70

%define files_sector 2
%define shell_sector 3

%define floppy 0x00


start:
    ; clear direction flag
    cld

    ; set up data segment
    mov ax, 0x7C0
    mov ds, ax

    ; set up stack segment and stack pointer
    cli
    mov ss, ax
    mov sp, 0
    sti

    ; set up extra segments
    mov ax, SHELL
    mov es, ax
    mov bx, 0
    mov cl, shell_sector
    
    call load_sector

    mov ax, FILES
    mov es, ax
    mov bx, 0
    mov cl, files_sector
    
    call load_sector

    jmp SHELL:0x0000

load_sector:
    mov al, 1
    mov ch, 0
    mov dh, 0
    mov dl, floppy
    mov ah, 0x02
    int 0x13
    jc .err
    ret
    
    .err:
    mov si, error
    call print
    jmp $    

print:
    cld
    mov ah, 0x0E

    .next_char:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .next_char
    
    .end:
    ret

error db 'Failed to load sector!', 0

times 510 - ($ - $$) db 0
dw 0xAA55
