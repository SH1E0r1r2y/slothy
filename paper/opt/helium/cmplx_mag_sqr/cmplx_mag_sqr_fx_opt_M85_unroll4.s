        .syntax unified
        .type   cmplx_mag_sqr_fx_opt_M85_unroll4, %function
        .global cmplx_mag_sqr_fx_opt_M85_unroll4

        .text
        .align 4
cmplx_mag_sqr_fx_opt_M85_unroll4:
        push {r4-r12,lr}
        vpush {d0-d15}

        out   .req r0
        in    .req r1
        sz    .req r2

        lsr lr, sz, #2
        wls lr, lr, end
.p2align 2
        vld20.32 {q5,q6}, [r1]          // *..................
        // gap                          // ...................
        vld21.32 {q5,q6}, [r1]!         // .*.................
        // gap                          // ...................
        vld20.32 {q3,q4}, [r1]          // ..*................
        // gap                          // ...................
        vld21.32 {q3,q4}, [r1]!         // ...*...............
        vmulh.s32 q7, q6, q6            // ....*..............
        vld20.32 {q0,q1}, [r1]          // .....*.............
        vmulh.s32 q6, q5, q5            // ......*............
        vld21.32 {q0,q1}, [r1]!         // .......*...........
        vmulh.s32 q5, q3, q3            // ........*..........
        vld20.32 {q2,q3}, [r1]          // .........*.........
        vmulh.s32 q4, q4, q4            // ..........*........
        vld21.32 {q2,q3}, [r1]!         // ...........*.......
        vmulh.s32 q0, q0, q0            // ............*......
        vhadd.s32 q4, q4, q5            // .............*.....
        vmulh.s32 q5, q1, q1            // ..............*....
        vhadd.s32 q1, q7, q6            // ...............*...
        vmulh.s32 q7, q3, q3            // ................*..
        vhadd.s32 q0, q5, q0            // .................*.
        vmulh.s32 q3, q2, q2            // ..................*
        
        // original source code
        // vld20.32 {q5,q6}, [r1]       // *.................. 
        // vld21.32 {q5,q6}, [r1]!      // .*................. 
        // vld20.32 {q3,q4}, [r1]       // ..*................ 
        // vld21.32 {q3,q4}, [r1]!      // ...*............... 
        // vmulh.s32 q0, q6, q6         // ....*.............. 
        // vld20.32 {q6,q7}, [r1]       // .....*............. 
        // vmulh.s32 q1, q5, q5         // ......*............ 
        // vld21.32 {q6,q7}, [r1]!      // .......*........... 
        // vmulh.s32 q5, q3, q3         // ........*.......... 
        // vld20.32 {q2,q3}, [r1]       // .........*......... 
        // vmulh.s32 q4, q4, q4         // ..........*........ 
        // vld21.32 {q2,q3}, [r1]!      // ...........*....... 
        // vmulh.s32 q6, q6, q6         // ............*...... 
        // vhadd.s32 q4, q4, q5         // .............*..... 
        // vmulh.s32 q5, q7, q7         // ..............*.... 
        // vhadd.s32 q1, q0, q1         // ...............*... 
        // vmulh.s32 q7, q3, q3         // ................*.. 
        // vhadd.s32 q0, q5, q6         // .................*. 
        // vmulh.s32 q3, q2, q2         // ..................* 
        
        lsr lr, lr, #2
        sub lr, lr, #1
.p2align 2
start:
        vld20.32 {q5,q6}, [r1]           // e.......................
        vstrw.u32 q1, [r0] , #16         // .....*..................
        vhadd.s32 q1, q7, q3             // ......................*.
        vstrw.u32 q4, [r0] , #16         // ...........*............
        vld21.32 {q5,q6}, [r1]!          // .e......................
        vstrw.u32 q0, [r0] , #16         // .................*......
        vld20.32 {q3,q4}, [r1]           // ......e.................
        vstrw.u32 q1, [r0] , #16         // .......................*
        vld21.32 {q3,q4}, [r1]!          // .......e................
        vmulh.s32 q0, q6, q6             // ...e....................
        vld20.32 {q6,q7}, [r1]           // ............e...........
        vmulh.s32 q1, q5, q5             // ..e.....................
        vld21.32 {q6,q7}, [r1]!          // .............e..........
        vmulh.s32 q5, q3, q3             // ........e...............
        vld20.32 {q2,q3}, [r1]           // ..................e.....
        vmulh.s32 q4, q4, q4             // .........e..............
        vld21.32 {q2,q3}, [r1]!          // ...................e....
        vmulh.s32 q6, q6, q6             // ..............e.........
        vhadd.s32 q4, q4, q5             // ..........e.............
        vmulh.s32 q5, q7, q7             // ...............e........
        vhadd.s32 q1, q0, q1             // ....e...................
        vmulh.s32 q7, q3, q3             // .....................e..
        vhadd.s32 q0, q5, q6             // ................e.......
        vmulh.s32 q3, q2, q2             // ....................e...
        
        // original source code
        // vld20.32 {q6,q7}, [r1]        // e............................... 
        // vld21.32 {q6,q7}, [r1]!       // ....e........................... 
        // vmulh.s32 q2, q6, q6          // ...........e.................... 
        // vmulh.s32 q3, q7, q7          // .........e...................... 
        // vhadd.s32 q1, q3, q2          // ....................e........... 
        // vstrw.u32 q1, [r0] , #16      // .........................*...... 
        // vld20.32 {q6,q7}, [r1]        // ......e......................... 
        // vld21.32 {q6,q7}, [r1]!       // ........e....................... 
        // vmulh.s32 q2, q6, q6          // .............e.................. 
        // vmulh.s32 q3, q7, q7          // ...............e................ 
        // vhadd.s32 q1, q3, q2          // ..................e............. 
        // vstrw.u32 q1, [r0] , #16      // ...........................*.... 
        // vld20.32 {q6,q7}, [r1]        // ..........e..................... 
        // vld21.32 {q6,q7}, [r1]!       // ............e................... 
        // vmulh.s32 q2, q6, q6          // .................e.............. 
        // vmulh.s32 q3, q7, q7          // ...................e............ 
        // vhadd.s32 q1, q3, q2          // ......................e......... 
        // vstrw.u32 q1, [r0] , #16      // .............................*.. 
        // vld20.32 {q6,q7}, [r1]        // ..............e................. 
        // vld21.32 {q6,q7}, [r1]!       // ................e............... 
        // vmulh.s32 q2, q6, q6          // .......................e........ 
        // vmulh.s32 q3, q7, q7          // .....................e.......... 
        // vhadd.s32 q1, q3, q2          // ..........................*..... 
        // vstrw.u32 q1, [r0] , #16      // ...............................* 
        
        le lr, start
        vstrw.u32 q1, [r0] , #16         // *....
        vhadd.s32 q5, q7, q3             // .*...
        vstrw.u32 q4, [r0] , #16         // ..*..
        // gap                           // .....
        vstrw.u32 q0, [r0] , #16         // ...*.
        // gap                           // .....
        vstrw.u32 q5, [r0] , #16         // ....*
        
        // original source code
        // vstrw.u32 q1, [r0] , #16      // *.... 
        // vhadd.s32 q1, q7, q3          // .*... 
        // vstrw.u32 q4, [r0] , #16      // ..*.. 
        // vstrw.u32 q0, [r0] , #16      // ...*. 
        // vstrw.u32 q1, [r0] , #16      // ....* 
        
end:

        vpop {d0-d15}
        pop {r4-r12,lr}

        bx lr