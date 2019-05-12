global    _main
section   .text
IntInt:
	mov       rax, [rsp + 16]
	mov       rbx, [rsp + 8]
	mov       [rax], rbx
	ret
print:
	mov       rax, [rsp + 8]
	mov       rcx, 0
.loop:
	mov       rbx, 10
	xor       rdx, rdx              ; zero rdx
	div       rbx
	add       rdx, 48               ; Turn into ASCI code
	push      rdx                   ; push last digit to stack
	inc       rcx                   ; rcx represents the digits on stack
	mov       rbx, 1
	cmp       rax, rbx
	jg        .loop                 ; checks if rax is 0
	push      rcx
	mov       rax, 8
	mul       rcx
	mov       rcx, rax
	mov       rax, 0x02000004         ; system call for write
	mov       rdi, 1                  ; file handle 1 is stdout
	mov       rsi, rsp
	add       rsi, 4
	mov       rdx, rcx                ; number of bytes
	syscall
	pop       rcx
.popem:
	dec       rcx
	pop       rax
	mov       rbx, 0
	cmp       rcx, rbx
	jg        .popem
	ret
main:
	push		 0
	mov		  rax, rsp
	add		  rax, 0
	push		 rax
	push		 42
	call		  IntInt
	pop		  rax
	pop		  rax
	mov		  rax,[rsp + 0]
	push		 rax
	call		  print
	pop		  rax
	pop		  rax
	ret
_main:
	call main
	mov       rax, 0x02000001         ; system call for exit
	xor       rdi, rdi                ; exit code 0
	syscall
section   .data
