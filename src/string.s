; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    string.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: mhouppin <mhouppin@le-101.fr>              +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/26 11:22:28 by mhouppin     #+#   ##    ##    #+#        ;
;    Updated: 2019/04/26 13:44:32 by mhouppin    ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.text
	global	_ft_bzero
	global	_ft_memchr
	global	_ft_memcpy
	global	_ft_memset

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
