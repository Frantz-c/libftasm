; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    dump.s                                           .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/06/11 11:36:16 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/06/11 12:21:41 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.data
	hex:	db	"0123456789ABCDEF"
	buf:	db	" rrr=0xxxxxxxxxxxxxxxxx ", 10
	len:	dq	23
	reg:	db	" RBP RSP RAX RBX RDI RSI RDX RCX  R8  R9 R10 R11 R12 R13 R14 R15"
	num:	dq	16

section	.text
	global	_dumpregs

_dumpregs:
	push	r15
	push	r14
	push	r13
	push	r12
	push	r11
	push	r10
	push	r9
	push	r8
	push	rcx
	push	rdx
	push	rsi
	push	rdi
	push	rbx
	push	rax
	push	rsp
	push	rbp

	mov		rdi,	0
	lea		rsi,	[rel reg]
	lea		r8,		[rel hex]

nxelt:
	mov		eax,			dword [rsi + 4 * rdi]
	lea		rdx,			[rel buf]
	mov		dword [rdx],	eax

	mov		rax,			qword [rsp + 8 * rdi]

	mov		rcx,			16

nxnyb:
	rol		rax,			4
	mov		bl,				al
	and		rbx,			15
	mov		r9b,			byte [r8 + rbx]
	mov		byte [rdx + 7],	r9b
	inc		rdx
	dec		rcx
	jnz		nxnyb

	push	rdi
	push	rsi
	push	r8
	mov		edi,			1
	lea		rsi,			[rel buf]
	mov		rdx,			25
	mov		rax,			0x2000004
	syscall
	pop		r8
	pop		rsi
	pop		rdi

	inc		rdi
	cmp		rdi,			16
	jne		nxelt

	mov		edi,			1
	lea		rsi,			[rel buf + 24]
	mov		rdx,			1
	mov		rax,			0x2000004
	syscall
	pop		rbp
	pop		rsp
	pop		rax
	pop		rbx
	pop		rdi
	pop		rsi
	pop		rdx
	pop		rcx
	pop		r8
	pop		r9
	pop		r10
	pop		r11
	pop		r12
	pop		r13
	pop		r14
	pop		r15
	ret
