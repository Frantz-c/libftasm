section	.text
	global	_exit

_exit:
	push	rbp
	mov		rbp,	rsp
	and		edi,	255
	mov		rax,	0x2000001
	syscall
	pop		rbp
	ret
