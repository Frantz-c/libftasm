; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    stdio.s                                          .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/05/02 11:29:41 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/05/02 11:54:29 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.data
	newline:	db	"\n"

section	.text
	global	_ft_cat
	global	_ft_puts

	extern	_ft_strlen
	extern	_read
	extern	_write

_ft_cat:
		push		rbp
		mov			rbp,		rsp
		push		r10					; save for fildes
		push		r11					; save for buffer
		sub			rsp,		4096
		mov			r10d,		edi
		mov			r11,		rsp
		mov			rsi,		r11
		mov			rdx,		4096
		call		_read
		jmp			.check
	
	.loop:
		mov			edi,		1
		mov			rsi,		r11
		mov			rdx,		rax
		call		_write
		mov			edi,		r10d
		mov			rsi,		r11
		mov			rdx,		4096
		call		_read
	
	.check:
		test		rax,		rax
		jg			.loop
		add			rsp,		4096
		pop			r12
		pop			r11
		pop			r10
		pop			rbp
		ret

_ft_puts:
		push		rbp
		mov			rbp,		rsp
		push		r10
		mov			r10,		rdi
		call		_ft_strlen
		mov			edi,		1
		mov			rsi,		r10
		mov			rdx,		rax
		call		_write
		mov			r10,		rax				; ft_puts result stored in r10
		mov			edi,		1
		lea			rsi,		[rel newline]
		mov			rdx,		1
		call		_write
		mov			rax,		r10				; ft_puts result stored in rax
		pop			r10
		pop			rbp
		ret
