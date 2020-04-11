%macro scall 4
mov rax, %1
mov rdi, %2
mov rsi, %3
mov rdx, %4
Syscall
%endmacro
Section .data

array: dd 50.5, 50.4, 50.3, 50.2, 50.1
point: db "."
ptlen: equ $-point

msg1: db "Mean: "
len1: equ $-msg1
msg2: db "Varience: "
len2: equ $-msg2
msg3: db "Standard Deviation :"
len3: equ $-msg3
msg4: db 0x0A
len4: equ $-msg4


cnt1: db 0
cnt: dw 5
cnt2: db 0
cnt3: db 0
count: db 0



Section .bss

mean: resb 20
varience: resb 20
std_deviation: resb 20
buffer: resb 20
dec: resb 20
result: resb 20
result2: resb 20
Section .text
global _start
_start:

FINIT
FLDZ

mov rsi, array                  ;mean
mov byte[cnt2], 5

up:FADD dword[rsi]
   ADD rsi, 4
   dec byte[cnt2]
   jnz up
FIDIV word[cnt]
FST dword[mean]
scall 1,1,msg1,len1
call print
scall 1,1,msg4,len4



mov rsi, array                  ;varience
mov byte[cnt2], 5
FLDZ
up2:FLDZ
    FADD dword[rsi]
    FSUB dword[mean]
    FMUL ST0
    FADD
    ADD rsi, 4
    dec byte[cnt2]
    jnz up2
    
FIDIV word[cnt]
FST dword[varience]
scall 1,1,msg2,len2
call print
scall 1,1,msg4,len4



FLDZ                           ;standard deviation
FADD dword[varience]
FSQRT
FST dword[std_deviation]
scall 1,1,msg3,len3
call print
scall 1,1,msg4,len4


mov rax, 60                    ; exit
mov rdi, 0
Syscall


print:    
                     ;print
mov word[dec], 100
FIMUL word[dec]
FBSTP tword[buffer]
mov byte[cnt1], 9 
mov rsi, buffer+9
upp:
mov ax, word[rsi]
mov word[result],ax
push rsi
call htoa
pop rsi
dec rsi
dec byte[cnt1]
jnz upp
push rsi
scall 1,1,point,ptlen
pop rsi
mov ax, word[rsi]
mov word[result], ax
call htoa

ret

htoa:                        ;htoa
mov rdi, result2
mov byte[cnt3], 2
mov bl, byte[result]

up4:
rol bl, 04
mov cl, bl
and cl, 0FH
cmp cl, 09
jbe nxt2
add cl, 07
nxt2: 
add cl, 30H
mov byte[rdi], cl
inc rdi
dec byte[cnt3]
jnz up4
scall 1,1,result2,2
ret
