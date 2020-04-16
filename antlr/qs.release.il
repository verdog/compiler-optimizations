   .data
   .string .int_wformat , "%d\12"
   .string .float_wformat , "%f\12"
   .string .char_wformat , "%c\12"
   .string .string_wformat , "%s\12"
   .string .int_rformat , "%d"
   .string .float_rformat , "%f"
   .string .char_rformat , "%c"
   .string .string_rformat , "%s"
   .string .string_const_0 , "A?"
   .string .string_const_1 , "A:"
   .float .float_const_0 , 1.7
   .global main_fp , 4 , 4
   .text
   .frame main, 92
   loadI main_fp => %vr4
   store %vr0 => %vr4
   loadI 1 => %vr7
   loadI -1 => %vr4
   addI %vr0, -4 => %vr6
   subI %vr6, 0 => %vr5
   store %vr4 => %vr5
   loadI 1000 => %vr4
   i2i %vr6 => %vr6
   subI %vr6, 80 => %vr5
   store %vr4 => %vr5
   call readarray
   call writearray
   i2i %vr6 => %vr5
   addI %vr0, -88 => %vr4
   store %vr7 => %vr4
   loadI 19 => %vr6
   addI %vr0, -92 => %vr7
   store %vr6 => %vr7
   call quicksort, %vr5, %vr4, %vr7
   call writearray
   ret


   .frame readarray, 0
   loadI .string_const_0 => %vr4
   swrite %vr4
   loadI 1 => %vr5
   loadI 20 => %vr4
   loadI 1 => %vr6
   testge %vr6 => %vr6
   cbr %vr6 -> .L0

.L1: nop
   iwrite %vr5
   loadI main_fp => %vr6
   load %vr6 => %vr6
   addI %vr6, -4 => %vr7
   subI %vr5, 0 => %vr6
   multI %vr6, 4 => %vr6
   sub %vr7, %vr6 => %vr6
   iread %vr6
   addI %vr5, 1 => %vr6
   i2i %vr6 => %vr5
   comp %vr6, %vr4 => %vr6
   testlt %vr6 => %vr6
   cbr %vr6 -> .L1

.L0: nop
   ret


   .frame writearray, 0
   loadI .string_const_1 => %vr4
   swrite %vr4
   loadI 1 => %vr5
   loadI 20 => %vr4
   loadI 1 => %vr6
   testge %vr6 => %vr6
   cbr %vr6 -> .L2

.L3: nop
   loadI main_fp => %vr6
   load %vr6 => %vr6
   addI %vr6, -4 => %vr7
   subI %vr5, 0 => %vr6
   multI %vr6, 4 => %vr6
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr6
   iwrite %vr6
   addI %vr5, 1 => %vr6
   i2i %vr6 => %vr5
   comp %vr6, %vr4 => %vr6
   testlt %vr6 => %vr6
   cbr %vr6 -> .L3

.L2: nop
   ret


   .frame partition, 80, %vr7, %vr4, %vr6
   storeAI %vr7 => %vr0, -80
   storeAI %vr6 => %vr0, -4
   load %vr4 => %vr6
   storeAI %vr6 => %vr0, -44
   loadI 0 => %vr6
   storeAI %vr6 => %vr0, -8
   loadAI %vr0, -44 => %vr6
   subI %vr6, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr6
   i2i %vr6 => %vr6
   storeAI %vr6 => %vr0, -12
   load %vr4 => %vr6
   subI %vr6, 1 => %vr6
   i2i %vr6 => %vr5
   loadAI %vr0, -4 => %vr6
   load %vr6 => %vr6
   addI %vr6, 1 => %vr6
   i2i %vr6 => %vr4
   loadI .float_const_0 => %vr6
   storeAI %vr6 => %vr0, -16
   loadAI %vr0, -16 => %vr6
   fload %vr6 => %vr6
   f2i %vr6 => %vr7
   storeAI %vr7 => %vr0, -48
   loadAI %vr0, -8 => %vr6
   loadAI %vr0, -48 => %vr7
   comp %vr7, %vr6 => %vr6
   testeq %vr6 => %vr6
   cbr %vr6 -> .L4

.L5: nop
   subI %vr4, 1 => %vr6
   i2i %vr6 => %vr4
   subI %vr6, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr7
   storeAI %vr7 => %vr0, -52
   loadAI %vr0, -12 => %vr6
   loadAI %vr0, -52 => %vr7
   comp %vr7, %vr6 => %vr6
   testle %vr6 => %vr6
   cbr %vr6 -> .L6

.L7: nop
   subI %vr4, 1 => %vr6
   i2i %vr6 => %vr4
   subI %vr6, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr7
   storeAI %vr7 => %vr0, -56
   loadAI %vr0, -12 => %vr6
   loadAI %vr0, -56 => %vr7
   comp %vr7, %vr6 => %vr6
   testgt %vr6 => %vr6
   cbr %vr6 -> .L7

.L6: nop
   addI %vr5, 1 => %vr6
   i2i %vr6 => %vr5
   subI %vr6, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr7
   storeAI %vr7 => %vr0, -60
   loadAI %vr0, -12 => %vr6
   loadAI %vr0, -60 => %vr7
   comp %vr7, %vr6 => %vr6
   testge %vr6 => %vr6
   cbr %vr6 -> .L8

.L9: nop
   addI %vr5, 1 => %vr6
   i2i %vr6 => %vr5
   subI %vr6, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   load %vr6 => %vr7
   storeAI %vr7 => %vr0, -64
   loadAI %vr0, -12 => %vr6
   loadAI %vr0, -64 => %vr7
   comp %vr7, %vr6 => %vr6
   testlt %vr6 => %vr6
   cbr %vr6 -> .L9

.L8: nop
   comp %vr5, %vr4 => %vr6
   testlt %vr6 => %vr6
   cbrne %vr6 -> .L10

   subI %vr5, 0 => %vr6
   multI %vr6, 4 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   storeAI %vr6 => %vr0, -68
   loadAI %vr0, -68 => %vr6
   load %vr6 => %vr6
   storeAI %vr6 => %vr0, -20
   loadAI %vr0, -20 => %vr6
   i2i %vr6 => %vr7
   storeAI %vr7 => %vr0, -24
   subI %vr4, 0 => %vr6
   storeAI %vr6 => %vr0, -28
   loadAI %vr0, -28 => %vr6
   multI %vr6, 4 => %vr6
   storeAI %vr6 => %vr0, -32
   loadAI %vr0, -32 => %vr6
   loadAI %vr0, -80 => %vr7
   sub %vr7, %vr6 => %vr6
   storeAI %vr6 => %vr0, -36
   loadAI %vr0, -36 => %vr6
   load %vr6 => %vr7
   storeAI %vr7 => %vr0, -40
   loadAI %vr0, -68 => %vr6
   i2i %vr6 => %vr6
   storeAI %vr6 => %vr0, -72
   loadAI %vr0, -40 => %vr7
   loadAI %vr0, -72 => %vr6
   store %vr7 => %vr6
   loadAI %vr0, -36 => %vr6
   i2i %vr6 => %vr6
   storeAI %vr6 => %vr0, -76
   loadAI %vr0, -24 => %vr7
   loadAI %vr0, -76 => %vr6
   store %vr7 => %vr6
   jumpI -> .L11

.L10: nop
   loadAI %vr0, -4 => %vr6
   loadAI %vr0, -80 => %vr7
   iret %vr4

.L11: nop
   loadAI %vr0, -16 => %vr6
   fload %vr6 => %vr6
   f2i %vr6 => %vr6
   cbr %vr6 -> .L5

.L4: nop
   loadAI %vr0, -4 => %vr6
   loadAI %vr0, -80 => %vr7
   ret


   .frame quicksort, 28, %vr4, %vr7, %vr6
   iwrite %vr4
   iwrite %vr7
   iwrite %vr6
   storeAI %vr4 => %vr0, -28
   load %vr7 => %vr5
   storeAI %vr5 => %vr0, -12
   load %vr6 => %vr4
   storeAI %vr4 => %vr0, -20
   loadAI %vr0, -12 => %vr5
   loadAI %vr0, -20 => %vr4
   comp %vr5, %vr4 => %vr4
   testlt %vr4 => %vr4
   cbrne %vr4 -> .L12

   loadAI %vr0, -28 => %vr4
   icall partition, %vr4, %vr7, %vr6 => %vr5
   storeAI %vr5 => %vr0, -16
   addI %vr0, -4 => %vr4
   storeAI %vr4 => %vr0, -24
   loadAI %vr0, -16 => %vr5
   loadAI %vr0, -24 => %vr4
   store %vr5 => %vr4
   loadAI %vr0, -24 => %vr4
   i2i %vr4 => %vr5
   loadAI %vr0, -28 => %vr4
   call quicksort, %vr4, %vr7, %vr5
   storeAI %vr4 => %vr0, -28
   i2i %vr5 => %vr4
   load %vr4 => %vr4
   addI %vr4, 1 => %vr4
   addI %vr0, -8 => %vr5
   store %vr4 => %vr5
   loadAI %vr0, -28 => %vr4
   call quicksort, %vr4, %vr5, %vr6
   storeAI %vr4 => %vr0, -28

.L12: nop
   loadAI %vr0, -28 => %vr4
   ret


