section		.text
global	_ft_bzero

_ft_bzero:
push	rbp
mov		rbp,	rsp
pxor	xmm0,	xmm0
test	rsi,	rsi
jmp		bzero_check

bzero_fill:
and		byte [rdi],	0
inc		rdi
dec		rsi

bzero_check:
jz		bzero_ret
mov		rdx,	rdi
and		rdx,	15
jz		bzero_check_aligned
jmp		bzero_fill

bzero_fill_aligned:
movaps	[rdi],	xmm0
add		rdi,	16
sub		rsi,	16

bzero_check_aligned:
cmp		rsi,	16
jl		bzero_check_last
jmp		bzero_fill_aligned

bzero_fill_last:
and		byte [rdi],	0
inc		rdi
dec		rsi

bzero_check_last:
test	rsi,	rsi
jz		bzero_ret
jmp		bzero_fill_last

bzero_ret:
pop		rbp
ret
