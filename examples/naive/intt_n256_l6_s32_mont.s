
///
/// Copyright (c) 2021 Arm Limited
/// Copyright (c) 2022 Hanno Becker
/// Copyright (c) 2023 Amin Abdulrahman, Matthias Kannwischer
/// SPDX-License-Identifier: MIT
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

.data
roots_inv:
.word   57730785 // zeta^504 * 2^31 = 28678040^504 * 2^31 = 25085703 * 2^31
.word 3752846111 // zeta^504 * f(q^(-1) mod 2^32) * 2^31 = 28678040^504 * 375649793 * 2^31
.word   42601623 // zeta^508 * 2^31 = 28678040^508 * 2^31 = 32762154 * 2^31
.word 2096617833 // zeta^508 * f(q^(-1) mod 2^32) * 2^31 = 28678040^508 * 375649793 * 2^31
.word   43352521 // zeta^380 * 2^31 = 28678040^380 * 2^31 = 24111249 * 2^31
.word 3690485815 // zeta^380 * f(q^(-1) mod 2^32) * 2^31 = 28678040^380 * 375649793 * 2^31
.word   59392861 // zeta^376 * 2^31 = 28678040^376 * 2^31 = 5443354 * 2^31
.word  348348067 // zeta^376 * f(q^(-1) mod 2^32) * 2^31 = 28678040^376 * 375649793 * 2^31
.word   65052633 // zeta^444 * 2^31 = 28678040^444 * 2^31 = 11430609 * 2^31
.word 2878986791 // zeta^444 * f(q^(-1) mod 2^32) * 2^31 = 28678040^444 * 375649793 * 2^31
.word   58217677 // zeta^316 * 2^31 = 28678040^316 * 2^31 = 29824921 * 2^31
.word 4056132915 // zeta^316 * f(q^(-1) mod 2^32) * 2^31 = 28678040^316 * 375649793 * 2^31
.word   57130935 // zeta^440 * 2^31 = 28678040^440 * 2^31 = 28470806 * 2^31
.word 1821992521 // zeta^440 * f(q^(-1) mod 2^32) * 2^31 = 28678040^440 * 375649793 * 2^31
.word   14439459 // zeta^476 * 2^31 = 28678040^476 * 2^31 = 15403199 * 2^31
.word 3133213149 // zeta^476 * f(q^(-1) mod 2^32) * 2^31 = 28678040^476 * 375649793 * 2^31
.word   30030779 // zeta^348 * 2^31 = 28678040^348 * 2^31 = 32900632 * 2^31
.word 2105479749 // zeta^348 * f(q^(-1) mod 2^32) * 2^31 = 28678040^348 * 375649793 * 2^31
.word    3784291 // zeta^312 * 2^31 = 28678040^312 * 2^31 = 25309194 * 2^31
.word 1619664797 // zeta^312 * f(q^(-1) mod 2^32) * 2^31 = 28678040^312 * 375649793 * 2^31
.word   48646815 // zeta^412 * 2^31 = 28678040^412 * 2^31 = 11510556 * 2^31
.word  736619361 // zeta^412 * f(q^(-1) mod 2^32) * 2^31 = 28678040^412 * 375649793 * 2^31
.word   15892551 // zeta^284 * 2^31 = 28678040^284 * 2^31 = 17389126 * 2^31
.word 1112819129 // zeta^284 * f(q^(-1) mod 2^32) * 2^31 = 28678040^284 * 375649793 * 2^31
.word   50479773 // zeta^472 * 2^31 = 28678040^472 * 2^31 = 4264131 * 2^31
.word 2420367203 // zeta^472 * f(q^(-1) mod 2^32) * 2^31 = 28678040^472 * 375649793 * 2^31
.word   20532335 // zeta^492 * 2^31 = 28678040^492 * 2^31 = 22651623 * 2^31
.word 3597076881 // zeta^492 * f(q^(-1) mod 2^32) * 2^31 = 28678040^492 * 375649793 * 2^31
.word   46242673 // zeta^364 * 2^31 = 28678040^364 * 2^31 = 8172970 * 2^31
.word  523030159 // zeta^364 * f(q^(-1) mod 2^32) * 2^31 = 28678040^364 * 375649793 * 2^31
.word   58797193 // zeta^344 * 2^31 = 28678040^344 * 2^31 = 24307701 * 2^31
.word 3703057783 // zeta^344 * f(q^(-1) mod 2^32) * 2^31 = 28678040^344 * 375649793 * 2^31
.word   34903951 // zeta^428 * 2^31 = 28678040^428 * 2^31 = 20443666 * 2^31
.word 1308294769 // zeta^428 * f(q^(-1) mod 2^32) * 2^31 = 28678040^428 * 375649793 * 2^31
.word   48022295 // zeta^300 * 2^31 = 28678040^300 * 2^31 = 28778784 * 2^31
.word 1841701609 // zeta^300 * f(q^(-1) mod 2^32) * 2^31 = 28678040^300 * 375649793 * 2^31
.word   62080381 // zeta^408 * 2^31 = 28678040^408 * 2^31 = 6865022 * 2^31
.word  439327875 // zeta^408 * f(q^(-1) mod 2^32) * 2^31 = 28678040^408 * 375649793 * 2^31
.word   55892463 // zeta^460 * 2^31 = 28678040^460 * 2^31 = 8866965 * 2^31
.word 2714926097 // zeta^460 * f(q^(-1) mod 2^32) * 2^31 = 28678040^460 * 375649793 * 2^31
.word    5286953 // zeta^332 * 2^31 = 28678040^332 * 2^31 = 25271104 * 2^31
.word 1617227223 // zeta^332 * f(q^(-1) mod 2^32) * 2^31 = 28678040^332 * 375649793 * 2^31
.word   40872659 // zeta^280 * 2^31 = 28678040^280 * 2^31 = 32984098 * 2^31
.word 2110821165 // zeta^280 * f(q^(-1) mod 2^32) * 2^31 = 28678040^280 * 375649793 * 2^31
.word   42133307 // zeta^396 * 2^31 = 28678040^396 * 2^31 = 14019017 * 2^31
.word 3044632261 // zeta^396 * f(q^(-1) mod 2^32) * 2^31 = 28678040^396 * 375649793 * 2^31
.word   54343827 // zeta^268 * 2^31 = 28678040^268 * 2^31 = 9843973 * 2^31
.word 2777449837 // zeta^268 * f(q^(-1) mod 2^32) * 2^31 = 28678040^268 * 375649793 * 2^31
.word    6014597 // zeta^488 * 2^31 = 28678040^488 * 2^31 = 7194579 * 2^31
.word 2607901563 // zeta^488 * f(q^(-1) mod 2^32) * 2^31 = 28678040^488 * 375649793 * 2^31
.word   25291403 // zeta^500 * 2^31 = 28678040^500 * 2^31 = 355881 * 2^31
.word 2170258293 // zeta^500 * f(q^(-1) mod 2^32) * 2^31 = 28678040^500 * 375649793 * 2^31
.word   14166063 // zeta^372 * 2^31 = 28678040^372 * 2^31 = 13728463 * 2^31
.word 3026038225 // zeta^372 * f(q^(-1) mod 2^32) * 2^31 = 28678040^372 * 375649793 * 2^31
.word   31380141 // zeta^360 * 2^31 = 28678040^360 * 2^31 = 2302061 * 2^31
.word 2294804307 // zeta^360 * f(q^(-1) mod 2^32) * 2^31 = 28678040^360 * 375649793 * 2^31
.word   31709009 // zeta^436 * 2^31 = 28678040^436 * 2^31 = 21728197 * 2^31
.word 3537982127 // zeta^436 * f(q^(-1) mod 2^32) * 2^31 = 28678040^436 * 375649793 * 2^31
.word   12550399 // zeta^308 * 2^31 = 28678040^308 * 2^31 = 11713874 * 2^31
.word  749630721 // zeta^308 * f(q^(-1) mod 2^32) * 2^31 = 28678040^308 * 375649793 * 2^31
.word   21111903 // zeta^424 * 2^31 = 28678040^424 * 2^31 = 13908588 * 2^31
.word  890081697 // zeta^424 * f(q^(-1) mod 2^32) * 2^31 = 28678040^424 * 375649793 * 2^31
.word   65984707 // zeta^468 * 2^31 = 28678040^468 * 2^31 = 25787077 * 2^31
.word 3797730621 // zeta^468 * f(q^(-1) mod 2^32) * 2^31 = 28678040^468 * 375649793 * 2^31
.word   52266271 // zeta^340 * 2^31 = 28678040^340 * 2^31 = 31977548 * 2^31
.word 2046406881 // zeta^340 * f(q^(-1) mod 2^32) * 2^31 = 28678040^340 * 375649793 * 2^31
.word   12778219 // zeta^296 * 2^31 = 28678040^296 * 2^31 = 27066590 * 2^31
.word 1732129557 // zeta^296 * f(q^(-1) mod 2^32) * 2^31 = 28678040^296 * 375649793 * 2^31
.word   39517177 // zeta^404 * 2^31 = 28678040^404 * 2^31 = 14739293 * 2^31
.word 3090726407 // zeta^404 * f(q^(-1) mod 2^32) * 2^31 = 28678040^404 * 375649793 * 2^31
.word   12656259 // zeta^276 * 2^31 = 28678040^276 * 2^31 = 24450888 * 2^31
.word 1564737405 // zeta^276 * f(q^(-1) mod 2^32) * 2^31 = 28678040^276 * 375649793 * 2^31
.word   56722355 // zeta^456 * 2^31 = 28678040^456 * 2^31 = 31418183 * 2^31
.word 4158093901 // zeta^456 * f(q^(-1) mod 2^32) * 2^31 = 28678040^456 * 375649793 * 2^31
.word   27185869 // zeta^484 * 2^31 = 28678040^484 * 2^31 = 15870328 * 2^31
.word 1015623475 // zeta^484 * f(q^(-1) mod 2^32) * 2^31 = 28678040^484 * 375649793 * 2^31
.word   14750755 // zeta^356 * 2^31 = 28678040^356 * 2^31 = 27851125 * 2^31
.word 3929819613 // zeta^356 * f(q^(-1) mod 2^32) * 2^31 = 28678040^356 * 375649793 * 2^31
.word   65797823 // zeta^328 * 2^31 = 28678040^328 * 2^31 = 18723698 * 2^31
.word 1198225217 // zeta^328 * f(q^(-1) mod 2^32) * 2^31 = 28678040^328 * 375649793 * 2^31
.word   13164949 // zeta^420 * 2^31 = 28678040^420 * 2^31 = 28267567 * 2^31
.word 3956469867 // zeta^420 * f(q^(-1) mod 2^32) * 2^31 = 28678040^420 * 375649793 * 2^31
.word    1145583 // zeta^292 * 2^31 = 28678040^292 * 2^31 = 8225248 * 2^31
.word  526375697 // zeta^292 * f(q^(-1) mod 2^32) * 2^31 = 28678040^292 * 375649793 * 2^31
.word   12271567 // zeta^392 * 2^31 = 28678040^392 * 2^31 = 6528331 * 2^31
.word 2565264945 // zeta^392 * f(q^(-1) mod 2^32) * 2^31 = 28678040^392 * 375649793 * 2^31
.word   22449375 // zeta^452 * 2^31 = 28678040^452 * 2^31 = 12336210 * 2^31
.word  789457185 // zeta^452 * f(q^(-1) mod 2^32) * 2^31 = 28678040^452 * 375649793 * 2^31
.word   31982975 // zeta^324 * 2^31 = 28678040^324 * 2^31 = 33215913 * 2^31
.word 4273139841 // zeta^324 * f(q^(-1) mod 2^32) * 2^31 = 28678040^324 * 375649793 * 2^31
.word   35394733 // zeta^264 * 2^31 = 28678040^264 * 2^31 = 9731484 * 2^31
.word  622767443 // zeta^264 * f(q^(-1) mod 2^32) * 2^31 = 28678040^264 * 375649793 * 2^31
.word   23998611 // zeta^388 * 2^31 = 28678040^388 * 2^31 = 12857867 * 2^31
.word 2970324333 // zeta^388 * f(q^(-1) mod 2^32) * 2^31 = 28678040^388 * 375649793 * 2^31
.word   62038423 // zeta^260 * 2^31 = 28678040^260 * 2^31 = 24546403 * 2^31
.word 3718333545 // zeta^260 * f(q^(-1) mod 2^32) * 2^31 = 28678040^260 * 375649793 * 2^31
.word   32686385 // zeta^480 * 2^31 = 28678040^480 * 2^31 = 20044445 * 2^31
.word 3430230223 // zeta^480 * f(q^(-1) mod 2^32) * 2^31 = 28678040^480 * 375649793 * 2^31
.word   58757463 // zeta^496 * 2^31 = 28678040^496 * 2^31 = 17352831 * 2^31
.word 3257980073 // zeta^496 * f(q^(-1) mod 2^32) * 2^31 = 28678040^496 * 375649793 * 2^31
.word   41196349 // zeta^368 * 2^31 = 28678040^368 * 2^31 = 10953311 * 2^31
.word 2848442051 // zeta^368 * f(q^(-1) mod 2^32) * 2^31 = 28678040^368 * 375649793 * 2^31
.word    2430825 // zeta^352 * 2^31 = 28678040^352 * 2^31 = 18811302 * 2^31
.word 1203831447 // zeta^352 * f(q^(-1) mod 2^32) * 2^31 = 28678040^352 * 375649793 * 2^31
.word   26613973 // zeta^432 * 2^31 = 28678040^432 * 2^31 = 23642097 * 2^31
.word 3660462379 // zeta^432 * f(q^(-1) mod 2^32) * 2^31 = 28678040^432 * 375649793 * 2^31
.word    7832335 // zeta^304 * 2^31 = 28678040^304 * 2^31 = 12267508 * 2^31
.word  785060593 // zeta^304 * f(q^(-1) mod 2^32) * 2^31 = 28678040^304 * 375649793 * 2^31
.word   62228979 // zeta^416 * 2^31 = 28678040^416 * 2^31 = 20647416 * 2^31
.word 1321333773 // zeta^416 * f(q^(-1) mod 2^32) * 2^31 = 28678040^416 * 375649793 * 2^31
.word   12542317 // zeta^464 * 2^31 = 28678040^464 * 2^31 = 3271804 * 2^31
.word  209379475 // zeta^464 * f(q^(-1) mod 2^32) * 2^31 = 28678040^464 * 375649793 * 2^31
.word   18302687 // zeta^336 * 2^31 = 28678040^336 * 2^31 = 3819232 * 2^31
.word  244412193 // zeta^336 * f(q^(-1) mod 2^32) * 2^31 = 28678040^336 * 375649793 * 2^31
.word   48515911 // zeta^288 * 2^31 = 28678040^288 * 2^31 = 26823146 * 2^31
.word 1716550329 // zeta^288 * f(q^(-1) mod 2^32) * 2^31 = 28678040^288 * 375649793 * 2^31
.word   21796399 // zeta^400 * 2^31 = 28678040^400 * 2^31 = 18930340 * 2^31
.word 1211449297 // zeta^400 * f(q^(-1) mod 2^32) * 2^31 = 28678040^400 * 375649793 * 2^31
.word   27114239 // zeta^272 * 2^31 = 28678040^272 * 2^31 = 13128918 * 2^31
.word  840186625 // zeta^272 * f(q^(-1) mod 2^32) * 2^31 = 28678040^272 * 375649793 * 2^31
.word   38018305 // zeta^384 * 2^31 = 28678040^384 * 2^31 = 15854702 * 2^31
.word 1014623487 // zeta^384 * f(q^(-1) mod 2^32) * 2^31 = 28678040^384 * 375649793 * 2^31
.word   23796181 // zeta^448 * 2^31 = 28678040^448 * 2^31 = 18977417 * 2^31
.word 3361945643 // zeta^448 * f(q^(-1) mod 2^32) * 2^31 = 28678040^448 * 375649793 * 2^31
.word   52637069 // zeta^320 * 2^31 = 28678040^320 * 2^31 = 30296666 * 2^31
.word 1938838643 // zeta^320 * f(q^(-1) mod 2^32) * 2^31 = 28678040^320 * 375649793 * 2^31
.text

// Montgomery multiplication via rounding
.macro mulmod dst, src, const, const_twisted
        vqrdmulh.s32   \dst,  \src, \const
        vmul.u32       \src,  \src, \const_twisted
        vqrdmlah.s32   \dst,  \src, modulus
.endm

.macro gs_butterfly a, b, root, root_twisted
        vsub.u32       tmp, \a,  \b
        vadd.u32       \a,  \a,  \b
        mulmod         \b,  tmp, \root, \root_twisted
.endm

.align 4
roots_addr: .word roots_inv
.syntax unified
.type invntt_n256_u32_33556993_28678040_incomplete_manual, %function
.global invntt_n256_u32_33556993_28678040_incomplete_manual
invntt_n256_u32_33556993_28678040_incomplete_manual:

        push {r4-r11,lr}
        // Save MVE vector registers
        vpush {d8-d15}

        modulus     .req r12
        root_ptr    .req r11

        .equ modulus_const, 33556993
        movw modulus, #:lower16:modulus_const
        movt modulus, #:upper16:modulus_const
        ldr  root_ptr, roots_addr

        in .req r0

        root0         .req r2
        root0_twisted .req r3
        root1         .req r4
        root1_twisted .req r5
        root2         .req r6
        root2_twisted .req r7

        data0 .req q0
        data1 .req q1
        data2 .req q2
        data3 .req q3

        tmp .req q4

        // Layers 5,6

        mov lr, #16
layer56_loop:
        ldrd root0, root0_twisted, [root_ptr], #24
        ldrd root1, root1_twisted, [root_ptr, #-16]
        ldrd root2, root2_twisted, [root_ptr, #-8]

        vldrw.u32 data0, [in]
        vldrw.u32 data1, [in, #(4*4*1)]
        vldrw.u32 data2, [in, #(4*4*2)]
        vldrw.u32 data3, [in, #(4*4*3)]

        gs_butterfly data0, data1, root1, root1_twisted
        gs_butterfly data2, data3, root2, root2_twisted
        gs_butterfly data0, data2, root0, root0_twisted
        gs_butterfly data1, data3, root0, root0_twisted

        vstrw.u32 data0, [in], #(64)
        vstrw.u32 data1, [in, #(4*4*1 - 64)]
        vstrw.u32 data2, [in, #(4*4*2 - 64)]
        vstrw.u32 data3, [in, #(4*4*3 - 64)]

        le lr, layer56_loop

        sub in, in, #(4*256)

        // TEMPORARY: Barrett reduction
        modulus_neg .req r10
        neg modulus_neg, modulus
        barrett_const .req r1
        .equ const_barrett, 63
        movw barrett_const, #:lower16:const_barrett
        movt barrett_const, #:upper16:const_barrett
        mov lr, #64
1:
        vldrw.u32 data0, [in]
        vqrdmulh.s32 tmp, data0, barrett_const
        vmla.s32 data0, tmp, modulus_neg
        vstrw.u32 data0, [in], #16
        le lr, 1b
2:
        sub in, in, #(4*256)
        .unreq barrett_const
        .unreq modulus_neg

        // Layers 3,4

        // 4 butterfly blocks per root config, 4 root configs
        // loop over root configs

        count .req r1
        mov count, #4

out_start:
        ldrd root0, root0_twisted, [root_ptr], #+24
        ldrd root1, root1_twisted, [root_ptr, #-16]
        ldrd root2, root2_twisted, [root_ptr, #-8]

        mov lr, #4
layer34_loop:
        vldrw.u32 data0, [in]
        vldrw.u32 data1, [in, #(4*1*16)]
        vldrw.u32 data2, [in, #(4*2*16)]
        vldrw.u32 data3, [in, #(4*3*16)]

        gs_butterfly data0, data1, root1, root1_twisted
        gs_butterfly data2, data3, root2, root2_twisted
        gs_butterfly data0, data2, root0, root0_twisted
        gs_butterfly data1, data3, root0, root0_twisted

        vstrw.u32 data0, [in], #(16)
        vstrw.u32 data1, [in, #(4*16*1 - 16)]
        vstrw.u32 data2, [in, #(4*16*2 - 16)]
        vstrw.u32 data3, [in, #(4*16*3 - 16)]

        le lr, layer34_loop
        add in, in, #(4*64 - 4*16)

        subs count, count, #1
        bne out_start

        sub in, in, #(4*256)

        // TEMPORARY: Barrett reduction
        modulus_neg .req r10
        neg modulus_neg, modulus
        barrett_const .req r1
        movw barrett_const, #:lower16:const_barrett
        movt barrett_const, #:upper16:const_barrett
        mov lr, #64
1:
        vldrw.u32 data0, [in]
        vqrdmulh.s32 tmp, data0, barrett_const
        vmla.s32 data0, tmp, modulus_neg
        vstrw.u32 data0, [in], #16
        le lr, 1b
2:
        sub in, in, #(4*256)
        .unreq barrett_const
        .unreq modulus_neg

        in_low       .req r0
        in_high      .req r1
        add in_high, in_low, #(4*128)

        // Layers 1,2

        ldrd root0, root0_twisted, [root_ptr], #+8
        ldrd root1, root1_twisted, [root_ptr], #+8
        ldrd root2, root2_twisted, [root_ptr], #+8

        mov lr, #16
layer12_loop:

        vldrw.u32 data0, [in_low]
        vldrw.u32 data1, [in_low,  #(4*64)]
        vldrw.u32 data2, [in_high]
        vldrw.u32 data3, [in_high, #(4*64)]

        gs_butterfly data0, data1, root1, root1_twisted
        gs_butterfly data2, data3, root2, root2_twisted
        gs_butterfly data0, data2, root0, root0_twisted
        gs_butterfly data1, data3, root0, root0_twisted

        vstrw.u32 data0, [in_low], #16
        vstrw.u32 data1, [in_low, #(4*64 - 16)]
        vstrw.u32 data2, [in_high], #16
        vstrw.u32 data3, [in_high, #(4*64 - 16)]

        le lr, layer12_loop

        // Restore MVE vector registers
        vpop {d8-d15}
        // Restore GPRs
        pop {r4-r11,lr}
        bx lr
