    .text
    .frame main, 0
    loadI 1 => %vr10
    loadI 2 => %vr20
    comp %vr10, %vr20 => %vr30
    iwrite %vr30

    loadI 1 => %vr10
    loadI 20 => %vr4
    comp %vr10, %vr4 => %vr6
    iwrite %vr6

    loadI 2 => %vr20
    loadI 2 => %vr20
    comp %vr20, %vr20 => %vr7
    iwrite %vr7

    loadI 2 => %vr20
    loadI 1 => %vr10
    comp %vr20, %vr10 => %vr8
    iwrite %vr8

    loadI 20 => %vr4
    loadI 1 => %vr10
    comp %vr4, %vr10 => %vr9
    iwrite %vr9
    ret
