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

mov ax, 0x50
mov ds, ax

mov si, 0
call print_str


push ax
mov ax,cs
mov ds,ax
mov es,ax
pop ax
;push testt
;call print
push axx
push ax
call tohex

push bxx
push bx
call tohex

push cxx
push cx
call tohex

push dxx
push dx
call tohex

push css
push cs
call tohex

push dss
push ds
call tohex

push sss
push ss
call tohex

push ess
push es
call tohex

push spp
push sp
call tohex

push sii
push si
call tohex

push dii
push di
call tohex

push gss
push gs
call tohex


push fss
push fs
call tohex


jmp $

print_str:
    mov ah, 0x0E

    .next_char:
    lodsb
    cmp al, 0
    je .end
    int 0x10
    jmp .next_char
    .end:
    ret


print:	;print a zero terminated string
	pusha
	mov bp,sp
	mov si,[bp+18] 
	cont:
		lodsb
		or al,al
		jz dne
		mov ah,0x0e
		mov bx,0
		mov bl,7
		int 10h
		jmp cont
	dne:
		mov sp,bp
		popa
		ret




tohex:
	pusha
	mov bp,sp
	mov dx, [bp+20]
	push dx	
	call print
	mov dx,[bp+18]

	mov cx,4
	mov si,hexc
	mov di,hex+2
	
	stor:
	
	rol dx,4
	mov bx,15
	and bx,dx
	mov al, [si+bx]
	stosb
	loop stor
	push hex
	call print
	mov sp,bp
	popa
	ret
hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
testt db "hello",10,13,0
css db "CS: ",0
dss db "DS: ",0
sss db "SS: ",0
ess db "ES: ",0
gss db "GS: ",0
fss db "FS: ",0
axx db "AX: ",0
bxx db "BX: ",0
cxx db "CX: ",0
dxx db "DX: ",0
spp db "SP: ",0
bpp db "BP: ",0
sii db "SI: ",0
dii db "DI: ",0

