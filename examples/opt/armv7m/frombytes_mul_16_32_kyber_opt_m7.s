.syntax unified
.cpu cortex-m4
.thumb

.macro doublebasemul_frombytes_asm_16_32 rptr_tmp, bptr, zeta, poly0, poly2, poly1, poly3, tmp, q, qa, qinv
  ldr \poly0, [\bptr], #8
  ldr \poly2, [\bptr, #-4]

  smulwt \tmp, \zeta, \poly1
 smlabt \tmp, \tmp, \q, \qa
 smultt \tmp, \poly0, \tmp
 smlabb \tmp, \poly0, \poly1, \tmp
  str \tmp, [\rptr_tmp], #16 // @slothy:core

  smuadx \tmp, \poly0, \poly1
  str \tmp, [\rptr_tmp, #-12]

  neg \zeta, \zeta

  smulwt \tmp, \zeta, \poly3
 smlabt \tmp, \tmp, \q, \qa
 smultt \tmp, \poly2, \tmp
 smlabb \tmp, \poly2, \poly3, \tmp
  str \tmp, [\rptr_tmp, #-8]

  smuadx \tmp, \poly2, \poly3
  str \tmp, [\rptr_tmp, #-4]
.endm

// reduce 2 registers
.macro deserialize aptr, tmp, tmp2, tmp3, t0, t1
 ldrb.w \tmp, [\aptr, #2]
 ldrh.w \tmp2, [\aptr, #3]
 ldrb.w \tmp3, [\aptr, #5]
 ldrh.w \t0, [\aptr], #6

 ubfx \t1, \t0, #12, #4
 ubfx \t0, \t0, #0, #12
 orr \t1, \t1, \tmp, lsl #4
 orr \t0, \t0, \t1, lsl #16
 // tmp is free now
 ubfx \t1, \tmp2, #12, #4
 ubfx \tmp, \tmp2, #0, #12
 orr \t1, \t1, \tmp3, lsl #4
 orr \t1, \tmp, \t1, lsl #16
.endm

// void frombytes_mul_asm_16_32(int32_t *r_tmp, const int16_t *b, const unsigned char *c, const int32_t zetas[64])
.global frombytes_mul_asm_16_32_opt_m7
.type frombytes_mul_asm_16_32_opt_m7, %function
.align 2
frombytes_mul_asm_16_32_opt_m7:
  push {r4-r11, r14}

  rptr_tmp .req r0
  bptr     .req r1
  aptr     .req r2
  zetaptr  .req r3
  t0       .req r4
 t1       .req r5
 tmp      .req r6
 tmp2     .req r7
 tmp3     .req r8
 q        .req r9
 qa       .req r10
 qinv     .req r11
 zeta     .req r12
 ctr      .req r14

  movw qa, #26632
 movt  q, #3329
 ### qinv=0x6ba8f301
 movw qinv, #62209
 movt qinv, #27560

  add ctr, rptr_tmp, #64*4*4
                                       // Instructions:    6
                                       // Expected cycles: 6
                                       // Expected IPC:    1.00
                                       //
                                       // Cycle bound:     6.0
                                       // IPC bound:       1.00
                                       //
                                       // Wall time:     0.01s
                                       // User time:     0.01s
                                       //
                                       // ----- cycle (expected) ------>
                                       // 0                        25
                                       // |------------------------|----
        ldrh.w r4, [r2], #6            // *.............................
        ldrb.w r7, [r2, #-4]           // .*............................
        ubfx r12, r4, #12, #4          // ...*..........................
        ubfx r4, r4, #0, #12           // ....*.........................
        orr r5, r12, r7, lsl #4        // .....*........................
        ldrh.w r12, [r2, #-3]          // .....*........................

                                       // ------ cycle (expected) ------>
                                       // 0                        25
                                       // |------------------------|-----
        // ldrh.w r11, [r2], #6        // *..............................
        // ldrb.w r4, [r2, #-4]        // .*.............................
        // ubfx r7, r11, #12, #4       // ...*...........................
        // orr r5, r7, r4, lsl #4      // .....*.........................
        // ubfx r4, r11, #0, #12       // ....*..........................
        // ldrh.w r12, [r2, #-3]       // .....*.........................

        sub r14, r14, #16
1:
                                         // Instructions:    31
                                         // Expected cycles: 16
                                         // Expected IPC:    1.94
                                         //
                                         // Cycle bound:     22.0
                                         // IPC bound:       1.41
                                         //
                                         // Wall time:     1.84s
                                         // User time:     1.84s
                                         //
                                         // ----- cycle (expected) ------>
                                         // 0                        25
                                         // |------------------------|----
        ldr.w r11, [r3], #4              // *.............................
        ldrb.w r7, [r2, #-1]             // *.............................
        ldr r8, [r1], #8                 // .*............................
        orr r4, r4, r5, lsl #16          // .*............................
        ubfx r6, r12, #12, #4            // ..*...........................
        smulwt r5, r11, r4               // ..*...........................
        orr r7, r6, r7, lsl #4           // ...*..........................
        smuadx r6, r8, r4                // ...*..........................
        ubfx r12, r12, #0, #12           // ....*.........................
        smlabt r5, r5, r9, r10           // ....*.........................
        orr r12, r12, r7, lsl #16        // .....*........................
        str r6, [r0, #4]                 // .....*........................
        neg r11, r11                     // ......*.......................
        smultt r7, r8, r5                // ......*.......................
        smulwt r5, r11, r12              // .......*......................
        ldrh.w r11, [r2], #6             // .......e......................
        smlabb r7, r8, r4, r7            // ........*.....................
        ldr r6, [r1, #-4]                // ........*.....................
        smlabt r5, r5, r9, r10           // .........*....................
        ldrb.w r4, [r2, #-4]             // .........e....................
        str r7, [r0], #16                // ..........*................... // @slothy:core
        cmp.w r0, r14                    // ..........*...................
        ubfx r7, r11, #12, #4            // ...........e..................
        smultt r5, r6, r5                // ...........*..................
        smlabb r8, r6, r12, r5           // ............*.................
        orr r5, r7, r4, lsl #4           // ............e.................
        smuadx r6, r6, r12               // .............*................
        ubfx r4, r11, #0, #12            // ..............e...............
        str r8, [r0, #-8]                // ..............*...............
        ldrh.w r12, [r2, #-3]            // ...............e..............
        str r6, [r0, #-4]                // ...............*..............

                                        // ------ cycle (expected) ------>
                                        // 0                        25
                                        // |------------------------|-----
        // ldr.w r12, [r3], #4          // .........*...............~.....
        // ldrb.w r6, [r2, #2]          // ..e......'........~......'.....
        // ldrh.w r7, [r2, #3]          // ........e'..............~'.....
        // ldrb.w r8, [r2, #5]          // .........*...............~.....
        // ldrh.w r4, [r2], #6          // e........'......~........'.....
        // ubfx r5, r4, #12, #4         // ....e....'..........~....'.....
        // ubfx r4, r4, #0, #12         // .......e.'.............~.'.....
        // orr r5, r5, r6, lsl #4       // .....e...'...........~...'.....
        // orr r4, r4, r5, lsl #16      // .........'*..............'~....
        // ubfx r5, r7, #12, #4         // .........'.*.............'.~...
        // ubfx r6, r7, #0, #12         // .........'...*...........'...~.
        // orr r5, r5, r8, lsl #4       // .........'..*............'..~..
        // orr r5, r6, r5, lsl #16      // .........'....*..........'.....
        // ldr r6, [r1], #8             // .........'*..............'~....
        // ldr r7, [r1, #-4]            // .~.......'.......*.......'.....
        // smulwt r8, r12, r4           // .........'.*.............'.~...
        // smlabt r8, r8, r9, r10       // .........'...*...........'...~.
        // smultt r8, r6, r8            // .........'.....*.........'.....
        // smlabb r8, r6, r4, r8        // .~.......'.......*.......'.....
        // str r8, [r0], #16            // ...~.....'.........*.....'.....
        // smuadx r8, r6, r4            // .........'..*............'..~..
        // str r8, [r0, #-12]           // .........'....*..........'.....
        // neg r12, r12                 // .........'.....*.........'.....
        // smulwt r8, r12, r5           // ~........'......*........'.....
        // smlabt r8, r8, r9, r10       // ..~......'........*......'.....
        // smultt r8, r7, r8            // ....~....'..........*....'.....
        // smlabb r8, r7, r5, r8        // .....~...'...........*...'.....
        // str r8, [r0, #-8]            // .......~.'.............*.'.....
        // smuadx r8, r7, r5            // ......~..'............*..'.....
        // str r8, [r0, #-4]            // ........~'..............*'.....
        // cmp.w r0, r14                // ...~.....'.........*.....'.....

        bne 1b
                                        // Instructions:    25
                                        // Expected cycles: 16
                                        // Expected IPC:    1.56
                                        //
                                        // Cycle bound:     16.0
                                        // IPC bound:       1.56
                                        //
                                        // Wall time:     0.09s
                                        // User time:     0.09s
                                        //
                                        // ----- cycle (expected) ------>
                                        // 0                        25
                                        // |------------------------|----
        ldrb.w r7, [r2, #-1]            // *.............................
        ldr.w r8, [r3], #4              // *.............................
        orr r11, r4, r5, lsl #16        // .*............................
        ldr r5, [r1], #8                // .*............................
        ubfx r4, r12, #12, #4           // ..*...........................
        smulwt r6, r8, r11              // ..*...........................
        orr r7, r4, r7, lsl #4          // ...*..........................
        smuadx r4, r5, r11              // ...*..........................
        neg r8, r8                      // ....*.........................
        smlabt r6, r6, r9, r10          // ....*.........................
        cmp.w r0, r14                   // .....*........................
        str r4, [r0, #4]                // .....*........................
        ubfx r4, r12, #0, #12           // ......*.......................
        smultt r12, r5, r6              // ......*.......................
        smlabb r12, r5, r11, r12        // .......*......................
        orr r11, r4, r7, lsl #16        // .......*......................
        str r12, [r0], #16              // ........*..................... // @slothy:core
        ldr r4, [r1, #-4]               // ........*.....................
        smulwt r12, r8, r11             // .........*....................
        smuadx r6, r4, r11              // ..........*...................
        smlabt r12, r12, r9, r10        // ...........*..................
        str r6, [r0, #-4]               // ............*.................
        smultt r12, r4, r12             // .............*................
        smlabb r11, r4, r11, r12        // ..............*...............
        str r11, [r0, #-8]              // ...............*..............

                                          // ------ cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|-----
        // ldr.w r11, [r3], #4            // *..............................
        // ldrb.w r7, [r2, #-1]           // *..............................
        // ldr r8, [r1], #8               // .*.............................
        // orr r4, r4, r5, lsl #16        // .*.............................
        // ubfx r6, r12, #12, #4          // ..*............................
        // smulwt r5, r11, r4             // ..*............................
        // orr r7, r6, r7, lsl #4         // ...*...........................
        // smuadx r6, r8, r4              // ...*...........................
        // ubfx r12, r12, #0, #12         // ......*........................
        // smlabt r5, r5, r9, r10         // ....*..........................
        // orr r12, r12, r7, lsl #16      // .......*.......................
        // str r6, [r0, #4]               // .....*.........................
        // neg r11, r11                   // ....*..........................
        // smultt r7, r8, r5              // ......*........................
        // smulwt r5, r11, r12            // .........*.....................
        // smlabb r7, r8, r4, r7          // .......*.......................
        // ldr r6, [r1, #-4]              // ........*......................
        // smlabt r5, r5, r9, r10         // ...........*...................
        // str r7, [r0], #16              // ........*......................
        // cmp.w r0, r14                  // .....*.........................
        // smultt r5, r6, r5              // .............*.................
        // smlabb r8, r6, r12, r5         // ..............*................
        // smuadx r6, r6, r12             // ..........*....................
        // str r8, [r0, #-8]              // ...............*...............
        // str r6, [r0, #-4]              // ............*..................


pop {r4-r11, pc}

.size frombytes_mul_asm_16_32_opt_m7, .-frombytes_mul_asm_16_32_opt_m7