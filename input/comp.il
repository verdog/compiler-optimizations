    .text
    .frame main, 0
    loadI 1 => %vr1
    loadI 2 => %vr2
    comp %vr1, %vr2 => %vr3
    iwrite %vr3

    loadI 1 => %vr1
    loadI 20 => %vr4
    comp %vr1, %vr4 => %vr6
    iwrite %vr6

    loadI 2 => %vr2
    loadI 2 => %vr2
    comp %vr2, %vr2 => %vr7
    iwrite %vr7

    loadI 2 => %vr2
    loadI 1 => %vr1
    comp %vr2, %vr1 => %vr8
    iwrite %vr8

    loadI 20 => %vr4
    loadI 1 => %vr1
    comp %vr4, %vr1 => %vr9
    iwrite %vr9
    ret
