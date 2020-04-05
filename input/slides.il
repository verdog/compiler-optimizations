    .text
    .frame main, 0
    loadI 5 => %vr1
    add %vr1, %vr2 => %vr11
    i2i %vr11 => %vr3
    loadI 3 => %vr4
    add %vr4, %vr1 => %vr12
    i2i %vr12 => %vr6
    i2i %vr2 => %vr7
    loadI 5 => %vr1
    add %vr1, %vr7 => %vr13
    ret
