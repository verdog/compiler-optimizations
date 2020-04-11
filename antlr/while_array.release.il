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
   .frame main, 140
   loadI 1 => %vr4
   storeAI %vr4 => %vr0, -44
   loadI 10 => %vr6
   loadI 1 => %vr7
   storeAI %vr7 => %vr0, -48
   loadAI %vr0, -4 => %vr7
   testgt %vr7 => %vr8
   storeAI %vr8 => %vr0, -52
   loadAI %vr0, -4 => %vr8
   cbr %vr8 -> .L0

.L1: nop
   addI %vr0, -4 => %vr11
   storeAI %vr11 => %vr0, -56
   loadAI %vr0, -4 => %vr4
   subI %vr4, 1 => %vr12
   storeAI %vr12 => %vr0, -60
   loadAI %vr0, -4 => %vr12
   multI %vr12, 4 => %vr14
   storeAI %vr14 => %vr0, -64
   loadAI %vr0, -4 => %vr11
   loadAI %vr0, -4 => %vr14
   sub %vr11, %vr14 => %vr15
   storeAI %vr15 => %vr0, -68
   loadAI %vr0, -4 => %vr4
   loadAI %vr0, -4 => %vr15
   store %vr4 => %vr15
   loadAI %vr0, -4 => %vr4
   addI %vr4, 1 => %vr16
   storeAI %vr16 => %vr0, -72
   loadAI %vr0, -4 => %vr16
   i2i %vr16 => %vr4
   storeAI %vr4 => %vr0, -76
   loadAI %vr0, -4 => %vr16
   comp %vr16, %vr6 => %vr7
   storeAI %vr7 => %vr0, -80
   loadAI %vr0, -4 => %vr7
   testle %vr7 => %vr8
   storeAI %vr8 => %vr0, -84
   loadAI %vr0, -4 => %vr8
   cbr %vr8 -> .L1

.L0: nop
   loadI 1 => %vr4
   loadI 1 => %vr7
   storeAI %vr7 => %vr0, -88
   loadAI %vr0, -4 => %vr7
   testgt %vr7 => %vr8
   storeAI %vr8 => %vr0, -92
   loadAI %vr0, -4 => %vr8
   cbr %vr8 -> .L2

.L3: nop
   loadI 5 => %vr17
   storeAI %vr17 => %vr0, -96
   loadAI %vr0, -4 => %vr17
   comp %vr4, %vr17 => %vr18
   storeAI %vr18 => %vr0, -100
   loadAI %vr0, -4 => %vr18
   testlt %vr18 => %vr19
   storeAI %vr19 => %vr0, -104
   loadAI %vr0, -4 => %vr19
   cbrne %vr19 -> .L4

   addI %vr0, -4 => %vr11
   storeAI %vr11 => %vr0, -108
   subI %vr4, 1 => %vr12
   storeAI %vr12 => %vr0, -112
   loadAI %vr0, -4 => %vr12
   multI %vr12, 4 => %vr14
   storeAI %vr14 => %vr0, -116
   loadAI %vr0, -4 => %vr11
   loadAI %vr0, -4 => %vr14
   sub %vr11, %vr14 => %vr15
   storeAI %vr15 => %vr0, -120
   loadAI %vr0, -4 => %vr15
   load %vr15 => %vr20
   storeAI %vr20 => %vr0, -124
   loadAI %vr0, -4 => %vr20
   iwrite %vr20
   jumpI -> .L5

.L4: nop
   loadI 0 => %vr21
   storeAI %vr21 => %vr0, -128
   loadAI %vr0, -4 => %vr21
   iwrite %vr21

.L5: nop
   addI %vr4, 1 => %vr16
   storeAI %vr16 => %vr0, -132
   loadAI %vr0, -4 => %vr16
   i2i %vr16 => %vr4
   loadAI %vr0, -4 => %vr16
   comp %vr16, %vr6 => %vr7
   storeAI %vr7 => %vr0, -136
   loadAI %vr0, -4 => %vr7
   testle %vr7 => %vr8
   storeAI %vr8 => %vr0, -140
   loadAI %vr0, -4 => %vr8
   cbr %vr8 -> .L3

.L2: nop
   ret

