section .data
fname: db "array.txt",0
msg1: db "Original Array : ",0x0A
len1: equ $-msg1
msg2: db "Ascending Order : ",0x0A
len2: equ $-msg2
msg3: db "Descending Order : ",0x0A
len3: equ $-msg3
noofPasses: db 6
noofComparisons: db 6
count: db 0
arr: db 0,0,0,0,0,0,0
temp: db 0
val: db 10
space: db 20

section .bss
fd: resb 8
length: resb 10
buffer: resb 1000
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

scall 2,fname,2,0777
mov qword[fd],rax

scall 0,[fd],buffer,1000
mov qword[length],rax
mov qword[count],rax

scall 1,1,msg1,len1
scall 1,1,buffer,length

mov byte[count],7
mov rsi,buffer
mov rdi,arr



mov byte[noofPasses],6

loop2:

mov rsi,buffer
mov rdi,buffer+2
mov byte[noofComparisons],6

loop3:

mov al,byte[rdi]
cmp byte[rsi],al
jbe next
mov bl,byte[rsi]
mov cl,byte[rdi]
mov byte[rdi],bl
mov byte[rsi],cl
next:
add rsi,2
add rdi,2
dec byte[noofComparisons]
jnz loop3

dec byte[noofPasses]

jnz loop2

scall 1,1,msg2,len2
scall 1,1,buffer,length
scall 1,[fd],buffer,14


loop4:

mov rsi,buffer
mov rdi,buffer+2
mov byte[noofComparisons],6

loop5:

mov al,byte[rdi]
cmp byte[rsi],al
jae next1
mov bl,byte[rsi]
mov cl,byte[rdi]
mov byte[rdi],bl
mov byte[rsi],cl
next1:
add rsi,2
add rdi,2
dec byte[noofComparisons]
jnz loop5

dec byte[noofPasses]

jnz loop4

scall 1,1,msg3,len3
scall 1,1,buffer,length
scall 1,[fd],buffer,14

mov rax,60
mov rdi,0
syscall