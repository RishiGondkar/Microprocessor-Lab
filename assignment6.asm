%macro print 2
mov rax , 1
mov rdi , 1
mov rdx , %1
mov rsi , %2
syscall
%endmacro

%macro read 2
mov rax , 0
mov rdi , 0
mov rdx , %1
mov rsi , %2
syscall
%endmacro


section .data

m1 db 'Contents of Global Descriptor Table are = '
l1 equ $ - m1
m2 db 0x0A,'Contents of Local Descriptor Table are = '
l2 equ $ - m2
m3 db 0x0A,'Contents of Interrupt Descriptor Table are = '
l3 equ $ - m3
m4 db 0x0A,'Contents of Machine Status Word = '
l4 equ $ - m4
m5 db 0x0A,'Contents of Task Register are = '
l5 equ $ - m5

section .bss
msw : resb 2
gdt : resb 6
ldt : resb 2
idt : resb 6
tr : resb 2
count : resb 2
hexnum : resb 16

section .text
global _start
_start:

xor rbx, rbx
mov rsi, gdt
sgdt [rsi]
mov rbx, qword[rsi]
print l1, m1
call htoa

xor rbx, rbx
mov rsi, ldt
sldt word[rsi]
mov bx, word[rsi]
print l2, m2
call htoa

xor rbx, rbx
mov rsi, idt
sidt [rsi]
mov rbx, qword[rsi]
print l3, m3
call htoa


xor rbx, rbx
mov rsi, msw
smsw word[rsi]
mov bx, word[rsi]
print l4, m4
call htoa

xor rbx, rbx
mov rsi, tr
str word[rsi]
mov bx, word[rsi]
print l5, m5
call htoa

mov rax , 60
mov rdi , 0
syscall


htoa:
mov rsi, hexnum
mov byte[count], 16

up1:
rol rbx , 4
mov cl , bl
and cl , 0FH
cmp cl , 9
jbe next5
add cl , 7

next5:
add cl , 30H
mov byte[rsi] , cl
inc rsi
dec byte[count] 
jnz up1

print 16, hexnum
ret
