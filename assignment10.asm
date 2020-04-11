
Section .data
ff1: db "%lf + i%lf",10,0
ff2: db "%lf - i%lf",10,0
formatpf: db "%lf",10,0
formatsf: db "%lf",0
msg1: db "Enter a,b,c of quadratic equation",0x0A
len1: equ $-msg1
msg2: db "roots of quadratic equation are",0x0A
len2: equ $-msg2
msg3: db "Discriminant value",0x0A
len3: equ $-msg3

imag: db "Imaginary roots",0x0A
limag: equ $-imag

real: db "Real roots",0x0A
lreal: equ $-real
root1: db "root1:",0x0A
lenroot1: equ $-root1
root2: db "root2:",0x0A
lenroot2: equ $-root2

var1: dw 4  ;4ac wala 4 is here

var2: dw 2  ;2a wala 2 is here                                           
Section .bss

%macro myscanf 1
	mov rdi, formatsf
	mov rax, 0
	sub rsp, 8
	mov rsi, rsp
	call scanf
	mov r8, qword[rsp]
	mov qword[%1], r8
	add rsp, 8
	%endmacro

%macro myprintf 1
	mov rdi, formatpf
	sub rsp, 8
	MOVSD xmm0, [%1]
	mov rax, 1
	call printf
	add rsp, 8
   	%endmacro

%macro imagroot1 2
	mov rdi, ff1
	sub rsp, 8
	MOVSD xmm0, [%1]
	MOVSD xmm1, [%2]
	mov rax, 2
	call printf
	add rsp, 8
   	%endmacro

%macro imagroot2 2
	mov rdi, ff2
	sub rsp, 8
	MOVSD xmm0, [%1]
	MOVSD xmm1, [%2]
	mov rax, 2
	call printf
	add rsp, 8
   	%endmacro
   		
%macro scall 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	Syscall
	%endmacro
a: resb 8
b: resb 8
c: resb 8
b2: resb 8 
ac_4: resb 8
dis: resb 8
sqrtdis: resb 8
a_2: resb 8
root_1: resb 8
root_2: resb 8
x: resb 8
y: resb 8



Section .text
global main
main:
extern printf,scanf          

scall 1,1,msg1,len1
myscanf a
myscanf b
myscanf c

myprintf a
myprintf b
myprintf c

FINIT
FLDZ

FADD qword[b]
FMUL qword[b]
FST qword[b2]

myprintf b2
;----------------------------------------------4ac---------------------------------
FLDZ
FADD qword[a]
FMUL qword[c]
FIMUL word[var1]
FST qword[ac_4]
myprintf ac_4
;--------------------------------------------------b2-4ac---------------------------
FLD qword[b2]
FSUB qword[ac_4]
FST qword[dis]
;------------------------------------------------root of b2-4ac--------------------

FSQRT
FST qword[sqrtdis]
myprintf dis
myprintf sqrtdis
;------------------------------------------calculation of  2a----------------------
FLDZ
FADD qword[a]
FIMUL word[var2]
FST qword[a_2]
myprintf a_2

;----------------------------------print discriminant value-------------------------
;                

;------------------------------------check for real or imag roots-------





mov rax,qword[dis]
BT rax,63                           
jc imag_roots
real_roots:
scall 1,1,real,lreal
	scall 1,1,root1,lenroot1
	FLDZ
	FSUB qword[b]
	FADD qword[sqrtdis]
	FDIV qword[a_2]
	FST qword[root_1]
	myprintf root_1
		
	scall 1,1,root2,lenroot2
	FLDZ
	FSUB qword[b]
	FSUB qword[sqrtdis]
	FDIV qword[a_2]
	FST qword[root_2]
	myprintf root_2
	
jmp exit

imag_roots:
scall 1,1,imag,limag

	FLDZ
	FSUB qword[b]
	FDIV qword[a_2]
	FST qword[x]
	

        FLDZ
	FSUB qword[dis]
	FSQRT 
	FDIV qword[a_2]
	FST qword[y]
	
	scall 1,1,root1,lenroot1
        imagroot1 x,y
        scall 1,1,root2,lenroot2
        imagroot2 x,y

jmp exit



exit:
mov rax, 60
mov rdi, 0
Syscall


