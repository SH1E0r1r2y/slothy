
        start:
                                      // Instructions:    24
                                      // Expected cycles: 26
                                      // Expected IPC:    0.92
                                      //
                                      // Cycle bound:     26.0
                                      // IPC bound:       0.92
                                      //
                                      // Wall time:     0.20s
                                      // User time:     0.20s
                                      //
                                      // ----- cycle (expected) ------>
                                      // 0                        25
                                      // |------------------------|----
        ldr r6, [r0, #4]              // *............................. // @slothy:reads=a
        add r10, r2, r6               // .*............................
        eor.w r1, r10, r3             // ..*...........................
        smlabt r7, r2, r2, r1         // ..*...........................
        asrs r5, r7, #1               // ....*.........................
        str r5, [r0, #4]              // ....*......................... // @slothy:writes=a
        ldm r0, {r7,r9,r11}           // .....*........................ // @slothy:reads=a
        add r8, r9, r7                // ........*.....................
        eor.w r2, r8, r11             // .........*....................
        smlabt r12, r9, r9, r2        // .........*....................
        asrs r11, r12, #1             // ...........*..................
        str r11, [r0, #4]             // ...........*.................. // @slothy:writes=a
        ldm r0, {r7,r8,r10}           // ............*................. // @slothy:reads=a
        add r6, r8, r7                // ...............*..............
        eor.w r5, r6, r10             // ................*.............
        smlabt r12, r8, r8, r5        // ................*.............
        asrs r9, r12, #1              // ..................*...........
        str r9, [r0, #4]              // ..................*........... // @slothy:writes=a
        ldm r0, {r1,r2,r8}            // ...................*.......... // @slothy:reads=a
        add r14, r2, r1               // ......................*.......
        eor.w r5, r14, r8             // .......................*......
        smlabt r10, r2, r2, r5        // .......................*......
        asrs r3, r10, #1              // .........................*....
        str r3, [r0, #4]              // .........................*.... // @slothy:writes=a

                                     // ------ cycle (expected) ------>
                                     // 0                        25
                                     // |------------------------|-----
        // ldr r1, [r0,   #4]        // *..............................
        // add r1, r2,r1             // .*.............................
        // eor.w r1,r1, r3           // ..*............................
        // smlabt r3,r2, r2, r1      // ..*............................
        // asrs r3,   r3,#1          // ....*..........................
        // str r3, [r0,#4]           // ....*..........................
        // ldm r0, {r1-r2,r14}       // .....*.........................
        // add r1, r2,r1             // ........*......................
        // eor.w r1,r1, r14          // .........*.....................
        // smlabt r3,r2, r2, r1      // .........*.....................
        // asrs r3,   r3,#1          // ...........*...................
        // str r3, [r0,#4]           // ...........*...................
        // ldm r0, {r1-r3}           // ............*..................
        // add r1, r2,r1             // ...............*...............
        // eor.w r1,r1, r3           // ................*..............
        // smlabt r3,r2, r2, r1      // ................*..............
        // asrs r3,   r3,#1          // ..................*............
        // str r3, [r0,#4]           // ..................*............
        // ldm r0, {r1,r2,r3}        // ...................*...........
        // add r1, r2,r1             // ......................*........
        // eor.w r1,r1, r3           // .......................*.......
        // smlabt r3,r2, r2, r1      // .......................*.......
        // asrs r3,   r3,#1          // .........................*.....
        // str r3, [r0,#4]           // .........................*.....

        end:
