section	.text
global	_ft_bzero

_ft_bzero:
	push	rbp
	mov		rbp, rsp
	xor		r8, r8
	mov		rax, rdi

	cmp		rsi, 0x10
	jb		write_8_bytes.sub

	alignement:
		xorps	xmm0, xmm0
		movups	[rdi], xmm0
		add		rdi, 0x10
		and		rdi, -0x10
		mov		rdx, rdi
		sub		rdx, rax
		sub		rsi, rdx

		cmp		rsi, 0x40
		jb		write_16_bytes

	write_64_bytes:
		movaps		[rdi], xmm0
		movaps		[rdi + 0x10], xmm0
		movaps		[rdi + 0x20], xmm0
		movaps		[rdi + 0x30], xmm0
		add			rdi, 0x40

		.sub:
			sub		rsi, 0x40
			jae		write_64_bytes

			add		rsi, 0x40
			je		end

			sub		rsi, 0x40
			movups	[rdi + rsi], xmm0
			movups	[rdi + rsi + 0x10], xmm0
			movups	[rdi + rsi + 0x20], xmm0
			movups	[rdi + rsi + 0x30], xmm0
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
