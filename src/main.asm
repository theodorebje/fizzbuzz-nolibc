; Generated from the compiled ELF with `objconv -fnasm` and trimmed slightly.

default rel

global _start

SECTION .text align=1 exec

_start:
        push    rbx
        mov     r8b, 1
        mov     r9b, 171
        mov     edi, 1
        mov     r10b, 205
loop_start:
        mov     eax, r8d
        xor     edx, edx
        imul    eax, r9d
        cmp     al, 85
        ja      after_fizz
        mov     eax, edi
        lea     rsi, [rel fizz]
        mov     edx, 4
        syscall
        mov     dl, 1
after_fizz:
        mov     eax, r8d
        imul    eax, r10d
        cmp     al, 51
        ja      maybe_number
        mov     eax, edi
        lea     rsi, [rel buzz]
        mov     edx, 4
        jmp     write_buffer

maybe_number:
        test    dl, dl
        jnz     write_newline
        cmp     r8b, 100
        jnz     maybe_two_digits
        mov     word [rsp-3H], 12337
        mov     edx, 3
        mov     byte [rsp-1H], 48
        jmp     number_ready

maybe_two_digits:
        cmp     r8b, 9
        jle     one_digit
        mov     dl, 10
        movsx   ax, r8b
        idiv    dl
        lea     edx, [rax+30H]
        movzx   eax, ah
        add     eax, 48
        mov     byte [rsp-3H], dl
        mov     edx, 2
        mov     byte [rsp-2H], al
        jmp     number_ready

one_digit:
        lea     eax, [r8+30H]
        mov     edx, 1
        mov     byte [rsp-3H], al
number_ready:
        mov     eax, edi
        lea     rsi, [rsp-3H]
write_buffer:
        syscall
write_newline:
        mov     eax, edi
        lea     rsi, [rel newline]
        mov     edx, 1
        syscall
        inc     r8d
        cmp     r8b, 101
        jne     loop_start
        mov     eax, 60
        xor     edi, edi
        syscall

SECTION .rodata align=1 noexec

fizz:
        db 46H, 69H, 7AH, 7AH, 00H

buzz:
        db 42H, 75H, 7AH, 7AH, 00H

newline:
        db 0AH, 00H
