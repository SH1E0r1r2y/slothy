// 2
.macro barrett_32 a, Qbar, Q, tmp
    smmulr \tmp, \a, \Qbar
    mls \a, \tmp, \Q, \a
.endm

.syntax unified
.cpu cortex-m4

.align 2
.global __asm_point_mul_257_16_opt_m7
.type __asm_point_mul_257_16_opt_m7, %function
__asm_point_mul_257_16_opt_m7:
    push.w {r4-r11, lr}

    ldr.w r14, [sp, #36]

    .equ width, 4

    add.w r12, r14, #64*width
                                     // Instructions:    3
                                     // Expected cycles: 2
                                     // Expected IPC:    1.50
                                     //
                                     // Wall time:     0.01s
                                     // User time:     0.01s
                                     //
                                     // ----- cycle (expected) ------>
                                     // 0                        25
                                     // |------------------------|----
        ldr r9, [r1, #4]             // *.............................
        ldr.w r7, [r1], #4*4         // *.............................
        ldr.w r5, [r14], #2*4        // .*............................

                                      // ------ cycle (expected) ------>
                                      // 0                        25
                                      // |------------------------|-----
        // ldr.w r7, [r1], #4*4       // *..............................
        // ldr r9, [r1, #-12]         // *..............................
        // ldr.w r5, [r14], #2*4      // .*.............................

        sub r12, r12, #8
_point_mul_16_loop:
                                           // Instructions:    29
                                           // Expected cycles: 16
                                           // Expected IPC:    1.81
                                           //
                                           // Wall time:     3.62s
                                           // User time:     3.62s
                                           //
                                           // ----- cycle (expected) ------>
                                           // 0                        25
                                           // |------------------------|----
        smultb r8, r7, r5                  // *.............................
        neg r5, r5                         // *.............................
        smultb r4, r9, r5                  // .*............................
        smmulr r11, r8, r2                 // ..*...........................
        ldr r5, [r14, #-4]                 // ..*...........................
        ldr r6, [r1, #-8]                  // ...*..........................
        smmulr r10, r4, r2                 // ...*..........................
        mls r11, r11, r3, r8               // ....*.........................
        mls r8, r10, r3, r4                // .....*........................
        ldr r4, [r1, #-4]                  // .....*........................
        smultb r10, r6, r5                 // ......*.......................
        neg r5, r5                         // ......*.......................
        pkhbt r11, r7, r11, lsl #16        // .......*......................
        smultb r7, r4, r5                  // .......*......................
        pkhbt r5, r9, r8, lsl #16          // ........*.....................
        smmulr r9, r10, r2                 // ........*.....................
        smmulr r8, r7, r2                  // .........*....................
        cmp.w r14, r12                     // .........*....................
        str.w r11, [r0], #2*4              // ..........*...................
        mls r8, r8, r3, r7                 // ...........*..................
        ldr.w r7, [r1], #4*4               // ...........e..................
        mls r11, r9, r3, r10               // ............*.................
        ldr r9, [r1, #-12]                 // ............e.................
        str r5, [r0, #-4]                  // .............*................
        ldr.w r5, [r14], #2*4              // .............e................
        pkhbt r10, r4, r8, lsl #16         // ..............*...............
        str.w r10, [r0, #4]                // ..............*...............
        pkhbt r4, r6, r11, lsl #16         // ...............*..............
        str.w r4, [r0], #2*4               // ...............*..............

                                           // ------ cycle (expected) ------>
                                           // 0                        25
                                           // |------------------------|-----
        // ldr.w r7, [r1, #2*4]            // .....'..*............'..~......
        // ldr.w r8, [r1, #3*4]            // .....'....*..........'....~....
        // ldr.w r9, [r14, #1*4]           // .....'.*.............'.~.......
        // ldr.w r5, [r1, #1*4]            // .e...'...........~...'.........
        // ldr.w r4, [r1], #4*4            // e....'..........~....'.........
        // ldr.w r6, [r14], #2*4           // ..e..'............~..'.........
        // smultb r10, r4, r6              // .....*...............~.........
        // smmulr r11, r10, r2             // .....'.*.............'.~.......
        // mls r10, r11, r3, r10           // .....'...*...........'...~.....
        // pkhbt r4, r4, r10, lsl #16      // .....'......*........'......~..
        // neg r6, r6                      // .....*...............~.........
        // smultb r10, r5, r6              // .....'*..............'~........
        // smmulr r11, r10, r2             // .....'..*............'..~......
        // mls r10, r11, r3, r10           // .....'....*..........'....~....
        // pkhbt r5, r5, r10, lsl #16      // .....'.......*.......'.......~.
        // str.w r5, [r0, #1*4]            // ..~..'............*..'.........
        // str.w r4, [r0], #2*4            // .....'.........*.....'.........
        // smultb r10, r7, r9              // .....'.....*.........'.....~...
        // smmulr r11, r10, r2             // .....'.......*.......'.......~.
        // mls r10, r11, r3, r10           // .~...'...........*...'.........
        // pkhbt r7, r7, r10, lsl #16      // ....~'..............*'.........
        // neg r9, r9                      // .....'.....*.........'.....~...
        // smultb r10, r8, r9              // .....'......*........'......~..
        // smmulr r11, r10, r2             // .....'........*......'.........
        // mls r10, r11, r3, r10           // ~....'..........*....'.........
        // pkhbt r8, r8, r10, lsl #16      // ...~.'.............*.'.........
        // str.w r8, [r0, #1*4]            // ...~.'.............*.'.........
        // str.w r7, [r0], #2*4            // ....~'..............*'.........
        // cmp.w r14, r12                  // .....'........*......'.........

        bne _point_mul_16_loop
                                          // Instructions:    26
                                          // Expected cycles: 16
                                          // Expected IPC:    1.62
                                          //
                                          // Wall time:     0.14s
                                          // User time:     0.14s
                                          //
                                          // ----- cycle (expected) ------>
                                          // 0                        25
                                          // |------------------------|----
        smultb r6, r7, r5                 // *.............................
        neg r5, r5                        // *.............................
        smultb r4, r9, r5                 // .*............................
        ldr r11, [r14, #-4]               // .*............................
        smmulr r5, r6, r2                 // ..*...........................
        smmulr r10, r4, r2                // ...*..........................
        ldr r8, [r1, #-8]                 // ....*.........................
        mls r5, r5, r3, r6                // ....*.........................
        mls r4, r10, r3, r4               // .....*........................
        ldr r10, [r1, #-4]                // .....*........................
        smultb r6, r8, r11                // ......*.......................
        neg r11, r11                      // ......*.......................
        pkhbt r5, r7, r5, lsl #16         // .......*......................
        smultb r7, r10, r11               // .......*......................
        pkhbt r11, r9, r4, lsl #16        // ........*.....................
        smmulr r4, r6, r2                 // ........*.....................
        smmulr r9, r7, r2                 // .........*....................
        mls r6, r4, r3, r6                // ..........*...................
        mls r4, r9, r3, r7                // ...........*..................
        cmp.w r14, r12                    // ............*.................
        str.w r5, [r0], #2*4              // ............*.................
        pkhbt r7, r8, r6, lsl #16         // .............*................
        str r11, [r0, #-4]                // .............*................
        pkhbt r6, r10, r4, lsl #16        // ..............*...............
        str.w r6, [r0, #4]                // ..............*...............
        str.w r7, [r0], #2*4              // ...............*..............

                                            // ------ cycle (expected) ------>
                                            // 0                        25
                                            // |------------------------|-----
        // smultb r8, r7, r5                // *..............................
        // neg r5, r5                       // *..............................
        // smultb r4, r9, r5                // .*.............................
        // smmulr r11, r8, r2               // ..*............................
        // ldr r5, [r14, #-4]               // .*.............................
        // ldr r6, [r1, #-8]                // ....*..........................
        // smmulr r10, r4, r2               // ...*...........................
        // mls r11, r11, r3, r8             // ....*..........................
        // mls r8, r10, r3, r4              // .....*.........................
        // ldr r4, [r1, #-4]                // .....*.........................
        // smultb r10, r6, r5               // ......*........................
        // neg r5, r5                       // ......*........................
        // pkhbt r11, r7, r11, lsl #16      // .......*.......................
        // smultb r7, r4, r5                // .......*.......................
        // pkhbt r5, r9, r8, lsl #16        // ........*......................
        // smmulr r9, r10, r2               // ........*......................
        // smmulr r8, r7, r2                // .........*.....................
        // cmp.w r14, r12                   // ............*..................
        // str.w r11, [r0], #2*4            // ............*..................
        // mls r8, r8, r3, r7               // ...........*...................
        // mls r11, r9, r3, r10             // ..........*....................
        // str r5, [r0, #-4]                // .............*.................
        // pkhbt r10, r4, r8, lsl #16       // ..............*................
        // str.w r10, [r0, #4]              // ..............*................
        // pkhbt r4, r6, r11, lsl #16       // .............*.................
        // str.w r4, [r0], #2*4             // ...............*...............


    pop.w {r4-r11, pc}

.size __asm_point_mul_257_16_opt_m7, .-__asm_point_mul_257_16_opt_m7