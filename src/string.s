; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/05/24 12:50:06 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/05/24 14:39:21 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.text
	global	_ft_bzero
	global	_ft_memcpy
	global	_ft_memset
	global	_ft_strcpy
	global	_ft_strdup
	global	_ft_strlen
	global	_ft_strnlen
	
	extern	_malloc

_ft_bzero:
		mov			rcx,			rsi
		xor			eax,			eax
		rep			stosb
		ret

_ft_memcpy:
		mov			rax,			rdi
		mov			rcx,			rdx
		rep			movsb
		ret

_ft_memset:
		mov			r8,				rdi
		mov			rcx,			rdx
		mov			al,				sil
		rep			stosb
		mov			rax,			r8
		ret

_ft_strcpy:
		mov			rcx,			rsi
		and			rsi,			-32
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			[rsi]
		vpmovmskb	rax,			ymm0
		and			rcx,			31
		or			rdx,			-1
		shl			rdx,			cl
		and			rax,			rdx
		jne			.return
		vmovdqa		ymm1,			[rsi + 32]
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			ymm1
		vpmovmskb	rdx,			ymm0
		test		rdx,			rdx
		je			.loop_start
		shl			rdx,			32
		or			rax,			rdx

	.return:
		shr			rax,			cl
		bsf			rdx,			rax
		add			rsi,			rcx
		mov			rax,			rdi
		add			rdx,			1
		jmp			_ft_memcpy
	
	.loop_start:
		vmovdqu		ymm0,			[rsi + rcx]
		vmovdqu		[rdi],			ymm0
		mov			rax,			rdi
		sub			rdi,			rcx
		xor			rcx,			rcx
	
	.loop:
		vmovdqu		[rdi + 32 + rcx],	ymm1
		add			rcx,			32
		vmovdqa		ymm1,			[rsi + 32 + rcx]
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			ymm1
		vpmovmskb	rdx,			ymm0
		test		rdx,			rdx
		je			.loop
		bsf			rdx,			rdx
		add			rcx,			rdx
		vmovdqu		ymm0,			[rsi + 1 + rcx]
		vmovdqu		[rdi + 1 + rcx],	ymm0
		ret

_ft_strdup:
		push		r15
		push		r14
		push		rbx
		mov			r14,			rdi
		call		_ft_strlen
		mov			rbx,			rax
		inc			rbx
		mov			rdi,			rbx
		call		_malloc
		test		rax,			rax
		je			.return
		mov			rdi,			rax
		mov			rsi,			r14
		mov			rdx,			rbx
		call		_ft_memcpy
	
	.return:
		pop			rbx
		pop			r14
		pop			r15
		ret

_ft_strlen:
		mov			rcx,			rdi
		mov			rdx,			rdi
		and			rdi,			-32
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			[rdi]
		vpmovmskb	rsi,			ymm0
		and			rcx,			31
		or			rax,			-1
		shl			rax,			cl
		and			rsi,			rax
		je			.loop

	.return:
		bsf			rax,			rsi
		sub			rdi,			rdx
		add			rax,			rdi
		ret

	.loop:
		add			rdi,			32
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			[rdi]
		vpmovmskb	rsi,			ymm0
		test		rsi,			rsi
		je			.loop
		jmp			.return

_ft_strnlen:
		test		rsi,			rsi
		js			_ft_strlen
		mov			rax,			rsi
		je			.return
		mov			rcx,			rdi
		and			rcx,			31
		or			rdx,			-1
		shl			rdx,			cl
		add			rsi,			rcx
		and			rdi,			-32
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			[rdi]
		vpmovmskb	rcx,			ymm0
		test		rcx,			rcx
		jne			.retlen
		sub			rsi,			32
		jbe			.return

	.loop:
		add			rdi,			32
		vpxor		ymm0,			ymm0
		vpcmpeqb	ymm0,			[rdi]
		vpmovmskb	rcx,			ymm0
		test		rcx,			rcx
		jne			.retlen
		sub			rsi,			32
		ja			.loop

	.return:
		ret
	
	.retlen:
		bsf			rdx,			rcx
		cmp			rsi,			rdx
		jb			.return
		sub			rax,			rsi
		add			rax,			rdx
		ret
