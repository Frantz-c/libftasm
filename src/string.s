; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/17 08:29:23 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/04/17 16:33:04 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.data
	lower_bit_mask	dq			0x0101010101010101
	upper_bit_mask	dq			0x8080808080808080

section	.text
	global	_ft_bzero
	global	_ft_memset

_ft_bzero:
		push		rbp
		mov			rbp,		rsp
		mov			rdx,		rsi
		xor			rsi,		rsi
		pxor		xmm0,		xmm0
		mov			rax,		rdi
		cmp			rdx,		64
		jb			.start_8
	.start_64:
		movups		[rdi],		xmm0
		add			rdi,		16
		and			rdi,		-16
		mov			rcx,		rdi
		sub			rcx,		rax
		sub			rdx,		rcx
		sub			rdx,		64
		jbe			.return_64
	.loop_64:
		movaps		[rdi],		xmm0
		movaps		[rdi + 16],	xmm0
		movaps		[rdi + 32],	xmm0
		movaps		[rdi + 48],	xmm0
		add			rdi,		64
		sub			rdx,		64
		ja			.loop_64
	.return_64:
		movups		[rdi + rdx],		xmm0
		movups		[rdi + rdx + 16],	xmm0
		movups		[rdi + rdx + 32],	xmm0
		movups		[rdi + rdx + 48],	xmm0
		pop			rbp
		ret
	.loop_8:
		mov			qword [rdi + rdx],	rsi
	.start_8:
		sub			rdx,		8
		jae			.loop_8
		add			rdx,		8
		je			.return
	.loop_1:
		mov			byte [rdi + rdx - 1],	sil
		sub			rdx,		1
		jne			.loop_1
	.return:
		pop			rbp
		ret

_ft_memset:
		push		rbp
		mov			rbp,		rsp
		and			rsi,		255
		imul		rsi,		[rel lower_bit_mask]
		movq		xmm0,		rsi
		movlhps		xmm0,		xmm0
		mov			rax,		rdi
		cmp			rdx,		64
		jb			_ft_bzero.start_8
		jmp			_ft_bzero.start_64
