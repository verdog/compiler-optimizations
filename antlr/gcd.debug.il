   .data
   .string .int_wformat , "%d\12"
   .string .float_wformat , "%f\12"
   .string .char_wformat , "%c\12"
   .string .string_wformat , "%s\12"
   .string .int_rformat , "%d"
   .string .float_rformat , "%f"
   .string .char_rformat , "%c"
   .string .string_rformat , "%s"
   .global main_fp , 4 , 4
   .text
   .frame main, 8
   loadI main_fp => %vr4_0
   store %vr0_0, %vr4_0
(deleted)   loadI -4 => %vr5_0
   addI %vr0_0, -4 => %vr6_0
   iread %vr6_0
(deleted)   loadI -8 => %vr7_0
   addI %vr0_0, -8 => %vr8_0
   iread %vr8_0
(deleted)   loadI -4 => %vr5_
   i2i %vr6_0 => %vr6_1
   load %vr6_1 => %vr9_0
   loadI 0 => %vr10_0
   comp %vr9_0, %vr10_0 => %vr11_0
   testne %vr11_0 => %vr12_0
(deleted)   loadI -8 => %vr7_
   i2i %vr8_0 => %vr8_1
   load %vr8_1 => %vr13_0
(deleted)   loadI 0 => %vr10_
   comp %vr13_0, %vr10_0 => %vr14_0
   testne %vr14_0 => %vr15_0
   or %vr12_0, %vr15_0 => %vr16_0
(deleted)   loadI 0 => %vr10_
   comp %vr16_0, %vr10_0 => %vr17_0
   testeq %vr17_0 => %vr18_0
   cbr %vr18_0 -> .L0

.L1: nop
(deleted)   loadI -4 => %vr5_
(deleted)   addI %vr0_0, -4 => %vr6_
(deleted)   loadI -8 => %vr7_
(deleted)   addI %vr0_0, -8 => %vr8_
   icall gcd, %vr6_1, %vr8_1 => %vr19_0, %vr6_2, %vr8_2
   iwrite %vr19_0
(deleted)   loadI -4 => %vr5_
   i2i %vr6_2 => %vr6_3
   iread %vr6_3
(deleted)   loadI -8 => %vr7_
   i2i %vr8_2 => %vr8_3
   iread %vr8_3
(deleted)   loadI -4 => %vr5_
   i2i %vr6_3 => %vr6_4
   load %vr6_4 => %vr9_1
(deleted)   loadI 0 => %vr10_
   comp %vr9_1, %vr10_0 => %vr11_1
   testne %vr11_1 => %vr12_1
(deleted)   loadI -8 => %vr7_
   i2i %vr8_3 => %vr8_4
   load %vr8_4 => %vr13_1
(deleted)   loadI 0 => %vr10_
   comp %vr13_1, %vr10_0 => %vr14_1
   testne %vr14_1 => %vr15_1
   or %vr12_1, %vr15_1 => %vr16_1
   cbr %vr16_1 -> .L1

.L0: nop
   ret


   .frame gcd, 4, %vr4_0, %vr5_0
   load %vr5_0 => %vr6_0
   loadI 0 => %vr7_0
   comp %vr6_0, %vr7_0 => %vr8_0
   testeq %vr8_0 => %vr9_0
   cbrne %vr9_0 -> .L2

   load %vr4_0 => %vr10_0
   iret %vr10_0

.L2: nop
   load %vr4_0 => %vr10_1
   load %vr5_0 => %vr6_1
   mod %vr10_1, %vr6_1 => %vr11_0
(deleted)   loadI -4 => %vr12_0
   addI %vr0_0, -4 => %vr13_0
   store %vr11_0, %vr13_0
   icall gcd, %vr5_0, %vr13_0 => %vr14_0, %vr5_2, %vr13_1
   iret %vr14_0


found %vr0_0
    %vr0_0, 
found %vr10_0
    %vr10_0, 
found %vr11_0
    %vr11_0, 
found %vr11_1
    %vr11_1, 
found %vr12_0
    %vr12_0, 
found %vr12_1
    %vr12_1, 
found %vr13_0
    %vr13_0, 
found %vr13_1
    %vr13_1, 
found %vr14_0
    %vr14_0, 
found %vr14_1
    %vr14_1, 
found %vr15_0
    %vr15_0, 
found %vr15_1
    %vr15_1, 
found %vr16_0
    %vr16_0, 
found %vr16_1
    %vr16_1, 
found %vr17_0
    %vr17_0, 
found %vr18_0
    %vr18_0, 
found %vr19_0
    %vr19_0, 
found %vr1_0
    %vr1_0, 
found %vr2_0
    %vr2_0, 
found %vr3_0
    %vr3_0, 
found %vr4_0
    %vr4_0, 
found %vr6_0
    %vr6_0, 
found %vr6_1
    %vr6_1, %vr6_2, 
found %vr6_3
    %vr6_3, 
found %vr6_4
    %vr6_4, 
found %vr8_0
    %vr8_0, 
found %vr8_1
    %vr8_1, %vr8_2, 
found %vr8_3
    %vr8_3, 
found %vr8_4
    %vr8_4, 
found %vr9_0
    %vr9_0, 
found %vr9_1
    %vr9_1, 
found %vr0_0
    %vr0_0, 
found %vr10_0
    %vr10_0, 
found %vr10_1
    %vr10_1, 
found %vr11_0
    %vr11_0, 
found %vr13_0
    %vr13_0, %vr13_1, 
found %vr14_0
    %vr14_0, 
found %vr1_0
    %vr1_0, 
found %vr2_0
    %vr2_0, 
found %vr3_0
    %vr3_0, 
found %vr4_0
    %vr4_0, 
found %vr5_0
    %vr5_0, %vr5_2, 
found %vr6_0
    %vr6_0, 
found %vr6_1
    %vr6_1, 
found %vr7_0
    %vr7_0, 
found %vr8_0
    %vr8_0, 
found %vr9_0
    %vr9_0, 
live variable analysis for entry in gcd:
IN:
   %vr0_0
   %vr4_0
   %vr5_0
OUT:
   %vr4_0
   %vr5_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
   %vr5_0
   %vr4_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr5_0
   %vr4_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr6_1
   %vr8_1
   %vr10_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr10_0
   %vr8_1
   %vr6_1
OUT:
   %vr6_1
   %vr8_1
   %vr10_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for main:
%vr0_0 (1.5) (color: 0): 
   %vr4_0
   %vr6_0
%vr10_0 (0.208333) (color: 5): 
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_0
   %vr8_1
   %vr8_3
   %vr8_4
   %vr9_0
   %vr9_1
%vr11_0 (0.333333) (color: -1): 
   %vr10_0
   %vr6_1
   %vr8_0
%vr11_1 (0.25) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
   %vr8_3
%vr12_0 (0.142857) (color: -1): 
   %vr10_0
   %vr13_0
   %vr14_0
   %vr15_0
   %vr6_1
   %vr8_0
   %vr8_1
%vr12_1 (0.125) (color: -1): 
   %vr10_0
   %vr13_1
   %vr14_1
   %vr15_1
   %vr6_1
   %vr8_1
   %vr8_3
   %vr8_4
%vr13_0 (0.25) (color: 4): 
   %vr10_0
   %vr12_0
   %vr6_1
   %vr8_1
%vr13_1 (0.25) (color: 4): 
   %vr10_0
   %vr12_1
   %vr6_1
   %vr8_1
%vr14_0 (0.25) (color: 4): 
   %vr10_0
   %vr12_0
   %vr6_1
   %vr8_1
%vr14_1 (0.25) (color: 4): 
   %vr10_0
   %vr12_1
   %vr6_1
   %vr8_1
%vr15_0 (0.25) (color: 4): 
   %vr10_0
   %vr12_0
   %vr6_1
   %vr8_1
%vr15_1 (0.25) (color: 4): 
   %vr10_0
   %vr12_1
   %vr6_1
   %vr8_1
%vr16_0 (0.333333) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
%vr16_1 (0.333333) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
%vr17_0 (0.333333) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
%vr18_0 (0.333333) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
%vr19_0 (0.333333) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1) (color: 4): 
   %vr0_0
%vr6_0 (1) (color: 5): 
   %vr0_0
   %vr8_0
%vr6_1 (0.125) (color: -1): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr6_3
   %vr6_4
   %vr8_0
   %vr8_1
   %vr8_3
   %vr8_4
   %vr9_0
   %vr9_1
%vr6_3 (0.5) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
   %vr8_3
%vr6_4 (0.25) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
   %vr8_3
%vr8_0 (0.333333) (color: 4): 
   %vr10_0
   %vr11_0
   %vr12_0
   %vr6_0
   %vr6_1
   %vr9_0
%vr8_1 (0.142857) (color: -1): 
   %vr10_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_3
   %vr8_4
   %vr9_1
%vr8_3 (0.25) (color: -1): 
   %vr10_0
   %vr11_1
   %vr12_1
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_1
   %vr9_1
%vr8_4 (0.25) (color: 4): 
   %vr10_0
   %vr12_1
   %vr6_1
   %vr8_1
%vr9_0 (0.333333) (color: -1): 
   %vr10_0
   %vr6_1
   %vr8_0
%vr9_1 (0.25) (color: 4): 
   %vr10_0
   %vr6_1
   %vr8_1
   %vr8_3
graph for gcd:
%vr0_0 (0.142857) (color: 0): 
   %vr10_1
   %vr11_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.5) (color: 4): 
   %vr4_0
   %vr5_0
%vr10_1 (0.25) (color: -1): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_1
%vr11_0 (0.25) (color: -1): 
   %vr0_0
   %vr13_0
   %vr4_0
   %vr5_0
%vr13_0 (0.666667) (color: 4): 
   %vr11_0
   %vr4_0
   %vr5_0
%vr14_0 (0.5) (color: 4): 
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (0.181818) (color: -1): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (0.272727) (color: 5): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (0.25) (color: -1): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.25) (color: 4): 
   %vr0_0
   %vr10_1
   %vr4_0
   %vr5_0
%vr7_0 (0.25) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr5_0
   %vr0_0
   %vr4_0
OUT:
   %vr4_0
   %vr0_0
   %vr5_0
live variable analysis for .L2 in gcd:
IN:
   %vr5_0
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr5_0
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
   %vr10_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr10_0
   %vr0_0
OUT:
   %vr0_0
   %vr10_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for main:
%vr0_0 (0.111111) (color: 0): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr4_0
   %vr6_0
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_0
   %vr8_1
   %vr8_3
   %vr8_4
   %vr9_0
   %vr9_1
%vr10_0 (0.2) (color: -1): 
   %vr0_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_0
   %vr8_1
   %vr8_3
   %vr8_4
   %vr9_0
   %vr9_1
%vr11_0 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr8_0
%vr11_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr12_0 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr15_0
   %vr8_0
%vr12_1 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr15_1
%vr13_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr13_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr14_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr14_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr15_0 (0.333333) (color: 5): 
   %vr0_0
   %vr10_0
   %vr12_0
%vr15_1 (0.333333) (color: 5): 
   %vr0_0
   %vr10_0
   %vr12_1
%vr16_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr16_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr17_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr18_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr19_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1) (color: 4): 
   %vr0_0
%vr6_0 (1) (color: 4): 
   %vr0_0
   %vr8_0
%vr6_1 (1e+06) (color: 5): 
   %vr0_0
   %vr10_0
   %vr8_0
   %vr8_1
%vr6_3 (0.5) (color: 5): 
   %vr0_0
   %vr10_0
   %vr8_1
   %vr8_3
%vr6_4 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr8_0 (0.285714) (color: -1): 
   %vr0_0
   %vr10_0
   %vr11_0
   %vr12_0
   %vr6_0
   %vr6_1
   %vr9_0
%vr8_1 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr6_1
   %vr6_3
%vr8_3 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr6_3
%vr8_4 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr9_0 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
   %vr8_0
%vr9_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr5_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
   %vr5_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: 5): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (0.25) (color: -1): 
   %vr0_0
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.333333) (color: 4): 
   %vr0_0
   %vr10_1
   %vr5_0
%vr7_0 (0.25) (color: -1): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for main:
%vr0_0 (0.111111) (color: 0): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr13_1
   %vr14_0
   %vr14_1
   %vr15_0
   %vr15_1
   %vr16_0
   %vr16_1
   %vr17_0
   %vr18_0
   %vr19_0
   %vr4_0
   %vr6_0
   %vr6_1
   %vr6_3
   %vr6_4
   %vr8_0
   %vr8_1
   %vr8_3
   %vr8_4
   %vr9_0
   %vr9_1
%vr10_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
   %vr13_1
   %vr16_0
   %vr9_0
   %vr9_1
%vr11_0 (1e+06) (color: 4): 
   %vr0_0
%vr11_1 (1) (color: 4): 
   %vr0_0
%vr12_0 (1e+06) (color: 5): 
   %vr0_0
   %vr15_0
%vr12_1 (1e+06) (color: 5): 
   %vr0_0
   %vr15_1
%vr13_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr13_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr14_0 (1) (color: 4): 
   %vr0_0
%vr14_1 (1) (color: 4): 
   %vr0_0
%vr15_0 (0.5) (color: 4): 
   %vr0_0
   %vr12_0
%vr15_1 (0.5) (color: 4): 
   %vr0_0
   %vr12_1
%vr16_0 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
%vr16_1 (1) (color: 4): 
   %vr0_0
%vr17_0 (1) (color: 4): 
   %vr0_0
%vr18_0 (1) (color: 4): 
   %vr0_0
%vr19_0 (1) (color: 4): 
   %vr0_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1) (color: 4): 
   %vr0_0
%vr6_0 (1) (color: 5): 
   %vr0_0
   %vr8_0
%vr6_1 (1e+06) (color: 5): 
   %vr0_0
   %vr8_1
%vr6_3 (0.666667) (color: 5): 
   %vr0_0
   %vr8_1
   %vr8_3
%vr6_4 (1) (color: 4): 
   %vr0_0
%vr8_0 (1e+06) (color: 4): 
   %vr0_0
   %vr6_0
%vr8_1 (1e+06) (color: 4): 
   %vr0_0
   %vr6_1
   %vr6_3
%vr8_3 (1e+06) (color: 4): 
   %vr0_0
   %vr6_3
%vr8_4 (1) (color: 4): 
   %vr0_0
%vr9_0 (1e+06) (color: 4): 
   %vr0_0
   %vr10_0
%vr9_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_0
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
graph for gcd:
%vr0_0 (0.0833333) (color: 0): 
   %vr10_0
   %vr10_1
   %vr11_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr5_0
   %vr6_0
   %vr6_1
   %vr7_0
   %vr8_0
   %vr9_0
%vr10_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr10_1 (1e+06) (color: 5): 
   %vr0_0
   %vr6_1
%vr11_0 (1e+06) (color: 5): 
   %vr0_0
   %vr13_0
%vr13_0 (0.666667) (color: 4): 
   %vr0_0
   %vr11_0
   %vr5_0
%vr14_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr14_0
   %vr5_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr5_0 (1e+06) (color: -1): 
   %vr0_0
   %vr10_0
   %vr13_0
   %vr14_0
   %vr4_0
   %vr6_0
   %vr7_0
   %vr8_0
   %vr9_0
%vr6_0 (1e+06) (color: 5): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr7_0
%vr6_1 (0.5) (color: 4): 
   %vr0_0
   %vr10_1
%vr7_0 (1e+06) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
   %vr6_0
%vr8_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
%vr9_0 (0.333333) (color: 4): 
   %vr0_0
   %vr4_0
   %vr5_0
live variable analysis for entry in gcd:
IN:
   %vr4_0
   %vr0_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
   %vr0_0
live variable analysis for .L2 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for unamed0 in gcd:
IN:
   %vr0_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for exit in gcd:
IN:
   %vr4_0
   %vr5_0
OUT:
   %vr5_0
   %vr4_0
live variable analysis for entry in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for .L0 in main:
IN:
OUT:
live variable analysis for .L1 in main:
IN:
   %vr0_0
OUT:
   %vr0_0
live variable analysis for exit in main:
IN:
OUT:
2 iterations
