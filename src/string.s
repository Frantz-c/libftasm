; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/05/24 12:50:06 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/06/11 10:56:33 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.data
	lower_bit_mask:	dq	0x0101010101010101

section	.text
	global	_ft_bzero
	global	_ft_memcpy
	global	_ft_memmove
	global	_ft_memset

_ft_bzero:
		xor		eax,	eax
		mov		rcx,	rsi
		rep		stosb
		ret

_ft_memcpy:
		mov		rax,	rdi
		mov		rcx,	rdx
		rep		movsb
		ret

_ft_memmove:
		cmp		rdi,	rsi
		jbe		_ft_memcpy
		lea		rax,	[rsi + rdx]
		cmp		rdi,	rax
		jge		_ft_memcpy
		mov		rax,	rdi

	.loop_32:
		cmp		rdx,	32
		jb		.loop_8
		sub		rdx,	32
		vmovups	ymm0,			[rsi + rdx]
		vmovups	[rdi + rdx],	ymm0
		jmp		.loop_32

	.loop_8:
		cmp		rdx,	8
		jb		.loop_1
		sub		rdx,	8
		mov		r10,				qword [rsi + rdx]
		mov		qword [rdi + rdx],	r10
		jmp		.loop_8
	
	.loop_1:
		test	rdx,	rdx
		je		.return
		dec		rdx
		mov		r10b,				byte [rsi + rdx]
		mov		byte [rdi + rdx],	r10b
		jmp		.loop_1

	.return:
		ret

_ft_memset:
		push	rdi
		mov		eax,	esi
		mov		rcx,	rdx
		rep		stosb
		pop		rax
		ret
