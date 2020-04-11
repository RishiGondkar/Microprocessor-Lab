section .data
arr : dq 1111111111111111H , 3333333333333333H , 8000000000000000H , 9000000000000000H , 8000000000000001H
pos : db 0
neg : db 0
count : db 5

section .text
global _start
_start:

mov rsi , arr

up:
	mov rax , qword[rsi]
	BT rax , 63
	jc next
	inc byte[pos]
	add rsi , 8
	dec byte[count]
	jnz up
	jmp next2

next:
	inc byte[neg]
	add rsi , 8
	dec byte[count]
	jnz up
	jmp next2

next2:
	cmp byte[pos] , 9
	jbe next3
	add byte[pos] , 7H
	

next3:
	add byte[pos] , 30H
	cmp byte[neg] , 9
	jbe next4
	add byte[neg] , 7H
	

next4:
	add byte[neg] , 30H

	mov rdi , 1
	mov rax , 1
	mov rsi , pos
	mov rdx , 1
	syscall

	mov rdi , 1
	mov rax , 1
	mov rsi , neg
	mov rdx , 1
	syscall

	mov rax , 60
	mov rdi , 0
	syscall






