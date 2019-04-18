; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    bzero2.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: fcordon <marvin@le-101.fr>                 +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/17 19:20:26 by fcordon      #+#   ##    ##    #+#        ;
;    Updated: 2019/04/17 19:20:26 by fcordon     ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;


section	.text
global	_ft_bzero

_ft_bzero:
	push	rbp
	mov		rbp, rsp
	xor		r8, r8
	mov		rax, rdi

	cmp		rsi, 0x20
	jb		write_8_bytes.sub

	alignement:
		vxorps	ymm0, ymm0
		vmovups	[rdi], ymm0
		add		rdi, 0x20
		and		rdi, -0x20
		mov		rdx, rdi
		sub		rdx, rax
		sub		rsi, rdx

		cmp		rsi, 0x40
		jb		write_16_bytes.sub
		cmp		rsi, 0x80
		jb		write_64_bytes.sub

	write_128_bytes:

		.sub:
			sub		rsi, 0x80
			jb		write_128_bytes.add

		vmovaps		[rdi], ymm0
		vmovaps		[rdi + 0x20], ymm0
		vmovaps		[rdi + 0x40], ymm0
		vmovaps		[rdi + 0x60], ymm0
		add			rdi, 0x80
		jmp			write_128_bytes.sub

		.add:

			add		rsi, 0x80
			je		end

			sub		rsi, 0x80
			vmovups	[rdi + rsi], ymm0
			vmovups	[rdi + rsi + 0x20], ymm0
			vmovups	[rdi + rsi + 0x40], ymm0
			vmovups	[rdi + rsi + 0x60], ymm0
			jmp		end

	write_64_bytes:
		vmovaps		[rdi], ymm0
		vmovaps		[rdi + 0x20], ymm0
		add			rdi, 0x40

		.sub:
			sub		rsi, 0x40
			jae		write_64_bytes

			add		rsi, 0x40
			je		end

			sub		rsi, 0x40
			vmovups	[rdi + rsi], ymm0
			vmovups	[rdi + rsi + 0x20], ymm0
			jmp		end

	write_16_bytes:
		movaps		[rdi], xmm0
		add			rdi, 0x10

		.sub:
			sub		rsi, 0x10
			jae		write_16_bytes

			add		rsi, 0x10
			je		end

			sub		rsi, 0x10
			movups	[rdi + rsi], xmm0
			jmp		end


	write_8_bytes:
		mov		qword [rdi + rsi], r8

		.sub:
			sub		rsi, 0x8
			jae		write_8_bytes

			add		rsi, 0x8
			jne		write_1_byte

			pop		rbp
			ret


	write_1_byte:
		mov		byte [rdi + rsi - 1], r8b
		sub		rsi, 0x1
		jne		write_1_byte

	end:
		pop		rbp
		ret
