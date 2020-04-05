	.data
	.string	.int_wformat, "%d\12"
    .text
    .frame main, 28
    loadI 1  => %vr9
    i2i %vr9  => %vr4
    loadI 2  => %vr10
    i2i %vr10  => %vr5
    loadI 3  => %vr11
    i2i %vr11  => %vr6
    loadI 4  => %vr12
    i2i %vr12  => %vr7
    mult %vr6, %vr7 => %vr13
    add %vr5, %vr13 => %vr14
    add %vr4, %vr14 => %vr15
    iwrite %vr15
    loadI 5  => %vr16
    loadI 7  => %vr17
    mod %vr16, %vr17 => %vr18
    iwrite %vr18
    loadI 3  => %vr11
    loadI 5  => %vr16
    i2i %vr0  => %vr19
    loadI -4  => %vr20
    add %vr19, %vr20 => %vr21
    loadI 3  => %vr11
    sub %vr16, %vr11 => %vr22
    loadI 4  => %vr12
    mult %vr22, %vr12 => %vr23
    sub %vr21, %vr23 => %vr24
    store %vr11  => %vr24
    loadI 5  => %vr16
    i2i %vr0  => %vr19
    loadI -4  => %vr20
    add %vr19, %vr20 => %vr21
    loadI 3  => %vr11
    sub %vr16, %vr11 => %vr22
    loadI 4  => %vr12
    mult %vr22, %vr12 => %vr23
    sub %vr21, %vr23 => %vr24
    load %vr24  => %vr25
    iwrite %vr25
    ret
