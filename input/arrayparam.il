	.data
	.string	.int_wformat, "%d\12"
	.string	.float_wformat, "%f\12"
	.string	.char_wformat, "%c\12"
	.string	.string_wformat, "%s\12"
	.string	.int_rformat, "%d"
	.string	.float_rformat, "%f"
	.string	.char_rformat, "%c"
	.string	.string_rformat, "%s"
	.float	.float_const_0, 0.01
	.global	main_fp, 4, 4
	.text
	.frame	main, 40
	loadI	main_fp  => %vr4
	store	%vr0  => %vr4
	loadI	-4  => %vr5
	add	%vr0, %vr5 => %vr6
	call	init, %vr6 
	loadI	-4  => %vr5
	add	%vr0, %vr5 => %vr6
	call	writearray, %vr6 
	loadI	1  => %vr7
	i2i	%vr7  => %vr4
	loadI	10  => %vr8
	comp	%vr4, %vr8 => %vr9
	testgt	%vr9  => %vr10
	cbr	%vr10  -> .L0
.L1:	nop
	i2i	%vr0  => %vr11
	loadI	-4  => %vr5
	add	%vr11, %vr5 => %vr12
	loadI	1  => %vr7
	sub	%vr4, %vr7 => %vr13
	loadI	4  => %vr14
	mult	%vr13, %vr14 => %vr15
	sub	%vr12, %vr15 => %vr16
	load	%vr16  => %vr17
	mult	%vr17, %vr4 => %vr18
	i2i	%vr0  => %vr11
	loadI	-4  => %vr5
	add	%vr11, %vr5 => %vr12
	loadI	1  => %vr7
	sub	%vr4, %vr7 => %vr13
	loadI	4  => %vr14
	mult	%vr13, %vr14 => %vr15
	sub	%vr12, %vr15 => %vr16
	store	%vr18  => %vr16
	i2i	%vr0  => %vr11
	loadI	-4  => %vr5
	add	%vr11, %vr5 => %vr12
	loadI	1  => %vr7
	sub	%vr4, %vr7 => %vr13
	loadI	4  => %vr14
	mult	%vr13, %vr14 => %vr15
	sub	%vr12, %vr15 => %vr16
	call	inc, %vr16 
	loadI	1  => %vr7
	add	%vr4, %vr7 => %vr19
	i2i	%vr19  => %vr4
	loadI	10  => %vr8
	comp	%vr4, %vr8 => %vr9
	testle	%vr9  => %vr10
	cbr	%vr10  -> .L1
.L0:	nop
	loadI	-4  => %vr5
	add	%vr0, %vr5 => %vr6
	call	writearray, %vr6 
	ret
	.frame	init, 0, %vr8
	loadI	1  => %vr9
	i2i	%vr9  => %vr4
	loadI	10  => %vr10
	i2i	%vr10  => %vr5
	loadI	10  => %vr10
	comp	%vr4, %vr10 => %vr11
	testgt	%vr11  => %vr12
	cbr	%vr12  -> .L2
.L3:	nop
	i2f	%vr4  => %vr13
	loadI	.float_const_0  => %vr14
	fload	%vr14  => %vr15
	fmult	%vr13, %vr15 => %vr16
	i2f	%vr5  => %vr17
	fadd	%vr16, %vr17 => %vr18
	f2i	%vr18  => %vr19
	loadI	1  => %vr9
	sub	%vr4, %vr9 => %vr20
	loadI	4  => %vr21
	mult	%vr20, %vr21 => %vr22
	sub	%vr8, %vr22 => %vr23
	store	%vr19  => %vr23
	loadI	1  => %vr9
	add	%vr4, %vr9 => %vr24
	i2i	%vr24  => %vr4
	loadI	1  => %vr9
	add	%vr5, %vr9 => %vr25
	i2i	%vr25  => %vr5
	loadI	10  => %vr10
	comp	%vr4, %vr10 => %vr11
	testle	%vr11  => %vr12
	cbr	%vr12  -> .L3
.L2:	nop
	ret
	.frame	writearray, 0, %vr4
	loadI	1  => %vr5
	loadI	1  => %vr5
	sub	%vr5, %vr5 => %vr6
	loadI	4  => %vr7
	mult	%vr6, %vr7 => %vr8
	sub	%vr4, %vr8 => %vr9
	load	%vr9  => %vr10
	iwrite	%vr10
	loadI	2  => %vr11
	loadI	1  => %vr5
	sub	%vr11, %vr5 => %vr12
	loadI	4  => %vr7
	mult	%vr12, %vr7 => %vr13
	sub	%vr4, %vr13 => %vr14
	load	%vr14  => %vr15
	iwrite	%vr15
	loadI	3  => %vr16
	loadI	1  => %vr5
	sub	%vr16, %vr5 => %vr17
	loadI	4  => %vr7
	mult	%vr17, %vr7 => %vr18
	sub	%vr4, %vr18 => %vr19
	load	%vr19  => %vr20
	iwrite	%vr20
	loadI	4  => %vr7
	loadI	1  => %vr5
	sub	%vr7, %vr5 => %vr21
	loadI	4  => %vr7
	mult	%vr21, %vr7 => %vr22
	sub	%vr4, %vr22 => %vr23
	load	%vr23  => %vr24
	iwrite	%vr24
	loadI	5  => %vr25
	loadI	1  => %vr5
	sub	%vr25, %vr5 => %vr26
	loadI	4  => %vr7
	mult	%vr26, %vr7 => %vr27
	sub	%vr4, %vr27 => %vr28
	load	%vr28  => %vr29
	iwrite	%vr29
	loadI	6  => %vr30
	loadI	1  => %vr5
	sub	%vr30, %vr5 => %vr31
	loadI	4  => %vr7
	mult	%vr31, %vr7 => %vr32
	sub	%vr4, %vr32 => %vr33
	load	%vr33  => %vr34
	iwrite	%vr34
	loadI	7  => %vr35
	loadI	1  => %vr5
	sub	%vr35, %vr5 => %vr36
	loadI	4  => %vr7
	mult	%vr36, %vr7 => %vr37
	sub	%vr4, %vr37 => %vr38
	load	%vr38  => %vr39
	iwrite	%vr39
	loadI	8  => %vr40
	loadI	1  => %vr5
	sub	%vr40, %vr5 => %vr41
	loadI	4  => %vr7
	mult	%vr41, %vr7 => %vr42
	sub	%vr4, %vr42 => %vr43
	load	%vr43  => %vr44
	iwrite	%vr44
	loadI	9  => %vr45
	loadI	1  => %vr5
	sub	%vr45, %vr5 => %vr46
	loadI	4  => %vr7
	mult	%vr46, %vr7 => %vr47
	sub	%vr4, %vr47 => %vr48
	load	%vr48  => %vr49
	iwrite	%vr49
	loadI	10  => %vr50
	loadI	1  => %vr5
	sub	%vr50, %vr5 => %vr51
	loadI	4  => %vr7
	mult	%vr51, %vr7 => %vr52
	sub	%vr4, %vr52 => %vr53
	load	%vr53  => %vr54
	iwrite	%vr54
	ret
	.frame	inc, 0, %vr4
	load	%vr4  => %vr5
	loadI	1  => %vr6
	add	%vr5, %vr6 => %vr7
	store	%vr7  => %vr4
	ret
