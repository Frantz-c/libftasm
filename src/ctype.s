; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    ctype.s                                          .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/05/02 11:16:40 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/05/02 11:19:21 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.text
	global	_ft_isalnum
	global	_ft_isalpha
	global	_ft_isascii
	global	_ft_isdigit
	global	_ft_isprint

_ft_isalnum:
		push		rbp
		mov			rbp,		rsp
		push		rdi
		call		_ft_isalpha
		mov			cl,			1
		test		eax,		eax
		jne			.return
		mov			edi,		dword [rsp]
		call		_ft_isdigit
		test		eax,		eax
		setne		cl

	.return:
		movzx		eax,		cl
		pop			rdi
		pop			rbp
		ret

_ft_isalpha:
		push		rbp
		mov			rbp,		rsp
		and			edi,		-33
		sub			edi,		'A'
		cmp			edi,		26
		sbb			eax,		eax
		and			eax,		1
		pop			rbp
		ret

_ft_isascii:
		push		rbp
		mov			rbp,		rsp
		cmp			edi,		128
		sbb			eax,		eax
		and			eax,		1
		pop			rbp
		ret

_ft_isdigit:
		push		rbp
		mov			rbp,		rsp
		sub			edi,		'0'
		cmp			edi,		10
		sbb			eax,		eax
		and			eax,		1
		pop			rbp
		ret

_ft_isprint:
		push		rbp
		mov			rbp,		rsp
		sub			edi,		' '
		cmp			edi,		85; (tilde - space, 126 - 32 = 84)
		sbb			eax,		eax
		and			eax,		1
		pop			rbp
		ret
