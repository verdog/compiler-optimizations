   .data
   .string .int_wformat , "%d\12"
   .string .float_wformat , "%f\12"
   .string .char_wformat , "%c\12"
   .string .string_wformat , "%s\12"
   .string .int_rformat , "%d"
   .string .float_rformat , "%f"
   .string .char_rformat , "%c"
   .string .string_rformat , "%s"
   .text
   .frame main, 0
(deleted)   loadI 1 => %vr8_0
   loadI 1 => %vr6_0
(deleted)   loadI 0 => %vr9_0
   loadI 0 => %vr7_0
(deleted)   loadI 0 => %vr9_
   loadI 0 => %vr5_0
(deleted)   loadI 1 => %vr8_
   loadI 1 => %vr4_0
   loadI 20 => %vr10_0
   loadI 1 => %vr11_0
   testgt %vr11_0 => %vr12_0
   cbr %vr12_0 -> .L0

.L1: nop
   (phi): %vr6_1 (.L1->%vr6_2, entry->%vr6_0)
   (phi): %vr7_1 (.L1->%vr7_2, entry->%vr7_0)
   (phi): %vr5_1 (.L1->%vr5_2, entry->%vr5_0)
   (phi): %vr4_1 (.L1->%vr4_2, entry->%vr4_0)
   iwrite %vr5_1
   add %vr7_1, %vr6_1 => %vr13_0
   i2i %vr13_0 => %vr5_2
   i2i %vr7_1 => %vr6_2
   i2i %vr13_0 => %vr7_2
(deleted)   loadI 1 => %vr8_
   addI %vr4_1, 1 => %vr14_0
   i2i %vr14_0 => %vr4_2
(deleted)   loadI 20 => %vr10_
   comp %vr14_0, %vr10_0 => %vr11_1
   testle %vr11_1 => %vr12_1
   cbr %vr12_1 -> .L1

.L0: nop
   ret

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
found %vr14_0
    %vr14_0, 
found %vr1_0
    %vr1_0, 
found %vr2_0
    %vr2_0, 
found %vr3_0
    %vr3_0, 
found %vr4_1
    %vr4_0, %vr4_1, %vr4_2, 
found %vr5_1
    %vr5_0, %vr5_1, %vr5_2, 
found %vr6_1
    %vr6_0, %vr6_1, %vr6_2, 
found %vr7_1
    %vr7_0, %vr7_1, %vr7_2, 
live variable analysis for entry in main:
IN:
   %vr4_1
   %vr6_1
   %vr7_1
   %vr5_1
OUT:
   %vr5_1
   %vr7_1
   %vr6_1
   %vr4_1
   %vr10_0
live variable analysis for .L1 in main:
IN:
   %vr10_0
   %vr4_1
   %vr6_1
   %vr7_1
   %vr5_1
OUT:
   %vr5_1
   %vr7_1
   %vr6_1
   %vr4_1
   %vr10_0
live variable analysis for .L0 in main:
IN:
OUT:
3 iterations
%vr0_0 (1e+06) (color: 0): 
%vr10_0 (0.1) (color: -1): 
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr14_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr11_0 (0.2) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr11_1 (0.2) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr12_0 (0.2) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr12_1 (0.2) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr13_0 (0.4) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr14_0 (0.4) (color: -1): 
   %vr10_0
   %vr4_1
   %vr5_1
   %vr6_1
   %vr7_1
%vr1_0 (1e+06) (color: 1): 
%vr2_0 (1e+06) (color: 2): 
%vr3_0 (1e+06) (color: 3): 
%vr4_1 (0.3) (color: 7): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr14_0
   %vr5_1
   %vr6_1
   %vr7_1
%vr5_1 (0.3) (color: 6): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr14_0
   %vr4_1
   %vr6_1
   %vr7_1
%vr6_1 (0.3) (color: 5): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr14_0
   %vr4_1
   %vr5_1
   %vr7_1
%vr7_1 (0.4) (color: 4): 
   %vr10_0
   %vr11_0
   %vr11_1
   %vr12_0
   %vr12_1
   %vr13_0
   %vr14_0
   %vr4_1
   %vr5_1
   %vr6_1
1 register alloc iterations.
   .data
   .string .int_wformat , "%d\12"
   .string .float_wformat , "%f\12"
   .string .char_wformat , "%c\12"
   .string .string_wformat , "%s\12"
   .string .int_rformat , "%d"
   .string .float_rformat , "%f"
   .string .char_rformat , "%c"
   .string .string_rformat , "%s"
   .text
   .frame main, 28
(deleted)   loadI 1 => %vr8_0
   loadI 1 => %vr6_0
(deleted)   loadI 0 => %vr9_0
   loadI 0 => %vr7_0
(deleted)   loadI 0 => %vr9_
   loadI 0 => %vr5_0
(deleted)   loadI 1 => %vr8_
   loadI 1 => %vr4_0
   loadI 20 => %vr10_0
   storeAI %vr10_0, %vr0_0, -4
   loadI 1 => %vr11_0
   storeAI %vr11_0, %vr0_0, -8
   loadAI %vr0_0, -8 => %vr11_0
   testgt %vr11_0 => %vr12_0
   storeAI %vr12_0, %vr0_0, -12
   loadAI %vr0_0, -12 => %vr12_0
   cbr %vr12_0 -> .L0

.L1: nop
   (phi): %vr6_1 (.L1->%vr6_2, entry->%vr6_0)
   (phi): %vr7_1 (.L1->%vr7_2, entry->%vr7_0)
   (phi): %vr5_1 (.L1->%vr5_2, entry->%vr5_0)
   (phi): %vr4_1 (.L1->%vr4_2, entry->%vr4_0)
   iwrite %vr5_1
   add %vr7_1, %vr6_1 => %vr13_0
   storeAI %vr13_0, %vr0_0, -16
   loadAI %vr0_0, -16 => %vr13_0
   i2i %vr13_0 => %vr5_2
   i2i %vr7_1 => %vr6_2
   loadAI %vr0_0, -16 => %vr13_0
   i2i %vr13_0 => %vr7_2
(deleted)   loadI 1 => %vr8_
   addI %vr4_1, 1 => %vr14_0
   storeAI %vr14_0, %vr0_0, -20
   loadAI %vr0_0, -20 => %vr14_0
   i2i %vr14_0 => %vr4_2
(deleted)   loadI 20 => %vr10_
   loadAI %vr0_0, -20 => %vr14_0
   loadAI %vr0_0, -4 => %vr10_0
   comp %vr14_0, %vr10_0 => %vr11_1
   storeAI %vr11_1, %vr0_0, -24
   loadAI %vr0_0, -24 => %vr11_1
   testle %vr11_1 => %vr12_1
   storeAI %vr12_1, %vr0_0, -28
   loadAI %vr0_0, -28 => %vr12_1
   cbr %vr12_1 -> .L1

.L0: nop
   ret

