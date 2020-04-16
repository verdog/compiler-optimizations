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
   .frame main, 4052
   loadI 30 => %vr9
   i2i %vr9 => %vr8
   i2i %vr9 => %vr9
   storeAI %vr9 => %vr0, -3964
   loadI 1 => %vr9
   storeAI %vr9 => %vr0, -3968
   loadAI %vr0, -3968 => %vr9
   i2i %vr9 => %vr6
   comp %vr6, %vr8 => %vr9
   testgt %vr9 => %vr9
   cbr %vr9 -> .L0

.L1: subI %vr6, 1 => %vr10
   storeAI %vr10 => %vr0, -4028
   mult %vr6, %vr8 => %vr9
   addI %vr9, 1 => %vr9
   storeAI %vr9 => %vr0, -3972
   i2i %vr0 => %vr9
   storeAI %vr9 => %vr0, -4032
   loadAI %vr0, -4032 => %vr9
   addI %vr9, -244 => %vr10
   storeAI %vr10 => %vr0, -3976
   loadAI %vr0, -3972 => %vr9
   subI %vr9, 1 => %vr9
   storeAI %vr9 => %vr0, -3980
   loadAI %vr0, -3980 => %vr9
   multI %vr9, 4 => %vr9
   storeAI %vr9 => %vr0, -3984
   loadAI %vr0, -3976 => %vr10
   loadAI %vr0, -3984 => %vr9
   sub %vr10, %vr9 => %vr9
   storeAI %vr9 => %vr0, -3988
   loadAI %vr0, -3988 => %vr9
   loadAI %vr0, -4028 => %vr10
   store %vr10 => %vr9
   loadAI %vr0, -4032 => %vr9
   addI %vr9, -124 => %vr9
   storeAI %vr9 => %vr0, -3992
   loadAI %vr0, -4028 => %vr10
   multI %vr10, 4 => %vr10
   loadAI %vr0, -3992 => %vr9
   sub %vr9, %vr10 => %vr9
   store %vr6 => %vr9
   addI %vr6, 1 => %vr9
   i2i %vr9 => %vr6
   comp %vr6, %vr8 => %vr9
   testle %vr9 => %vr9
   cbr %vr9 -> .L1

   loadAI %vr0, -3968 => %vr9
.L0: i2i %vr9 => %vr5
   loadAI %vr0, -3964 => %vr9
   comp %vr5, %vr9 => %vr6
   testgt %vr6 => %vr6
   cbr %vr6 -> .L2

.L3: subI %vr5, 1 => %vr10
   i2i %vr8 => %vr6
   add %vr5, %vr6 => %vr6
   storeAI %vr6 => %vr0, -4036
   i2i %vr0 => %vr6
   storeAI %vr6 => %vr0, -4052
   loadAI %vr0, -4052 => %vr6
   addI %vr6, -244 => %vr9
   storeAI %vr9 => %vr0, -3996
   loadAI %vr0, -4036 => %vr6
   subI %vr6, 1 => %vr6
   multI %vr6, 4 => %vr6
   storeAI %vr6 => %vr0, -4040
   loadAI %vr0, -3996 => %vr9
   loadAI %vr0, -4040 => %vr6
   sub %vr9, %vr6 => %vr6
   store %vr10 => %vr6
   multI %vr5, 2 => %vr6
   storeAI %vr6 => %vr0, -4044
   loadAI %vr0, -4052 => %vr6
   addI %vr6, -124 => %vr6
   multI %vr10, 4 => %vr9
   sub %vr6, %vr9 => %vr9
   loadAI %vr0, -4044 => %vr6
   store %vr6 => %vr9
   addI %vr5, 1 => %vr6
   i2i %vr6 => %vr5
   loadAI %vr0, -3964 => %vr9
   comp %vr5, %vr9 => %vr6
   testle %vr6 => %vr6
   cbr %vr6 -> .L3

.L2: loadI 2 => %vr5
   storeAI %vr5 => %vr0, -4000
   loadAI %vr0, -4000 => %vr5
   i2i %vr5 => %vr7
   comp %vr7, %vr8 => %vr5
   testgt %vr5 => %vr5
   cbr %vr5 -> .L4

   loadAI %vr0, -4000 => %vr5
.L5: i2i %vr5 => %vr4
   loadAI %vr0, -3964 => %vr9
   comp %vr4, %vr9 => %vr5
   testgt %vr5 => %vr5
   cbr %vr5 -> .L6

.L7: subI %vr7, 1 => %vr5
   storeAI %vr5 => %vr0, -4048
   loadAI %vr0, -4048 => %vr5
   mult %vr5, %vr8 => %vr5
   storeAI %vr5 => %vr0, -4004
   subI %vr4, 1 => %vr6
   storeAI %vr6 => %vr0, -4008
   loadAI %vr0, -4004 => %vr5
   loadAI %vr0, -4008 => %vr6
   add %vr5, %vr6 => %vr5
   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr10
   subI %vr5, 1 => %vr5
   multI %vr5, 4 => %vr5
   sub %vr10, %vr5 => %vr5
   load %vr5 => %vr5
   storeAI %vr5 => %vr0, -4012
   mult %vr7, %vr8 => %vr9
   add %vr4, %vr9 => %vr5
   storeAI %vr5 => %vr0, -4016
   loadAI %vr0, -4016 => %vr5
   subI %vr5, 1 => %vr5
   storeAI %vr5 => %vr0, -4020
   loadAI %vr0, -4020 => %vr5
   multI %vr5, 4 => %vr11
   sub %vr10, %vr11 => %vr10
   loadAI %vr0, -4012 => %vr5
   store %vr5 => %vr10
   addI %vr6, -124 => %vr5
   storeAI %vr5 => %vr0, -4024
   loadAI %vr0, -4048 => %vr5
   multI %vr5, 4 => %vr10
   loadAI %vr0, -4024 => %vr5
   sub %vr5, %vr10 => %vr5
   load %vr5 => %vr10
   addI %vr6, -4 => %vr5
   loadAI %vr0, -4008 => %vr6
   multI %vr6, 4 => %vr6
   sub %vr5, %vr6 => %vr5
   load %vr5 => %vr5
   comp %vr10, %vr5 => %vr5
   testne %vr5 => %vr5
   cbrne %vr5 -> .L8

   add %vr9, %vr4 => %vr5
   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr6
   subI %vr5, 1 => %vr5
   multI %vr5, 4 => %vr11
   sub %vr6, %vr11 => %vr6
   load %vr6 => %vr5
   addI %vr5, 1 => %vr5
   store %vr5 => %vr6

   loadAI %vr0, -4004 => %vr5
.L8: add %vr5, %vr4 => %vr5
   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr6
   subI %vr5, 1 => %vr5
   multI %vr5, 4 => %vr5
   sub %vr6, %vr5 => %vr10
   load %vr10 => %vr10
   sub %vr6, %vr11 => %vr6
   load %vr6 => %vr6
   comp %vr10, %vr6 => %vr6
   testlt %vr6 => %vr6
   cbrne %vr6 -> .L9

   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr6
   sub %vr6, %vr5 => %vr5
   load %vr5 => %vr5
   addI %vr5, 1 => %vr5
   sub %vr6, %vr11 => %vr6
   store %vr5 => %vr6

   loadAI %vr0, -4008 => %vr6
.L9: add %vr9, %vr6 => %vr5
   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr6
   subI %vr5, 1 => %vr5
   multI %vr5, 4 => %vr5
   sub %vr6, %vr5 => %vr10
   load %vr10 => %vr10
   add %vr9, %vr4 => %vr9
   subI %vr9, 1 => %vr9
   multI %vr9, 4 => %vr9
   sub %vr6, %vr9 => %vr6
   load %vr6 => %vr6
   comp %vr10, %vr6 => %vr6
   testlt %vr6 => %vr6
   cbrne %vr6 -> .L10

   i2i %vr0 => %vr6
   addI %vr6, -244 => %vr6
   sub %vr6, %vr5 => %vr5
   load %vr5 => %vr5
   addI %vr5, 1 => %vr5
   sub %vr6, %vr9 => %vr6
   store %vr5 => %vr6

.L10: addI %vr4, 1 => %vr5
   i2i %vr5 => %vr4
   loadAI %vr0, -3964 => %vr9
   comp %vr4, %vr9 => %vr5
   testle %vr5 => %vr5
   cbr %vr5 -> .L7

.L6: addI %vr7, 1 => %vr5
   i2i %vr5 => %vr7
   comp %vr7, %vr8 => %vr5
   testle %vr5 => %vr5
   cbr %vr5 -> .L5

.L4: mult %vr8, %vr8 => %vr4
   loadAI %vr0, -3964 => %vr9
   add %vr4, %vr9 => %vr4
   i2i %vr0 => %vr5
   addI %vr5, -244 => %vr5
   subI %vr4, 1 => %vr4
   multI %vr4, 4 => %vr4
   sub %vr5, %vr4 => %vr4
   load %vr4 => %vr4
   iwrite %vr4
   ret


