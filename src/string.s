; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/26 11:22:28 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/05/02 11:16:50 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.text
	global	_ft_bzero
	global	_ft_memcpy
	global	_ft_memset
	global	_ft_strcat
	global	_ft_strcpy
	global	_ft_strlen

_ft_bzero:
		push		rbp
		mov			rbp,		rsp
		mov			rcx,		rsi
		xor			al,			al
		rep			stosb
		pop			rbp
		ret

_ft_memcpy:
		push		rbp
		mov			rbp,		rsp
		push		rdi
		mov			rcx,		rdx
		rep			movsb
		pop			rax
		pop			rbp
		ret

_ft_memset:
		push		rbp
		mov			rbp,		rsp
		push		rdi
		mov			rcx,		rdx
		mov			al,			sil
		rep			stosb
		pop			rax
		pop			rbp
		ret

_ft_strcat:
		push		rbp
		mov			rbp,		rsp
		push		r10
		push		r11
		mov			r10,		rdi
		mov			r11,		rsi
		call		_ft_strlen
		lea			rdi,		[r10 + rax]
		mov			rsi,		r11
		call		_ft_strcpy
		mov			rax,		r11
		pop			r11
		pop			r10
		pop			rbp
		ret

_ft_strcpy:
		push		rbp
		mov			rbp,		rsp
		push		r10
		push		r11
		mov			r10,		rdi
		mov			r11,		rsi
		mov			rdi,		rsi
		call		_ft_strlen
		lea			rdx,		[rax + 1]
		mov			rdi,		r10
		mov			rsi,		r11
		pop			r11
		pop			r10
		pop			rbp
		jmp			_ft_memcpy

_ft_strlen:
		push		rbp
		mov			rbp,		rsp
		push		rdi
		xor			al,			al
		mov			rcx,		-1
		repne		cmpsb
		pop			rax
		neg			rax
		add			rax,		rdi
		dec			rax
		pop			rbp
		ret
