; **************************************************************************** ;
;                                                           LE - /             ;
;                                                               /              ;
;    memset.s                                         .::    .:/ .      .::    ;
;                                                  +:+:+   +:    +:  +:+:+     ;
;    By: fcordon <marvin@le-101.fr>                 +:+   +:    +:    +:+      ;
;                                                  #+#   #+    #+    #+#       ;
;    Created: 2019/04/17 19:20:26 by fcordon      #+#   ##    ##    #+#        ;
;    Updated: 2019/04/17 19:20:26 by fcordon     ###    #+. /#+    ###.fr      ;
;                                                          /                   ;
;                                                         /                    ;
; **************************************************************************** ;

; rdi, rsi, rdx, rcx, r8, r9

section	.text
global	_ft_memset

_ft_memset:
	push			rbp
	mov				rbp, rsp
	mov				rax, rdi
	and				rsi, 0xff
	mov				r8, 0x0101010101010101
	imul			rsi, r8
	movq			xmm0, rsi
	movlhps			xmm0, xmm0
	vpbroadcastb	ymm0, xmm0

	cmp		rdx, 0x20
	jb		write_8_bytes.sub

	alignement:
		vmovups	[rdi], ymm0
		add		rdi, 0x20
		and		rdi, -0x20
		mov		rcx, rdi
		sub		rcx, rax
		sub		rdx, rcx

		cmp		rdx, 0x40
		jb		write_16_bytes.sub
		cmp		rdx, 0x80
		jb		write_64_bytes.sub

	write_128_bytes:

		.sub:
			sub		rdx, 0x80
			jb		write_128_bytes.add

		vmovaps		[rdi], ymm0
		vmovaps		[rdi + 0x20], ymm0
		vmovaps		[rdi + 0x40], ymm0
		vmovaps		[rdi + 0x60], ymm0
		add			rdi, 0x80
		jmp			write_128_bytes.sub

		.add:

			add		rdx, 0x80
			je		end

			sub		rdx, 0x80
			vmovups	[rdi + rdx], ymm0
			vmovups	[rdi + rdx + 0x20], ymm0
			vmovups	[rdi + rdx + 0x40], ymm0
			vmovups	[rdi + rdx + 0x60], ymm0
			jmp		end

	write_64_bytes:
		vmovaps		[rdi], ymm0
		vmovaps		[rdi + 0x20], ymm0
		add			rdi, 0x40

		.sub:
			sub		rdx, 0x40
			jae		write_64_bytes

			add		rdx, 0x40
			je		end

			sub		rdx, 0x40
			vmovups	[rdi + rdx], ymm0
			vmovups	[rdi + rdx + 0x20], ymm0
			jmp		end

	write_16_bytes:
		movaps		[rdi], xmm0
		add			rdi, 0x10

		.sub:
			sub		rdx, 0x10
			jae		write_16_bytes

			add		rdx, 0x10
			je		end

			sub		rdx, 0x10
			movups	[rdi + rdx], xmm0
			jmp		end


	write_8_bytes:
		mov		qword [rdi + rdx], rsi

		.sub:
			sub		rdx, 0x8
			jae		write_8_bytes

			add		rdx, 0x8
			jne		write_1_byte

			pop		rbp
			ret


	write_1_byte:
		mov		byte [rdi + rdx - 1], sil
		sub		rdx, 0x1
		jne		write_1_byte

	end:
		pop		rbp
		ret
