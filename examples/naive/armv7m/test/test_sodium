	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 15, 1
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #176
	stp	x29, x30, [sp, #160]            ; 16-byte Folded Spill
	add	x29, sp, #160
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	str	wzr, [sp, #60]
	bl	_sodium_init
	subs	w8, w0, #0
	cset	w8, ge
	tbnz	w8, #0, LBB0_2
	b	LBB0_1
LBB0_1:
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	mov	w8, #1                          ; =0x1
	str	w8, [sp, #60]
	b	LBB0_7
LBB0_2:
	adrp	x8, l___const.main.message@PAGE
	add	x8, x8, l___const.main.message@PAGEOFF
	ldr	x10, [x8]
	add	x9, sp, #80
	str	x9, [sp, #24]                   ; 8-byte Folded Spill
	str	x10, [sp, #80]
	ldur	x8, [x8, #6]
	stur	x8, [x9, #6]
	sub	x0, x29, #40
	str	x0, [sp, #40]                   ; 8-byte Folded Spill
	mov	x1, #32                         ; =0x20
	bl	_randombytes_buf
	sub	x0, x29, #64
	str	x0, [sp, #32]                   ; 8-byte Folded Spill
	mov	x1, #24                         ; =0x18
	bl	_randombytes_buf
	ldr	x1, [sp, #24]                   ; 8-byte Folded Reload
	ldr	x3, [sp, #32]                   ; 8-byte Folded Reload
	ldr	x4, [sp, #40]                   ; 8-byte Folded Reload
	add	x0, sp, #66
	mov	x2, #14                         ; =0xe
	bl	_crypto_secretbox_easy
	adrp	x0, l_.str.1@PAGE
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	str	xzr, [sp, #48]
	b	LBB0_3
LBB0_3:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp, #48]
	subs	x8, x8, #14
	cset	w8, hs
	tbnz	w8, #0, LBB0_6
	b	LBB0_4
LBB0_4:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldr	x9, [sp, #48]
	add	x8, sp, #66
	ldrb	w10, [x8, x9]
	mov	x9, sp
                                        ; implicit-def: $x8
	mov	x8, x10
	str	x8, [x9]
	adrp	x0, l_.str.2@PAGE
	add	x0, x0, l_.str.2@PAGEOFF
	bl	_printf
	b	LBB0_5
LBB0_5:                                 ;   in Loop: Header=BB0_3 Depth=1
	ldr	x8, [sp, #48]
	add	x8, x8, #1
	str	x8, [sp, #48]
	b	LBB0_3
LBB0_6:
	adrp	x0, l_.str.3@PAGE
	add	x0, x0, l_.str.3@PAGEOFF
	bl	_printf
	str	wzr, [sp, #60]
	b	LBB0_7
LBB0_7:
	ldr	w8, [sp, #60]
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	ldur	x9, [x29, #-8]
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	subs	x8, x8, x9
	cset	w8, eq
	tbnz	w8, #0, LBB0_9
	b	LBB0_8
LBB0_8:
	bl	___stack_chk_fail
LBB0_9:
	ldr	w0, [sp, #20]                   ; 4-byte Folded Reload
	ldp	x29, x30, [sp, #160]            ; 16-byte Folded Reload
	add	sp, sp, #176
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"libsodium initialization failed\n"

l___const.main.message:                 ; @__const.main.message
	.asciz	"Hello, world!"

l_.str.1:                               ; @.str.1
	.asciz	"Encrypted message: "

l_.str.2:                               ; @.str.2
	.asciz	"%02x"

l_.str.3:                               ; @.str.3
	.asciz	"\n"

.subsections_via_symbols
