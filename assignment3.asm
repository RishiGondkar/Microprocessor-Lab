section .data
msg: db "1.HEX->BCD",0x0A
     db "2.BCD->Hex",0x0A
     db "3.Exit",0x0A
len: equ $-msg
msg2: db "Enter a Number : "
l1: equ $-msg2
msg3: db "Exiting :",0x0A
l2: equ $-msg3
cnt: db 4H
temp1: db 0
val: db 10

section .bss
result: resb 2
num: resb 5
choice: resb 2
cnt2: resb 1
result2: resb 8
sum: resb 4

%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global main
main:

scall 1,1,msg,len
scall 0,0,choice,2

cmp byte[choice],31H
je next

cmp byte[choice],32H
je next2

cmp byte[choice],33H
je exit

next:
call HtoBCD
jmp main

next2:
call BtoHex
jmp main

exit:
mov rax,60
mov rdi,0
syscall

HtoBCD:

scall 1,1,msg2,l1
scall 0,0,num,5

call AtoH

mov byte[cnt2],4

mov eax,0
mov ax,bx
mov bx,0x0A

loop:
mov dx,0
div bx
push dx
dec byte[cnt2]
jnz loop

mov byte[cnt2],4
mov rdx,0

loop2:
pop dx
mov word[result],dx
add word[result],30H
scall 1,1,result,1
mov dx,00
dec byte[cnt2]
jnz loop2

scall 1,1,val,1

ret

AtoH:
mov rsi,num
mov byte[cnt],4
mov bx,00
up:
rol bx,04
mov dl,byte[rsi]
cmp dl,39H
jbe down
sub dl,07H
down:
sub dl,30H
add bl,dl
inc rsi
dec byte[cnt]
jnz up

ret

BtoHex:

scall 1,1,msg2,l1
scall 0,1,num,5
mov dword[sum],00
mov rax,0
mov rbx,0
mov rcx,0
mov rdx,0

call AtoH

mov cx,bx
mov eax,00H
mov ebx,00H

mov bl,cl
and bl,0FH
mov ax,01H
mul bx
add dword[sum],eax
ror cx,4

mov bl,cl
and bl,0FH
mov ax,0AH
mul bx
add dword[sum],eax
ror cx,4

mov bl,cl
and bl,0FH
mov ax,64H
mul bx
add dword[sum],eax
ror cx,4

mov bl,cl
and bl,0FH
mov ax,03E8H
mul bx
add dword[sum],eax
ror cx,4

mov edx,dword[sum]
call HtoA

ret

HtoA:

mov rsi,result2
mov byte[cnt2],8
up10:
rol edx,04
mov cl,dl
and cl,0FH
cmp cl,09
jbe down1
add cl,07H
down1:
add cl,30H
mov byte[rsi],cl
inc rsi
dec byte[cnt2]
jnz up10

scall 1,1,result2,8
scall 1,1,val,1
ret
