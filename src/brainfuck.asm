[bits 16]

%define SHELL 0x70
%define SOURCE 0x110
%define PROGMEM 0x07E0

; 80 x 25
mov ah, 0x00
mov al, 0x03
int 0x10

; box cursor
mov ch, 0
mov cl, 7
mov ah, 1
int 10h

; init data segment ;
mov ax, SOURCE
mov ds, ax
mov si, 0

; set segment registers ;
mov ax, PROGMEM
mov es, ax
mov di, 0
call init_progmem

execute:
    mov di, 0x7E00  ; init data pointer ;
    
    .next_instruction:
        cld
        lodsb

        cmp al, 0
        je .return

        ;mov ah, 0x0E
        ;int 0x10
        ;mov ah, 0x00
        ;int 0x16
        
        cmp al, '>'
        je .inc_pointer
        cmp al, '<'
        je .dec_pointer
        cmp al, '+'
        je .inc_data
        cmp al, '-'
        je .dec_data
        cmp al, '.'
        je .output_char
        cmp al, ','
        je .input_char
        cmp al, '['
        je .start_loop
        cmp al, ']'
        je .end_loop
        jmp .next_instruction

    .inc_pointer:
        inc di
        jmp .next_instruction

    .dec_pointer:
        dec di
        jmp .next_instruction

    .inc_data:
        inc byte [di]
        jmp .next_instruction

    .dec_data:
        dec byte [di]
        jmp .next_instruction

    .output_char:
        mov ah, 0x0E
        mov al, byte [di]
        int 0x10
        jmp .next_instruction

    .input_char:
        mov ah, 0x00
        int 0x16
        mov byte [di], al
        jmp .next_instruction

    .start_loop:
        cmp byte [di], 0
        je .process_start
        jmp .next_instruction

        .process_start:
            mov cl, 1   ; cl - loop count

            .find_end_bracket:
                lodsb

                .test_open:
                    cmp al, '['
                    je .inc_loop

                .test_close:
                    cmp al, ']'
                    je .dec_loop

                .test_loop_count:
                    cmp cl, 0
                    je .next_instruction
                    
                jmp .find_end_bracket

                .inc_loop:
                    inc cl                
                    jmp .test_close

                .dec_loop:
                    dec cl
                    jmp .test_loop_count

    .end_loop:
        mov cl, 1   ; cl - loop count ;
        sub si, 2
       
        .find_start_bracket:
            std
            lodsb

            .test_open1:
                cmp al, '['
                je .dec_loop1

            .test_close2:
                cmp al, ']'
                je .inc_loop1
 
            .test_loop_count1:
                cmp cl, 0
                je .inc_source

            jmp .find_start_bracket

            .dec_loop1:
                dec cl
                jmp .test_close2

            .inc_loop1:
                inc cl
                jmp .test_loop_count1

            .inc_source:
                cld
                lodsb
                jmp .next_instruction

    .return:
        ; wait for any key pressed and return ;
        mov ah, 0x00
        int 0x16
        jmp SHELL:0x0000

init_progmem:
    mov cx, 0

    .next_word:
        mov al, 0
        stosb
        inc cx
        cmp cx, 30000
        je .return
        jmp .next_word

    .return:
        ret
