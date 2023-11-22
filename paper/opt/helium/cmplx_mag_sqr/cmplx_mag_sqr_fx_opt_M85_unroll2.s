        .syntax unified
        .type   cmplx_mag_sqr_fx_opt_M85_unroll2, %function
        .global cmplx_mag_sqr_fx_opt_M85_unroll2

        .text
        .align 4
cmplx_mag_sqr_fx_opt_M85_unroll2:
        push {r4-r12,lr}
        vpush {d0-d15}

        out   .req r0
        in    .req r1
        sz    .req r2

        lsr lr, sz, #2
        wls lr, lr, end
.p2align 2
        vld20.32 {q3,q4}, [r1]          // *.......
        // gap                          // ........
        vld21.32 {q3,q4}, [r1]!         // .*......
        // gap                          // ........
        vld20.32 {q1,q2}, [r1]          // ..*.....
        // gap                          // ........
        vmulh.s32 q7, q4, q4            // ...*....
        vld21.32 {q1,q2}, [r1]!         // ....*...
        vmulh.s32 q3, q3, q3            // .....*..
        // gap                          // ........
        vhadd.s32 q6, q7, q3            // ......*.
        vmulh.s32 q7, q1, q1            // .......*
        
        // original source code
        // vld20.32 {q3,q4}, [r1]       // *....... 
        // vld21.32 {q3,q4}, [r1]!      // .*...... 
        // vld20.32 {q1,q2}, [r1]       // ..*..... 
        // vmulh.s32 q5, q4, q4         // ...*.... 
        // vld21.32 {q1,q2}, [r1]!      // ....*... 
        // vmulh.s32 q6, q3, q3         // .....*.. 
        // vhadd.s32 q6, q5, q6         // ......*. 
        // vmulh.s32 q7, q1, q1         // .......* 
        
        lsr lr, lr, #1
        sub lr, lr, #1
.p2align 2
start:
        vld20.32 {q3,q4}, [r1]           // e...........
        vmulh.s32 q0, q2, q2             // .........*..
        vld21.32 {q3,q4}, [r1]!          // .e..........
        vhadd.s32 q7, q0, q7             // ..........*.
        vld20.32 {q1,q2}, [r1]           // ......e.....
        vstrw.u32 q6, [r0] , #16         // .....*......
        vmulh.s32 q5, q4, q4             // ...e........
        vld21.32 {q1,q2}, [r1]!          // .......e....
        vmulh.s32 q6, q3, q3             // ..e.........
        vstrw.u32 q7, [r0] , #16         // ...........*
        vhadd.s32 q6, q5, q6             // ....e.......
        vmulh.s32 q7, q1, q1             // ........e...
        
        // original source code
        // vld20.32 {q6,q7}, [r1]        // e..................... 
        // vld21.32 {q6,q7}, [r1]!       // ..e................... 
        // vmulh.s32 q2, q6, q6          // ........e............. 
        // vmulh.s32 q3, q7, q7          // ......e............... 
        // vhadd.s32 q1, q3, q2          // ..........e........... 
        // vstrw.u32 q1, [r0] , #16      // .................*.... 
        // vld20.32 {q6,q7}, [r1]        // ....e................. 
        // vld21.32 {q6,q7}, [r1]!       // .......e.............. 
        // vmulh.s32 q2, q6, q6          // ...........e.......... 
        // vmulh.s32 q3, q7, q7          // .............*........ 
        // vhadd.s32 q1, q3, q2          // ...............*...... 
        // vstrw.u32 q1, [r0] , #16      // .....................* 
        
        le lr, start
        vmulh.s32 q2, q2, q2             // *...
        vstrw.u32 q6, [r0] , #16         // ..*.
        vhadd.s32 q2, q2, q7             // .*..
        vstrw.u32 q2, [r0] , #16         // ...*
        
        // original source code
        // vmulh.s32 q0, q2, q2          // *... 
        // vhadd.s32 q7, q0, q7          // ..*. 
        // vstrw.u32 q6, [r0] , #16      // .*.. 
        // vstrw.u32 q7, [r0] , #16      // ...* 
        
end:

        vpop {d0-d15}
        pop {r4-r12,lr}

        bx lr