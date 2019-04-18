; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    bzero.s                                          .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: fcordon <marvin@le-101.fr>                 +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/13 18:58:41 by fcordon      #+#   ##    ##    #+#        ;
;    Updated: 2019/04/13 18:58:41 by fcordon     ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

section	.text
global	_ft_bzero

; rdi, rsi, rdx, rcx, r8, r9

_ft_bzero:
	push	rbp
	mov		rbp, rsp
	mov		rax, rdi
	xor		r8, r8

	test	rsi, -16
	jz		__8_bytes
	xorps	xmm0, xmm0

	__alignement:
		test	rdi, 0xf
		jz		__64_bytes
		movups	[rdi], xmm0
		add		rdi, 16
		and		rdi, -16
		mov		rdx, rdi
		sub		rdx, rax
		sub		rsi, rdx


	__64_bytes:
		sub		rsi, 64
		jb		__16_bytes_pre

			movaps	[rdi + rsi], xmm0
			movaps	[rdi + rsi + 0x10], xmm0
			movaps	[rdi + rsi + 0x20], xmm0
			movaps	[rdi + rsi + 0x30], xmm0
		ja		__64_bytes

	__16_bytes_pre:
		add		rsi, 64
		je		__end

	__16_bytes:
		test	rsi, -16
		jz		.remainder

		.loop:
			movaps	[rdi], xmm0
			add		rdi, 16
			sub		rsi, 16
			test	rsi, -16
			jnz		.loop

		.remainder:
			test	rsi, rsi
			jz		__end
			lea		rdi, [rdi + rsi - 16]
			movups	[rdi], xmm0
			jmp		__end

	__8_bytes:
		sub		rsi, 8
		jb		__1_byte_pre
		mov		qword [rdi + rsi], r8
		jmp		__8_bytes

	__1_byte_pre:
		add		rsi, 8
		je		__end

	__1_byte:
;		test	rsi, rsi
;		jz		__end

		.loop:
			and		byte [rdi + rsi - 1], 0
			sub		rsi, 1
			jnz		.loop

	__end:
		pop		rbp
		ret


;push	rsi
;push	rdx
;push	rdi
;push	rbp
;sub		rsp, 16
;lea		rdi, [rel fmt]
;call	_puts
;leave
;pop		rbp
;pop		rdi
;pop		rdx
;pop		rsi
