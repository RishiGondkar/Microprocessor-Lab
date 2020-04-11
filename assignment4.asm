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
m1 db 'Multiplicant = '
l1 equ $ - m1
m2 db 'Multiplier = '
l2 equ $ - m2
m3 db 'Product using successive addition = '
l3 equ $ - m3
m4 db 0xa, 'Product using add and shift method = '
l4 equ $ - m4


section .bss
num1 : resb 3
num2 : resb 3
hexnum1 : resb 9
hexnum2 : resb 9
count : resb 1
hexnum : resb 8
space : resb 1

section .text
global _start

_start:

mov byte[space] , 0AH

print l1, m1
read 3, num1
mov rsi, num1
mov byte[count], 2
call atoh
mov qword[hexnum1], rbx

print l2, m2
read 3, num2
mov rsi, num2
mov byte[count], 2
call atoh
mov qword[hexnum2], rbx

xor rax, rax
xor rcx, rcx
xor rdx, rdx

mov rdx, qword[hexnum1]
mov rcx, qword[hexnum2]

loop:
add rax, rdx
dec rcx
jnz loop
mov rbx, rax
print l3, m3
call htoa


xor rax, rax
xor rbx, rbx
xor rcx, rcx
xor rdx, rdx
mov dl, 16H

mov rbx, qword[hexnum2]
mov rcx, qword[hexnum1]

next1:
shr bx, 1
jnc next2
add ax, cx
next2:
shl cx, 1
dec dx
jnz next1

xor rbx, rbx
mov rbx, rax
print l4, m4
call htoa













mov rax , 60
mov rdi , 0
syscall
;------------------------------------------------------------


htoa:
mov rsi , hexnum
mov byte[count] , 16

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

print 16 , hexnum


ret

;-----------------------------------------------------------
atoh:
xor rbx, rbx

up:
rol rbx,4
mov cl,byte[rsi]
cmp cl,39h
jbe next
sub cl,7

next:
sub cl,30h
add bl,cl
inc rsi
dec byte[count]
jnz up

ret
