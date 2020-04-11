%macro write 2
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
array: dq 1111111111111111H , 3333333333333333H , 8000000000000000H , 1000000000000000H , 2000000000000001H
arrtemp: dq 0000000000000000H, 0000000000000000H, 0000000000000000H, 0000000000000000H, 0000000000000000H
m1 db 'Original address :-',0xa
l1 equ $ - m1  
m2 db 'Original data :-',0xa
l2 equ $ - m2
m3 db 'Non-overlap address :-',0xa
l3 equ $ - m3
m4 db 'Non-overlap data :-',0xa
l4 equ $ - m4
m5 db 'Overlap address :-',0xa
l5 equ $ - m5
m6 db 'Overlap data :-',0xa
l6 equ $ - m6
m7 db 'Non-overlap string address :-',0xa
l7 equ $ - m7
m8 db 'Non-overlap string data :-',0xa
l8 equ $ - m8
m9 db 'Overlap string address :-',0xa
l9 equ $ - m9
m10 db 'Overlap string data :-',0xa
l10 equ $ - m10



section .bss
address : resb 16
count1: resb 1
count2: resb 1
space : resb 1

section .text
global _start
_start:

mov byte[space] , 0AH

write l1, m1
mov byte[count1] , 5
mov rsi , array

begin1:
mov rbx , rsi
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin1


;end1

write l2, m2

mov byte[count1] , 5
mov rsi , array

begin2:
mov rbx , qword[rsi]
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin2


;end1data


mov byte[count1] , 5
mov rsi , array
mov rdi , array + 80
loop1:
mov rbx , qword[rsi]
mov qword[rdi] , rbx
add rsi , 8
add rdi , 8
dec byte[count1]
jnz loop1


;end2 nonoverlap transfer

write l3, m3

mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+80

begin3:
mov rbx , rsi
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin3

;end2

write l4, m4
mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+80

begin4:
mov rbx , qword[rsi]
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin4

;end2data


mov byte[count1] , 5
mov rsi , array
mov rdi , arrtemp
loop2:
mov rbx , qword[rsi]
mov qword[rdi] , rbx
add rsi , 8
add rdi , 8
dec byte[count1]
jnz loop2

mov byte[count1] , 5
mov rsi , arrtemp
mov rdi , array+24
loop3:
mov rbx , qword[rsi]
mov qword[rdi] , rbx
add rsi , 8
add rdi , 8
dec byte[count1]
jnz loop3


write l5, m5

mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+24

begin5:
mov rbx , rsi
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin5

write l6, m6

mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+24

begin6:
mov rbx , qword[rsi]
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin6

mov rsi, array
mov rdi, array+100
mov rcx, 5
cld
rep movsq

write l7, m7

mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+100

begin7:
mov rbx , rsi
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin7

write l8, m8
mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+100

begin8:
mov rbx , qword[rsi]
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin8


mov rsi, array
mov rdi, arrtemp
mov rcx, 5
cld
rep movsq

mov rsi, arrtemp
mov rdi, array+24
mov rcx, 5
cld
rep movsq


write l9, m9

mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+24

begin9:
mov rbx , rsi
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin9

write l10, m10
mov byte[space] , 0AH
mov byte[count1] , 5
mov rsi , array+24

begin10:
mov rbx , qword[rsi]
push rsi
call htoa

pop rsi
add rsi , 8
dec byte[count1]
jnz begin10



mov rax , 60
mov rdi , 0
syscall





htoa:
mov rsi , address
mov byte[count2] , 16

up1:
rol rbx , 4
mov cl , bl
and cl , 0FH
cmp cl , 9
jbe next1
add cl , 7

next1:
add cl , 30H
mov byte[rsi] , cl
inc rsi
dec byte[count2] 
jnz up1

write 16 , address
write 1 , space

ret































