default rel

global _start

SECTION .text align=1 exec

_start:
        mov     r8b, COUNT_FROM
        mov     r9b, MULTIPLY_BY_3
        mov     edi, STDOUT
        mov     r10b, MULTIPLY_BY_5
loop_start:
        mov     eax, r8d
        xor     edx, edx
        imul    eax, r9d
        cmp     al, FIZZ_CMP
        ja      after_fizz
        mov     eax, edi
        lea     rsi, [FIZZ]
        mov     edx, FIZZ_LEN
        syscall
after_fizz:
        mov     eax, r8d
        imul    eax, r10d
        cmp     al, BUZZ_CMP
        ja      maybe_number
        mov     eax, edi
        lea     rsi, [BUZZ]
        mov     edx, BUZZ_LEN
        jmp     write_buffer

maybe_number:
        test    dl, dl
        jnz     write_newline
        cmp     r8b, WITHIN_SINGLE_DIGIT
        jle     one_digit
        mov     dl, 10
        movsx   ax, r8b
        idiv    dl
        lea     edx, [rax+ZERO]
        movzx   eax, ah
        add     eax, ZERO
        mov     byte [rsp-3H], dl
        mov     edx, TEN_DECIMAL_LENGTH
        mov     byte [rsp-2H], al
        jmp     number_ready

one_digit:
        lea     eax, [r8+ZERO]
        mov     edx, DIGIT_DECIMAL_LENGTH
        mov     byte [rsp-3H], al
number_ready:
        mov     eax, edi
        lea     rsi, [rsp-3H]
write_buffer:
        syscall
write_newline:
        mov     eax, edi
        lea     rsi, [NEWLINE]
        mov     edx, NEWLINE_LEN
        syscall
        inc     r8d
        cmp     r8b, COUNT_TO
        jne     loop_start
        mov     eax, SYS_EXIT
        xor     edi, edi
        syscall

SECTION .rodata align=1 noexec

STDOUT               equ 1
SYS_WRITE            equ 1
SYS_EXIT             equ 60

COUNT_FROM           equ 1
COUNT_TO             equ 101   ; Exclusive

; FizzBuzz thresholds and multipliers (mod 256 inverse)
MULTIPLY_BY_3        equ 171    ; 3 * 171 ≡ 1 (mod 256)
MULTIPLY_BY_5        equ 205    ; 5 * 205 ≡ 1 (mod 256)
FIZZ_CMP             equ 85     ; if (n*171) & 0xFF <= 85 -> divisible by 3
BUZZ_CMP             equ 51     ; if (n*205) & 0xFF <= 51 -> divisible by 5

TEN_DECIMAL_LENGTH   equ 2      ; 10
DIGIT_DECIMAL_LENGTH equ 1      ; 1

WITHIN_SINGLE_DIGIT  equ 9      ; 1..=9

ZERO                 equ '0'

FIZZ                 db 'Fizz'
BUZZ                 db 'Buzz'
NEWLINE              db `\n`

FIZZ_LEN             equ 4
BUZZ_LEN             equ 4
NEWLINE_LEN          equ 1

