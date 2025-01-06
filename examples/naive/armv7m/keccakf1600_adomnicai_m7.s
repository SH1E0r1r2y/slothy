/******************************************************************************
 * ARMv7-M assembly implementation of the Keccak-P[1600] permutation finely 
 * tuned for Cortex-M7 processors.
 * This is a rework of the corresponding implementation by Ronny Van Keer from
 * the eXtended Keccak Code Package (XKCP) https://github.com/XKCP/XKCP.
 *  - 32-bit interleaving
 *  - avoid rotating results from the previous instruction for pipelining
 *  - interleaving memory accesses with ALU operations for pipelining
 *
 * For more details, see the note at https://eprint.iacr.org/2023/773
 *
 * @author   Alexandre Adomnicai
 *           alexandre@adomnicai.me 
 *
 * @date     May 2023
 *****************************************************************************/

.thumb
.syntax unified
.text

    @ Credit: Henry S. Warren, Hacker's Delight, Addison-Wesley, 2002
.macro    toBitInterleaving   x0,x1,s0,s1,t,over

    and     \t,\x0,#0x55555555
    orr     \t,\t,\t, LSR #1
    and     \t,\t,#0x33333333
    orr     \t,\t,\t, LSR #2
    and     \t,\t,#0x0F0F0F0F
    orr     \t,\t,\t, LSR #4
    and     \t,\t,#0x00FF00FF
    bfi     \t,\t,#8, #8
    .if \over != 0
    lsr     \s0,\t, #8
    .else
    eor     \s0,\s0,\t, LSR #8
    .endif

    and     \t,\x1,#0x55555555
    orr     \t,\t,\t, LSR #1
    and     \t,\t,#0x33333333
    orr     \t,\t,\t, LSR #2
    and     \t,\t,#0x0F0F0F0F
    orr     \t,\t,\t, LSR #4
    and     \t,\t,#0x00FF00FF
    orr     \t,\t,\t, LSR #8
    eor     \s0,\s0,\t, LSL #16

    and     \t,\x0,#0xAAAAAAAA
    orr     \t,\t,\t, LSL #1
    and     \t,\t,#0xCCCCCCCC
    orr     \t,\t,\t, LSL #2
    and     \t,\t,#0xF0F0F0F0
    orr     \t,\t,\t, LSL #4
    and     \t,\t,#0xFF00FF00
    orr     \t,\t,\t, LSL #8
    .if \over != 0
    lsr     \s1,\t, #16
    .else
    eor     \s1,\s1,\t, LSR #16
    .endif

    and     \t,\x1,#0xAAAAAAAA
    orr     \t,\t,\t, LSL #1
    and     \t,\t,#0xCCCCCCCC
    orr     \t,\t,\t, LSL #2
    and     \t,\t,#0xF0F0F0F0
    orr     \t,\t,\t, LSL #4
    and     \t,\t,#0xFF00FF00
    orr     \t,\t,\t, LSL #8
    bfc     \t, #0, #16
    eors    \s1,\s1,\t
    .endm

    @ Credit: Henry S. Warren, Hacker's Delight, Addison-Wesley, 2002
.macro    fromBitInterleaving     x0, x1, t

    movs    \t, \x0                 @ t = x0@
    bfi     \x0, \x1, #16, #16      @ x0 = (x0 & 0x0000FFFF) | (x1 << 16)@
    bfc     \x1, #0, #16            @   x1 = (t >> 16) | (x1 & 0xFFFF0000)@
    orr     \x1, \x1, \t, LSR #16

    eor     \t, \x0, \x0, LSR #8    @ t = (x0 ^ (x0 >>  8)) & 0x0000FF00UL@  x0 = x0 ^ t ^ (t <<  8)@
    and     \t, #0x0000FF00
    eors    \x0, \x0, \t
    eor     \x0, \x0, \t, LSL #8

    eor     \t, \x0, \x0, LSR #4    @ t = (x0 ^ (x0 >>  4)) & 0x00F000F0UL@  x0 = x0 ^ t ^ (t <<  4)@
    and     \t, #0x00F000F0
    eors    \x0, \x0, \t
    eor     \x0, \x0, \t, LSL #4

    eor     \t, \x0, \x0, LSR #2    @ t = (x0 ^ (x0 >>  2)) & 0x0C0C0C0CUL@  x0 = x0 ^ t ^ (t <<  2)@
    and     \t, #0x0C0C0C0C
    eors    \x0, \x0, \t
    eor     \x0, \x0, \t, LSL #2

    eor     \t, \x0, \x0, LSR #1    @ t = (x0 ^ (x0 >>  1)) & 0x22222222UL@  x0 = x0 ^ t ^ (t <<  1)@
    and     \t, #0x22222222
    eors    \x0, \x0, \t
    eor     \x0, \x0, \t, LSL #1

    eor     \t, \x1, \x1, LSR #8    @ t = (x1 ^ (x1 >>  8)) & 0x0000FF00UL@  x1 = x1 ^ t ^ (t <<  8)@
    and     \t, #0x0000FF00
    eors    \x1, \x1, \t
    eor     \x1, \x1, \t, LSL #8

    eor     \t, \x1, \x1, LSR #4    @ t = (x1 ^ (x1 >>  4)) & 0x00F000F0UL@  x1 = x1 ^ t ^ (t <<  4)@
    and     \t, #0x00F000F0
    eors    \x1, \x1, \t
    eor     \x1, \x1, \t, LSL #4

    eor     \t, \x1, \x1, LSR #2    @ t = (x1 ^ (x1 >>  2)) & 0x0C0C0C0CUL@  x1 = x1 ^ t ^ (t <<  2)@
    and     \t, #0x0C0C0C0C
    eors    \x1, \x1, \t
    eor     \x1, \x1, \t, LSL #2

    eor     \t, \x1, \x1, LSR #1    @ t = (x1 ^ (x1 >>  1)) & 0x22222222UL@  x1 = x1 ^ t ^ (t <<  1)@
    and     \t, #0x22222222
    eors    \x1, \x1, \t
    eor     \x1, \x1, \t, LSL #1
    .endm

@   --- offsets in state
.equ Aba0   , 0*4
.equ Aba1   , 1*4
.equ Abe0   , 2*4
.equ Abe1   , 3*4
.equ Abi0   , 4*4
.equ Abi1   , 5*4
.equ Abo0   , 6*4
.equ Abo1   , 7*4
.equ Abu0   , 8*4
.equ Abu1   , 9*4
.equ Aga0   , 10*4
.equ Aga1   , 11*4
.equ Age0   , 12*4
.equ Age1   , 13*4
.equ Agi0   , 14*4
.equ Agi1   , 15*4
.equ Ago0   , 16*4
.equ Ago1   , 17*4
.equ Agu0   , 18*4
.equ Agu1   , 19*4
.equ Aka0   , 20*4
.equ Aka1   , 21*4
.equ Ake0   , 22*4
.equ Ake1   , 23*4
.equ Aki0   , 24*4
.equ Aki1   , 25*4
.equ Ako0   , 26*4
.equ Ako1   , 27*4
.equ Aku0   , 28*4
.equ Aku1   , 29*4
.equ Ama0   , 30*4
.equ Ama1   , 31*4
.equ Ame0   , 32*4
.equ Ame1   , 33*4
.equ Ami0   , 34*4
.equ Ami1   , 35*4
.equ Amo0   , 36*4
.equ Amo1   , 37*4
.equ Amu0   , 38*4
.equ Amu1   , 39*4
.equ Asa0   , 40*4
.equ Asa1   , 41*4
.equ Ase0   , 42*4
.equ Ase1   , 43*4
.equ Asi0   , 44*4
.equ Asi1   , 45*4
.equ Aso0   , 46*4
.equ Aso1   , 47*4
.equ Asu0   , 48*4
.equ Asu1   , 49*4

@   --- offsets on stack
.equ mDa0   , 0*4
.equ mDa1   , 1*4
.equ mDo0   , 2*4
.equ mDo1   , 3*4
.equ mDi0   , 4*4
.equ mRC    , 5*4

@   --- offsets in temp state on the stack
.equ Eba0   , 6*4
.equ Eba1   , 7*4
.equ Ebe0   , 8*4
.equ Ebe1   , 9*4
.equ Ebi0   , 10*4
.equ Ebi1   , 11*4
.equ Ebo0   , 12*4
.equ Ebo1   , 13*4
.equ Ebu0   , 14*4
.equ Ebu1   , 15*4
.equ Ega0   , 16*4
.equ Ega1   , 17*4
.equ Ege0   , 18*4
.equ Ege1   , 19*4
.equ Egi0   , 20*4
.equ Egi1   , 21*4
.equ Ego0   , 22*4
.equ Ego1   , 23*4
.equ Egu0   , 24*4
.equ Egu1   , 25*4
.equ Eka0   , 26*4
.equ Eka1   , 27*4
.equ Eke0   , 28*4
.equ Eke1   , 29*4
.equ Eki0   , 30*4
.equ Eki1   , 31*4
.equ Eko0   , 32*4
.equ Eko1   , 33*4
.equ Eku0   , 34*4
.equ Eku1   , 35*4
.equ Ema0   , 36*4
.equ Ema1   , 37*4
.equ Eme0   , 38*4
.equ Eme1   , 39*4
.equ Emi0   , 40*4
.equ Emi1   , 41*4
.equ Emo0   , 42*4
.equ Emo1   , 43*4
.equ Emu0   , 44*4
.equ Emu1   , 45*4
.equ Esa0   , 46*4
.equ Esa1   , 47*4
.equ Ese0   , 48*4
.equ Ese1   , 49*4
.equ Esi0   , 50*4
.equ Esi1   , 51*4
.equ Eso0   , 52*4
.equ Eso1   , 53*4
.equ Esu0   , 54*4
.equ Esu1   , 55*4
.equ mSize  , 56*4


/******************************************************************************
 * Load 5 words from memory and XOR them all together. It is used to compute
 * the parity columns for the Theta step.
 *  - dst           destination register
 *  - src1-src5     source registers
 *  - ldreg         register to load the data from
 *****************************************************************************/
.macro xor5 dst, src1, src2, src3, src4, src5, ldreg
    ldr         \dst, [\ldreg, #\src1] // @slothy:reads=[\ldreg\()\src1]
    ldr         r1, [\ldreg, #\src2] // @slothy:reads=[\ldreg\()\src2]
    eors        \dst, \dst, r1
    ldr         r1, [\ldreg, #\src3] // @slothy:reads=[\ldreg\()\src3]
    eors        \dst, \dst, r1
    ldr         r1, [\ldreg, #\src4] // @slothy:reads=[\ldreg\()\src4]
    eors        \dst, \dst, r1
    ldr         r1, [\ldreg, #\src5] // @slothy:reads=[\ldreg\()\src5]
    eors        \dst, \dst, r1
.endm


/******************************************************************************
 * Exclusive-OR where the 2nd operand is rotated by 1 bit to the left.
 *  - dst           destination register
 *  - src1-src2     source registers
 *****************************************************************************/
.macro xorrol dst, src1, src2
    eor         \dst, \src1, \src2, ror #31
.endm


/******************************************************************************
 * Same as xandnotstr but without the str instruction which will be carried
 * out later in order to take advantage of future ldr instructions.
 *  - streg         register to store results to
 *  - stofs         memory offset for the str instruction
 *  - src1-src3     source registers
 *****************************************************************************/
.macro xandnot  streg, stofs, src1, src2, src3
    bic         r1, \src3, \src2
    eors        r1, r1, \src1
    str         r1, [\streg, #\stofs] // @slothy:writes=[\streg\()\stofs]
.endm


/******************************************************************************
 * Apply Theta, Pi, Chi and Iota steps to half a plane (i.e. 5 32-bit words) of
 * the internal state.
 *  - src1-src5     memory offsets to load the input lanes
 *  - dst1-dst5     memory offsets to store the output lanes
 *  - par1-par5     registers that contain the parity lanes
 *  - rot2-rot5     rotation values for the rho step
 *  - ofs           memory offset to load the round constant
 *  - last          boolean value to indicate if we are ending a double round
 *  - ldreg         register to load input lanes from
 *  - streg         register to store output lanes to
 *****************************************************************************/
.macro KeccakThetaRhoPiChiIota  src1, dst1, par1, src2, dst2, par2, rot2, src3, dst3, par3, rot3, src4, dst4, par4, rot4, src5, dst5, par5, rot5, ofs, last, ldreg, streg
    ldr     r3, [\ldreg, #\src1] // @slothy:reads=[\ldreg\()\src1]
    ldr     r4, [\ldreg, #\src2] // @slothy:reads=[\ldreg\()\src2]
    eor     r3, \par1
    ldr     r5, [\ldreg, #\src3] // @slothy:reads=[\ldreg\()\src3]
    eor     r4, \par2
    ldr     r6, [\ldreg, #\src4] // @slothy:reads=[\ldreg\()\src4]
    eor     r5, \par3
    ldr     r7, [\ldreg, #\src5] // @slothy:reads=[\ldreg\()\src5]
    eor     r6, \par4
    eor     r7, \par5
    ror     r4, #32-\rot2
    ror     r5, #32-\rot3
    ror     r6, #32-\rot4
    xandnot \streg, \dst2, r4, r5, r6
    ror     r7, #32-\rot5
    xandnot \streg, \dst3, r5, r6, r7
    xandnot \streg, \dst4, r6, r7, r3
    xandnot \streg, \dst5, r7, r3, r4
    bics    r5, r5, r4
    ldr     r1, [sp, #mRC] // @slothy:reads=[sp\()\mRC]
    eors    r3, r3, r5
    ldr     r4, [r1, #\ofs] // @slothy:reads=[r1\()\ofs]
    eors    r3, r3, r4
.if  \last == 1
    ldr     r4, [r1, #16]! // @slothy:reads=[r1\()16]
    str     r1, [sp, #mRC] // @slothy:writes=[sp\()\mRC]
    cmp     r4, #0xFF
.endif
    str     r3, [\streg, #\dst1] // @slothy:writes=[\streg\()\dst1]
.endm


/******************************************************************************
 * Apply Theta, Pi, Chi and Iota steps to half a plane (i.e. 5 32-bit words) of
 * the internal state.
 *  - src1-src5     memory offsets to load the input lanes
 *  - dst1-dst5     memory offsets to store the output lanes
 *  - par1-par5     registers that contain the parity lanes
 *  - rot1-rot5     rotation values for the rho step
 *  - ldreg         register to load input lanes from
 *  - streg         register to store output lanes to
 *****************************************************************************/
.macro KeccakThetaRhoPiChi src1, dst1, par1, rot1, src2, dst2, par2, rot2, src3, dst3, par3, rot3, src4, dst4, par4, rot4, src5, dst5, par5, rot5, ldreg, streg
    ldr     r3, [\ldreg, #\src1] // @slothy:reads=[\ldreg\()\src1]
    ldr     r4, [\ldreg, #\src2] // @slothy:reads=[\ldreg\()\src2]
    eors    r3, \par1
    ldr     r5, [\ldreg, #\src3] // @slothy:reads=[\ldreg\()\src3]
    eors    r4, \par2
    ldr     r6, [\ldreg, #\src4] // @slothy:reads=[\ldreg\()\src4]
    eors    r5, \par3
    ldr     r7, [\ldreg, #\src5] // @slothy:reads=[\ldreg\()\src5]
    eors    r6, \par4
    eors    r7, \par5
.if  \rot1 > 0
    rors    r3, #32-\rot1
.endif
    rors    r4, #32-\rot2
    rors    r5, #32-\rot3
    xandnot \streg, \dst1, r3, r4, r5
    ror     r6, #32-\rot4
    xandnot \streg, \dst2, r4, r5, r6
    ror     r7, #32-\rot5
    xandnot \streg, \dst3, r5, r6, r7
    xandnot \streg, \dst4, r6, r7, r3
    xandnot \streg, \dst5, r7, r3, r4
.endm

.macro    KeccakRound0
    xor5        r3, Abu0, Agu0, Aku0, Amu0, Asu0, r0
    xor5        r7, Abe1, Age1, Ake1, Ame1, Ase1, r0
    xor5        r6, Abu1, Agu1, Aku1, Amu1, Asu1, r0
    xor5        r2, Abe0, Age0, Ake0, Ame0, Ase0, r0
    xorrol      r4, r3, r7
    eors        r8, r6, r2
    str         r4, [sp, #mDa0] // @slothy:writes=[sp\()\mDa0]
    str         r8, [sp, #mDa1] // @slothy:writes=[sp\()\mDa1]
    xor5        r5, Abi0, Agi0, Aki0, Ami0, Asi0, r0
    xor5        r4, Abi1, Agi1, Aki1, Ami1, Asi1, r0
    xorrol      r9, r5, r6
    eors        r3, r3, r4
    str         r9, [sp, #mDo0] // @slothy:writes=[sp\()\mDo0]
    str         r3, [sp, #mDo1] // @slothy:writes=[sp\()\mDo1]
    xor5        r3, Aba0, Aga0, Aka0, Ama0, Asa0, r0
    xor5        r6, Aba1, Aga1, Aka1, Ama1, Asa1, r0
    xorrol      r10, r3, r4
    eors        r11, r6, r5
    xor5        r4, Abo1, Ago1, Ako1, Amo1, Aso1, r0
    xor5        r5, Abo0, Ago0, Ako0, Amo0, Aso0, r0
    xorrol      r1, r2, r4
    str         r1, [sp, #mDi0] // @slothy:writes=[sp\()\mDi0]
    eors        r2, r7, r5
    xorrol      r12, r5, r6
    eors        lr, r4, r3

    KeccakThetaRhoPiChi Abo0, Ega0, r9, 14, Agu0, Ege0, r12, 10, Aka1, Egi0, r8, 2, Ame1, Ego0, r11, 23, Asi1, Egu0, r2, 31, r0, sp

    KeccakThetaRhoPiChi Abe0, Eka1, r10,  0, Agi1, Eke1,  r2,  3, Ako0, Eki1,  r9, 12, Amu1, Eko1,  lr,  4, Asa1, Eku1,  r8,  9,   r0, sp
    ldr         r8, [sp, #mDa0] // @slothy:reads=[sp\()\mDa0]

    KeccakThetaRhoPiChi Abu1, Ema0, lr, 14, Aga0, Eme0, r8, 18, Ake0, Emi0, r10, 5, Ami1, Emo0, r2, 8, Aso0, Emu0, r9, 28, r0, sp

    KeccakThetaRhoPiChi Abi1, Esa1, r2, 31, Ago0, Ese1, r9, 27, Aku0, Esi1, r12, 19, Ama0, Eso1, r8, 20, Ase1, Esu1, r11, 1, r0, sp

    ldr         r9, [sp, #mDo1] // @slothy:reads=[sp\()\mDo1]
    KeccakThetaRhoPiChiIota Aba0, Eba0,  r8, Age0, Ebe0, r10, 22, Aki1, Ebi0, r2, 22, Amo1, Ebo0, r9, 11,Asu0, Ebu0, r12, 7, 0, 0, r0, sp
    ldr         r2, [sp, #mDi0] // @slothy:reads=[sp\()\mDi0]

    KeccakThetaRhoPiChi     Abo1, Ega1,  r9, 14, Agu1, Ege1, lr, 10, Aka0, Egi1, r8, 1, Ame0, Ego1, r10, 22, Asi0, Egu1, r2, 30, r0, sp
    KeccakThetaRhoPiChi     Abe1, Eka0, r11,  1, Agi0, Eke0,  r2,  3, Ako1, Eki0,  r9, 13, Amu0, Eko0, r12,  4, Asa0, Eku0,  r8,  9, r0, sp

    ldr         r8, [sp, #mDa1] // @slothy:reads=[sp\()\mDa1]
    KeccakThetaRhoPiChi     Abu0, Ema1, r12, 13, Aga1, Eme1,  r8, 18, Ake1, Emi1, r11,  5, Ami0, Emo1,  r2,  7, Aso1, Emu1,  r9, 28, r0, sp

    KeccakThetaRhoPiChi     Abi0, Esa0,  r2, 31, Ago1, Ese0,   r9, 28, Aku1, Esi0,  lr, 20, Ama1, Eso0,  r8, 21, Ase0, Esu0, r10,  1, r0, sp

    ldr         r9, [sp, #mDo0] // @slothy:reads=[sp\()\mDo0]
    KeccakThetaRhoPiChiIota Aba1, Eba1,  r8,     Age1, Ebe1, r11, 22, Aki0, Ebi1,  r2, 21, Amo0, Ebo1,  r9, 10, Asu1, Ebu1,  lr,  7, 4, 0, r0, sp
.endm


.macro    KeccakRound1
    xor5        r3, Ebu0, Egu0, Eku0, Emu0, Esu0, sp
    xor5        r7, Ebe1, Ege1, Eke1, Eme1, Ese1, sp
    xor5        r6, Ebu1, Egu1, Eku1, Emu1, Esu1, sp
    xor5        r2, Ebe0, Ege0, Eke0, Eme0, Ese0, sp
    xorrol      r4, r3, r7
    eors        r8, r6, r2
    str         r4, [sp, #mDa0] // @slothy:writes=[sp\()\mDa0]
    str         r8, [sp, #mDa1] // @slothy:writes=[sp\()\mDa1]
    xor5        r5,  Ebi0, Egi0, Eki0, Emi0, Esi0, sp
    xor5        r4,  Ebi1, Egi1, Eki1, Emi1, Esi1, sp
    xorrol      r9, r5, r6
    eors        r3, r3, r4
    str         r9, [sp, #mDo0] // @slothy:writes=[sp\()\mDo0]
    str         r3, [sp, #mDo1] // @slothy:writes=[sp\()\mDo1]
    xor5        r3,  Eba0, Ega0, Eka0, Ema0, Esa0, sp
    xor5        r6,  Eba1, Ega1, Eka1, Ema1, Esa1, sp
    xorrol      r10, r3, r4
    eors        r11, r6, r5
    xor5        r4,  Ebo1, Ego1, Eko1, Emo1, Eso1, sp
    xor5        r5,  Ebo0, Ego0, Eko0, Emo0, Eso0, sp
    xorrol      r1, r2, r4
    str         r1, [sp, #mDi0] // @slothy:writes=[sp\()\mDi0]
    eors        r2, r7, r5
    xorrol      r12, r5, r6
    eors        lr, r4, r3

    KeccakThetaRhoPiChi     Ebo0, Aga0,  r9, 14, Egu0, Age0, r12, 10, Eka1, Agi0,  r8,  2, Eme1, Ago0, r11, 23, Esi1, Agu0,  r2, 31, sp, r0
    KeccakThetaRhoPiChi     Ebe0, Aka1, r10,  0, Egi1, Ake1,  r2,  3, Eko0, Aki1,  r9, 12, Emu1, Ako1,  lr,  4, Esa1, Aku1,  r8,  9, sp, r0
    ldr         r8, [sp, #mDa0] // @slothy:reads=[sp\()\mDa0]
    KeccakThetaRhoPiChi     Ebu1, Ama0,  lr, 14, Ega0, Ame0,  r8, 18, Eke0, Ami0, r10, 5,  Emi1, Amo0,  r2,  8, Eso0, Amu0,  r9, 28, sp, r0
    KeccakThetaRhoPiChi     Ebi1, Asa1,  r2, 31, Ego0, Ase1,  r9, 27, Eku0, Asi1, r12, 19, Ema0, Aso1,  r8, 20, Ese1, Asu1, r11,  1, sp, r0
    ldr         r9, [sp, #mDo1] // @slothy:reads=[sp\()\mDo1]
    KeccakThetaRhoPiChiIota Eba0, Aba0,  r8,     Ege0, Abe0, r10, 22, Eki1, Abi0,  r2, 22, Emo1, Abo0,  r9, 11, Esu0, Abu0, r12,  7, 8, 0, sp, r0
    ldr         r2, [sp, #mDi0] // @slothy:reads=[sp\()\mDi0]
    KeccakThetaRhoPiChi     Ebo1, Aga1,  r9, 14, Egu1, Age1,  lr, 10, Eka0, Agi1,  r8,  1, Eme0, Ago1, r10, 22, Esi0, Agu1,  r2, 30, sp, r0
    KeccakThetaRhoPiChi     Ebe1, Aka0, r11,  1, Egi0, Ake0,  r2,  3, Eko1, Aki0,  r9, 13, Emu0, Ako0, r12,  4, Esa0, Aku0,  r8,  9, sp, r0
    ldr         r8, [sp, #mDa1] // @slothy:reads=[sp\()\mDa1]
    KeccakThetaRhoPiChi     Ebu0, Ama1, r12, 13, Ega1, Ame1,  r8, 18, Eke1, Ami1, r11,  5, Emi0, Amo1,  r2,  7, Eso1, Amu1,  r9, 28, sp, r0
    KeccakThetaRhoPiChi     Ebi0, Asa0,  r2, 31, Ego1, Ase0,   r9, 28, Eku1, Asi0,  lr, 20, Ema1, Aso0,  r8, 21, Ese0, Asu0, r10,  1, sp, r0
    ldr         r9, [sp, #mDo0] // @slothy:reads=[sp\()\mDo0]
    KeccakThetaRhoPiChiIota Eba1, Aba1,  r8,    Ege1, Abe1, r11, 22,Eki0, Abi1,  r2, 21,Emo0, Abo1,  r9, 10,Esu1, Abu1,  lr,  7,12, 1, sp, r0
.endm


@----------------------------------------------------------------------------
@
@ void KeccakP1600_StaticInitialize( void )
@
.align 8
.type   KeccakP1600_StaticInitialize, %function;
KeccakP1600_StaticInitialize:
    bx      lr


@----------------------------------------------------------------------------
@
@ void KeccakP1600_Initialize(void *state)
@
.align 8
.type   KeccakP1600_Initialize, %function;
KeccakP1600_Initialize:
    push    {r4 - r5}
    movs    r1, #0
    movs    r2, #0
    movs    r3, #0
    movs    r4, #0
    movs    r5, #0
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    stmia   r0!, { r1 - r5 }
    pop     {r4 - r5}
    bx      lr


@ ----------------------------------------------------------------------------
@
@  void KeccakP1600_AddByte(void *state, unsigned char byte, unsigned int offset)
@
.align 8
.type   KeccakP1600_AddByte, %function;
KeccakP1600_AddByte:
    push    {r4 - r7}
    bic     r3, r2, #7                              @ r3 = offset & ~7
    adds    r0, r0, r3                              @ state += r3
    ands    r2, r2, #7                              @ offset &= 7 (part not lane aligned)

    movs    r4, #0
    movs    r5, #0
    push    { r4 - r5 }
    add     r2, r2, sp
    strb    r1, [r2]
    pop     { r4 - r5 }
    ldrd    r6, r7, [r0]
    toBitInterleaving   r4, r5, r6, r7, r3, 0
    strd    r6, r7, [r0]
    pop     {r4 - r7}
    bx      lr


@----------------------------------------------------------------------------
@
@ void KeccakP1600_AddBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length)
@
.align 8
.type   KeccakP1600_AddBytes, %function;
KeccakP1600_AddBytes:
    cbz     r3, KeccakP1600_AddBytes_Exit1
    push    {r4 - r8, lr}                           @ then
    bic     r4, r2, #7                              @ offset &= ~7
    adds    r0, r0, r4                              @ add whole lane offset to state pointer
    ands    r2, r2, #7                              @ offset &= 7 (part not lane aligned)
    beq     KeccakP1600_AddBytes_CheckLanes @ .if offset != 0
    movs    r4, r3                                  @ then, do remaining bytes in first lane
    rsb     r5, r2, #8                              @ max size in lane = 8 - offset
    cmp     r4, r5
    ble     KeccakP1600_AddBytes_BytesAlign
    movs    r4, r5
KeccakP1600_AddBytes_BytesAlign:
    sub     r8, r3, r4                              @ size left
    movs    r3, r4
    bl      __KeccakP1600_AddBytesInLane
    mov     r3, r8
KeccakP1600_AddBytes_CheckLanes:
    lsrs    r2, r3, #3                              @ .if length >= 8
    beq     KeccakP1600_AddBytes_Bytes
    mov     r8, r3
    bl      __KeccakP1600_AddLanes
    and     r3, r8, #7
KeccakP1600_AddBytes_Bytes:
    cbz     r3, KeccakP1600_AddBytes_Exit
    movs    r2, #0
    bl      __KeccakP1600_AddBytesInLane
KeccakP1600_AddBytes_Exit:
    pop     {r4 - r8, pc}
KeccakP1600_AddBytes_Exit1:
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_AddLanes
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 laneCount
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@ Changed: r2-r7
@
.align 8
__KeccakP1600_AddLanes:
__KeccakP1600_AddLanes_LoopAligned:
    ldr     r4, [r1], #4
    ldr     r5, [r1], #4
    ldrd    r6, r7, [r0]
    toBitInterleaving   r4, r5, r6, r7, r3, 0
    strd    r6, r7, [r0], #8
    subs    r2, r2, #1
    bne     __KeccakP1600_AddLanes_LoopAligned
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_AddBytesInLane
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 offset in lane
@  r3 length
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@  Changed: r2-r7
@
.align 8
__KeccakP1600_AddBytesInLane:
    movs    r4, #0
    movs    r5, #0
    push    { r4 - r5 }
    add     r2, r2, sp
__KeccakP1600_AddBytesInLane_Loop:
    ldrb    r5, [r1], #1
    strb    r5, [r2], #1
    subs    r3, r3, #1
    bne     __KeccakP1600_AddBytesInLane_Loop
    pop     { r4 - r5 }
    ldrd    r6, r7, [r0]
    toBitInterleaving   r4, r5, r6, r7, r3, 0
    strd    r6, r7, [r0], #8
    bx      lr


@----------------------------------------------------------------------------
@
@ void KeccakP1600_OverwriteBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length)
@
.align 8
.type   KeccakP1600_OverwriteBytes, %function;
KeccakP1600_OverwriteBytes:
    cbz     r3, KeccakP1600_OverwriteBytes_Exit1    @ .if length != 0
    push    {r4 - r8, lr}                           @ then
    bic     r4, r2, #7                              @ offset &= ~7
    adds    r0, r0, r4                              @ add whole lane offset to state pointer
    ands    r2, r2, #7                              @ offset &= 7 (part not lane aligned)
    beq     KeccakP1600_OverwriteBytes_CheckLanes   @ .if offset != 0
    movs    r4, r3                                  @ then, do remaining bytes in first lane
    rsb     r5, r2, #8                              @ max size in lane = 8 - offset
    cmp     r4, r5
    ble     KeccakP1600_OverwriteBytes_BytesAlign
    movs    r4, r5
KeccakP1600_OverwriteBytes_BytesAlign:
    sub     r8, r3, r4                              @ size left
    movs    r3, r4
    bl      __KeccakP1600_OverwriteBytesInLane
    mov     r3, r8
KeccakP1600_OverwriteBytes_CheckLanes:
    lsrs    r2, r3, #3                              @ .if length >= 8
    beq     KeccakP1600_OverwriteBytes_Bytes
    mov     r8, r3
    bl      __KeccakP1600_OverwriteLanes
    and     r3, r8, #7
KeccakP1600_OverwriteBytes_Bytes:
    cbz     r3, KeccakP1600_OverwriteBytes_Exit
    movs    r2, #0
    bl      __KeccakP1600_OverwriteBytesInLane
KeccakP1600_OverwriteBytes_Exit:
    pop     {r4 - r8, pc}
KeccakP1600_OverwriteBytes_Exit1:
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_OverwriteLanes
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 laneCount
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@ Changed: r2-r7
@
.align 8
__KeccakP1600_OverwriteLanes:
__KeccakP1600_OverwriteLanes_LoopAligned:
    ldr     r4, [r1], #4
    ldr     r5, [r1], #4
    ldrd    r6, r7, [r0]
    toBitInterleaving   r4, r5, r6, r7, r3, 1
    strd    r6, r7, [r0], #8
    subs    r2, r2, #1
    bne     __KeccakP1600_OverwriteLanes_LoopAligned
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_OverwriteBytesInLane
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 offset in lane
@  r3 length
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@  Changed: r2-r7
@
.align 8
__KeccakP1600_OverwriteBytesInLane:
    movs    r4, #0
    movs    r5, #0
    push    { r4 - r5 }
    lsl     r7, r2, #2
    add     r2, r2, sp
    movs    r6, #0x0F                       @r6 mask to wipe nibbles(bit interleaved bytes) in state
    lsls    r6, r6, r7
    movs    r7, r6
KeccakP1600_OverwriteBytesInLane_Loop:
    orrs    r6, r6, r7
    lsls    r7, r7, #4
    ldrb    r5, [r1], #1
    subs    r3, r3, #1
    strb    r5, [r2], #1
    bne     KeccakP1600_OverwriteBytesInLane_Loop
    pop     { r4 - r5 }
    toBitInterleaving   r4, r5, r2, r3, r7, 1
    ldrd    r4, r5, [r0]
    bics    r4, r4, r6
    bics    r5, r5, r6
    orrs    r2, r2, r4
    orrs    r3, r3, r5
    strd    r2, r3, [r0], #8
    bx      lr


@----------------------------------------------------------------------------
@
@ void KeccakP1600_OverwriteWithZeroes(void *state, unsigned int byteCount)
@
.align 8
.type   KeccakP1600_OverwriteWithZeroes, %function;
KeccakP1600_OverwriteWithZeroes:
    push    {r4 - r5}
    lsrs    r2, r1, #3
    beq     KeccakP1600_OverwriteWithZeroes_Bytes
    movs    r4, #0
    movs    r5, #0
KeccakP1600_OverwriteWithZeroes_LoopLanes:
    strd    r4, r5, [r0], #8
    subs    r2, r2, #1
    bne     KeccakP1600_OverwriteWithZeroes_LoopLanes
KeccakP1600_OverwriteWithZeroes_Bytes:
    ands    r1, #7
    beq     KeccakP1600_OverwriteWithZeroes_Exit
    movs    r3, #0x0F                       @r2 already zero, r3 = mask to wipe nibbles(bit interleaved bytes) in state
KeccakP1600_OverwriteWithZeroes_LoopBytes:
    orrs    r2, r2, r3
    lsls    r3, r3, #4
    subs    r1, r1, #1
    bne     KeccakP1600_OverwriteWithZeroes_LoopBytes
    ldrd    r4, r5, [r0]
    bics    r4, r4, r2
    bics    r5, r5, r2
    strd    r4, r5, [r0], #8
KeccakP1600_OverwriteWithZeroes_Exit:
    pop     {r4 - r5}
    bx      lr


@----------------------------------------------------------------------------
@
@ void KeccakP1600_ExtractBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length)
@
.align 8
.type   KeccakP1600_ExtractBytes, %function;
KeccakP1600_ExtractBytes:
    cbz     r3, KeccakP1600_ExtractBytes_Exit1  @ .if length != 0
    push    {r4 - r8, lr}                           @ then
    bic     r4, r2, #7                              @ offset &= ~7
    adds    r0, r0, r4                              @ add whole lane offset to state pointer
    ands    r2, r2, #7                              @ offset &= 7 (part not lane aligned)
    beq     KeccakP1600_ExtractBytes_CheckLanes @ .if offset != 0
    movs    r4, r3                                  @ then, do remaining bytes in first lane
    rsb     r5, r2, #8                              @ max size in lane = 8 - offset
    cmp     r4, r5
    ble     KeccakP1600_ExtractBytes_BytesAlign
    movs    r4, r5
KeccakP1600_ExtractBytes_BytesAlign:
    sub     r8, r3, r4                              @ size left
    movs    r3, r4
    bl      __KeccakP1600_ExtractBytesInLane
    mov     r3, r8
KeccakP1600_ExtractBytes_CheckLanes:
    lsrs    r2, r3, #3                              @ .if length >= 8
    beq     KeccakP1600_ExtractBytes_Bytes
    mov     r8, r3
    bl      __KeccakP1600_ExtractLanes
    and     r3, r8, #7
KeccakP1600_ExtractBytes_Bytes:
    cbz     r3, KeccakP1600_ExtractBytes_Exit
    movs    r2, #0
    bl      __KeccakP1600_ExtractBytesInLane
KeccakP1600_ExtractBytes_Exit:
    pop     {r4 - r8, pc}
KeccakP1600_ExtractBytes_Exit1:
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_ExtractLanes
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 laneCount
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@ Changed: r2-r5
@
.align 8
__KeccakP1600_ExtractLanes:
__KeccakP1600_ExtractLanes_LoopAligned:
    ldrd    r4, r5, [r0], #8
    fromBitInterleaving r4, r5, r3
    str     r4, [r1], #4
    subs    r2, r2, #1
    str     r5, [r1], #4
    bne     __KeccakP1600_ExtractLanes_LoopAligned
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_ExtractBytesInLane
@
@ Input:
@  r0 state pointer
@  r1 data pointer
@  r2 offset in lane
@  r3 length
@
@ Output:
@  r0 state pointer next lane
@  r1 data pointer next byte to input
@
@  Changed: r2-r6
@
.align 8
__KeccakP1600_ExtractBytesInLane:
    ldrd    r4, r5, [r0], #8
    fromBitInterleaving r4, r5, r6
    push    {r4, r5}
    add     r2, sp, r2
__KeccakP1600_ExtractBytesInLane_Loop:
    ldrb    r4, [r2], #1
    subs    r3, r3, #1
    strb    r4, [r1], #1
    bne     __KeccakP1600_ExtractBytesInLane_Loop
    add     sp, #8
    bx      lr


@----------------------------------------------------------------------------
@
@  void KeccakP1600_ExtractAndAddBytes(void *state, const unsigned char *input, unsigned char *output, unsigned int offset, unsigned int length)
@
.align 8
.type   KeccakP1600_ExtractAndAddBytes, %function;
KeccakP1600_ExtractAndAddBytes:
    push    {r4 - r10, lr}
    mov     r9, r2
    mov     r2, r3
    ldr     r3, [sp, #8*4]
    cbz     r3, KeccakP1600_ExtractAndAddBytes_Exit @ .if length != 0
    bic     r4, r2, #7                              @ then, offset &= ~7
    adds    r0, r0, r4                              @ add whole lane offset to state pointer
    ands    r2, r2, #7                              @ offset &= 7 (part not lane aligned)
    beq     KeccakP1600_ExtractAndAddBytes_CheckLanes   @ .if offset != 0
    movs    r4, r3                                  @ then, do remaining bytes in first lane
    rsb     r5, r2, #8                              @ max size in lane = 8 - offset
    cmp     r4, r5
    ble     KeccakP1600_ExtractAndAddBytes_BytesAlign
    movs    r4, r5
KeccakP1600_ExtractAndAddBytes_BytesAlign:
    sub     r8, r3, r4                              @ size left
    movs    r3, r4
    bl      __KeccakP1600_ExtractAndAddBytesInLane
    mov     r3, r8
KeccakP1600_ExtractAndAddBytes_CheckLanes:
    lsrs    r2, r3, #3                              @ .if length >= 8
    beq     KeccakP1600_ExtractAndAddBytes_Bytes
    mov     r8, r3
    bl      __KeccakP1600_ExtractAndAddLanes
    and     r3, r8, #7
KeccakP1600_ExtractAndAddBytes_Bytes:
    cbz     r3, KeccakP1600_ExtractAndAddBytes_Exit
    movs    r2, #0
    bl      __KeccakP1600_ExtractAndAddBytesInLane
KeccakP1600_ExtractAndAddBytes_Exit:
    pop     {r4 - r10, pc}


@----------------------------------------------------------------------------
@
@ __KeccakP1600_ExtractAndAddLanes
@
@ Input:
@  r0 state pointer
@  r1 input pointer
@  r9 output pointer
@  r2 laneCount
@
@ Output:
@  r0 state pointer next lane
@  r1 input pointer next 32-bit word
@  r9 output pointer next 32-bit word
@
@ Changed: r2-r5
@
.align 8
__KeccakP1600_ExtractAndAddLanes:
__KeccakP1600_ExtractAndAddLanes_LoopAligned:
    ldrd    r4, r5, [r0], #8
    fromBitInterleaving r4, r5, r3
    ldr     r3, [r1], #4
    eors    r4, r4, r3
    str     r4, [r9], #4
    ldr     r3, [r1], #4
    eors    r5, r5, r3
    subs    r2, r2, #1
    str     r5, [r9], #4
    bne     __KeccakP1600_ExtractAndAddLanes_LoopAligned
    bx      lr


@----------------------------------------------------------------------------
@
@ __KeccakP1600_ExtractAndAddBytesInLane
@
@ Input:
@  r0 state pointer
@  r1 input pointer
@  r9 output pointer
@  r2 offset in lane
@  r3 length
@
@ Output:
@  r0 state pointer next lane
@  r1 input pointer next byte
@  r9 output pointer next byte
@
@  Changed: r2-r6
@
.align 8
__KeccakP1600_ExtractAndAddBytesInLane:
    ldrd    r4, r5, [r0], #8
    fromBitInterleaving r4, r5, r6
    push    {r4, r5}
    add     r2, sp, r2
__KeccakP1600_ExtractAndAddBytesInLane_Loop:
    ldrb    r4, [r2], #1
    ldrb    r5, [r1], #1
    eors    r4, r4, r5
    subs    r3, r3, #1
    strb    r4, [r9], #1
    bne     __KeccakP1600_ExtractAndAddBytesInLane_Loop
    add     sp, #8
    bx      lr


.macro    SwapPI13 in0,in1,in2,in3,eo0,eo1,eo2,eo3
    ldr     r3, [r0, #\in0+0]
    ldr     r4, [r0, #\in0+4]
    ldr     r2, [r0, #\in1+0]
    ldr     r1, [r0, #\in1+4]
    str     r2, [r0, #\in0+\eo0*4]
    str     r1, [r0, #\in0+(\eo0^1)*4]
    ldr     r2, [r0, #\in2+0]
    ldr     r1, [r0, #\in2+4]
    str     r2, [r0, #\in1+\eo1*4]
    str     r1, [r0, #\in1+(\eo1^1)*4]
    ldr     r2, [r0, #\in3+0]
    ldr     r1, [r0, #\in3+4]
    str     r2, [r0, #\in2+\eo2*4]
    str     r1, [r0, #\in2+(\eo2^1)*4]
    str     r3, [r0, #\in3+\eo3*4]
    str     r4, [r0, #\in3+(\eo3^1)*4]
    .endm

.macro    SwapPI2 in0,in1,in2,in3
    ldr     r3, [r0, #\in0+0]
    ldr     r4, [r0, #\in0+4]
    ldr     r2, [r0, #\in1+0]
    ldr     r1, [r0, #\in1+4]
    str     r2, [r0, #\in0+4]
    str     r1, [r0, #\in0+0]
    str     r3, [r0, #\in1+4]
    str     r4, [r0, #\in1+0]
    ldr     r3, [r0, #\in2+0]
    ldr     r4, [r0, #\in2+4]
    ldr     r2, [r0, #\in3+0]
    ldr     r1, [r0, #\in3+4]
    str     r2, [r0, #\in2+4]
    str     r1, [r0, #\in2+0]
    str     r3, [r0, #\in3+4]
    str     r4, [r0, #\in3+0]
    .endm

.macro    SwapEO  even,odd
    ldr     r3, [r0, #\even]
    ldr     r4, [r0, #\odd]
    str     r3, [r0, #\odd]
    str     r4, [r0, #\even]
    .endm

@ ----------------------------------------------------------------------------
@
@  void KeccakP1600_Permute_Nrounds(void *state, unsigned int nrounds)
@
.align 8
.type   KeccakP1600_Permute_Nrounds, %function;
KeccakP1600_Permute_Nrounds:
    lsls    r3, r1, #30
    bne     KeccakP1600_Permute_NroundsNotMultiple4
    lsls    r2, r1, #3
    adr     r1, KeccakP1600_Permute_RoundConstants0Mod4
    subs    r1, r1, r2
    b       KeccakP1600_Permute
KeccakP1600_Permute_NroundsNotMultiple4:     @ nrounds not multiple of 4
    push    { r4 - r12, lr }
    sub     sp, #mSize
    lsrs    r2, r1, #2
    lsls    r2, r2, #3+2
    adr     r1, KeccakP1600_Permute_RoundConstants0
    subs    r1, r1, r2
    str     r1, [sp, #mRC]
    lsls    r3, r3, #1
    bcs     KeccakP1600_Permute_Nrounds23Mod4
KeccakP1600_Permute_Nrounds1Mod4:
    SwapPI13    Aga0, Aka0, Asa0, Ama0, 1, 0, 1, 0
    SwapPI13    Abe0, Age0, Ame0, Ake0, 0, 1, 0, 1
    SwapPI13    Abi0, Aki0, Agi0, Asi0, 1, 0, 1, 0
    SwapEO      Ami0, Ami1
    SwapPI13    Abo0, Amo0, Aso0, Ago0, 1, 0, 1, 0
    SwapEO      Ako0, Ako1
    SwapPI13    Abu0, Asu0, Aku0, Amu0, 0, 1, 0, 1
    b.w         KeccakP1600_Permute_Round1Mod4
KeccakP1600_Permute_Nrounds23Mod4:
    bpl         KeccakP1600_Permute_Nrounds2Mod4
KeccakP1600_Permute_Nrounds3Mod4:
    SwapPI13    Aga0, Ama0, Asa0, Aka0, 0, 1, 0, 1
    SwapPI13    Abe0, Ake0, Ame0, Age0, 1, 0, 1, 0
    SwapPI13    Abi0, Asi0, Agi0, Aki0, 0, 1, 0, 1
    SwapEO      Ami0, Ami1
    SwapPI13    Abo0, Ago0, Aso0, Amo0, 0, 1, 0, 1
    SwapEO      Ako0, Ako1
    SwapPI13    Abu0, Amu0, Aku0, Asu0, 1, 0, 1, 0
    b.w         KeccakP1600_Permute_Round3Mod4
KeccakP1600_Permute_Nrounds2Mod4:
    SwapPI2     Aga0, Asa0, Aka0, Ama0
    SwapPI2     Abe0, Ame0, Age0, Ake0
    SwapPI2     Abi0, Agi0, Aki0, Asi0
    SwapPI2     Abo0, Aso0, Ago0, Amo0
    SwapPI2     Abu0, Aku0, Amu0, Asu0
    b.w         KeccakP1600_Permute_Round2Mod4

@ ----------------------------------------------------------------------------
@
@  void KeccakP1600_Permute_12rounds( void *state )
@
.align 8
.type   KeccakP1600_Permute_12rounds, %function;
KeccakP1600_Permute_12rounds:
    adr     r1, KeccakP1600_Permute_RoundConstants12
    b       KeccakP1600_Permute


@ ----------------------------------------------------------------------------
@
@  void KeccakF1600_StatePermute_adomnicai_m7( void *state )
@
.align 8
.global   KeccakF1600_StatePermute_adomnicai_m7
.type KeccakF1600_StatePermute_adomnicai_m7,%function
KeccakF1600_StatePermute_adomnicai_m7:
    adr     r1, KeccakP1600_Permute_RoundConstants24
    b       KeccakP1600_Permute


.align 8
KeccakP1600_Permute_RoundConstants24:
    @       0           1
        .long      0x00000001, 0x00000000
        .long      0x00000000, 0x00000089
        .long      0x00000000, 0x8000008b
        .long      0x00000000, 0x80008080
        .long      0x00000001, 0x0000008b
        .long      0x00000001, 0x00008000
        .long      0x00000001, 0x80008088
        .long      0x00000001, 0x80000082
        .long      0x00000000, 0x0000000b
        .long      0x00000000, 0x0000000a
        .long      0x00000001, 0x00008082
        .long      0x00000000, 0x00008003
KeccakP1600_Permute_RoundConstants12:
        .long      0x00000001, 0x0000808b
        .long      0x00000001, 0x8000000b
        .long      0x00000001, 0x8000008a
        .long      0x00000001, 0x80000081
        .long      0x00000000, 0x80000081
        .long      0x00000000, 0x80000008
        .long      0x00000000, 0x00000083
        .long      0x00000000, 0x80008003
KeccakP1600_Permute_RoundConstants0:
        .long      0x00000001, 0x80008088
        .long      0x00000000, 0x80000088
        .long      0x00000001, 0x00008000
        .long      0x00000000, 0x80008082
KeccakP1600_Permute_RoundConstants0Mod4:
        .long      0x000000FF  @terminator

@----------------------------------------------------------------------------
@
@ void KeccakP1600_Permute( void *state, void * rc )
@
.align 8
KeccakP1600_Permute:
    push    { r4 - r12, lr }
    sub     sp, #mSize
    str     r1, [sp, #mRC]
KeccakP1600_Permute_RoundLoop:
slothy_start_round0:
    KeccakRound0
slothy_end_round0:
KeccakP1600_Permute_Round3Mod4:
slothy_start_round1:
    KeccakRound1
slothy_end_round1:
KeccakP1600_Permute_Round2Mod4:
KeccakP1600_Permute_Round1Mod4:
    bne     KeccakP1600_Permute_RoundLoop
    add     sp, #mSize
    pop     { r4 - r12, pc }

.size KeccakP1600_Permute, .-KeccakP1600_Permute
