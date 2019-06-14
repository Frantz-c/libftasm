; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/05/24 12:50:06 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/06/11 14:53:59 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.data
	lower_bit_mask:	dq	0x0101010101010101
	upper_bit_mask:	dq	0x8080808080808080

section	.text
	global	_ft_bzero
	global	_ft_memccpy
	global	_ft_memchr
	global	_ft_memcpy
	global	_ft_memmove
	global	_ft_memset

	extern	_dumpregs

_ft_bzero:
		xor				eax,				eax
		mov				rcx,				rsi
		rep				stosb
		ret

_ft_memccpy:
		push			rbp
		mov				rbp,				rsp
		push			r15
		push			r14
		push			r12
		push			rbx
		mov				r12,				rcx
		mov				r15,				rsi
		mov				r14,				rdi
		xor				rax,				rax
		test			r12,				r12
		je				.return
		mov				rdi,				r15
		mov				esi,				edx
		mov				rdx,				r12
		call			_ft_memchr
		mov				rbx,				rax
		test			rax,				rax
		je				.full_copy
		sub				rbx,				r15
		lea				rdx,				[rbx + 1]
		mov				rdi,				r14
		mov				rsi,				r15
		call			_ft_memmove
		lea				rax,				[r14 + rbx + 1]
		jmp				.return

	.full_copy:
		mov				rdi,				r14
		mov				rsi,				r15
		mov				rdx,				r12
		call			_ft_memmove
		xor				rax,				rax

	.return:
		pop				rbx
		pop				r12
		pop				r14
		pop				r15
		pop				rbp
		ret

_ft_memchr:
		mov				r9,					[rel lower_bit_mask]
		mov				r10,				[rel upper_bit_mask]
		and				rsi,				0xff
		imul			rsi,				r9
		cmp				rdx,				32
		jb				.loop_8
		movq			xmm0,				rsi
		vpbroadcastb	ymm0,				xmm0

	.loop_32:
		vmovups			ymm1,				[rdi]
		vpcmpeqb		ymm1,				ymm0
		vpmovmskb		eax,				ymm1
		test			eax,				eax
		jne				.return_32
		add				rdi,				32
		sub				rdx,				32
		cmp				rdx,				32
		jae				.loop_32

	.loop_8:
		cmp				rdx,				8
		jb				.loop_1
		mov				rax,				qword [rdi]
		xor				rax,				rsi
		mov				rcx,				rax
		sub				rax,				r9
		not				rcx
		and				rcx,				rax
		and				rcx,				r10
		jnz				.loop_1
		add				rdi,				8
		sub				rdx,				8
		jmp				.loop_8

	.loop_1:
		test			rdx,				rdx
		je				.return_null
		mov				al,					byte [rdi]
		cmp				al,					sil
		je				.return_1
		inc				rdi
		dec				rdx
		jmp				.loop_1

	.return_32:
		bsf				eax,				eax
		add				rax,				rdi
		ret

	.return_1:
		mov				rax,				rdi
		ret

	.return_null:
		xor				rax,				rax
		ret

_ft_memcpy:
		mov				rax,				rdi
		mov				rcx,				rdx
		rep				movsb
		ret

_ft_memmove:
		cmp				rdi,				rsi
		jbe				_ft_memcpy
		lea				rax,				[rsi + rdx]
		cmp				rdi,				rax
		jge				_ft_memcpy
		mov				rax,				rdi

	.loop_32:
		cmp				rdx,				32
		jb				.loop_8
		sub				rdx,				32
		vmovups			ymm0,				[rsi + rdx]
		vmovups			[rdi + rdx],		ymm0
		jmp				.loop_32

	.loop_8:
		cmp				rdx,				8
		jb				.loop_1
		sub				rdx,				8
		mov				r10,				qword [rsi + rdx]
		mov				qword [rdi + rdx],	r10
		jmp				.loop_8
	
	.loop_1:
		test			rdx,				rdx
		je				.return
		dec				rdx
		mov				r10b,				byte [rsi + rdx]
		mov				byte [rdi + rdx],	r10b
		jmp				.loop_1

	.return:
		ret

_ft_memset:
		push			rdi
		mov				eax,				esi
		mov				rcx,				rdx
		rep				stosb
		pop				rax
		ret
