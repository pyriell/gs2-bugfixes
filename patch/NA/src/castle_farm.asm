; Suikoden II Castle Farm Fix 
; Written by Pyriel
;
; This is an attempt to correct the issue with the castle farm.
; Handing in two or more of a single seed or animal type will 
; only cause one more to be displayed when you return later.

.psx
.align 4

; all the $s registers are pretty much fair game.
; Using $v1 for address (already loaded).

.openfile VK19.BIN, 0x8015DC50
.headersize 0
.org 0x8015E198
; file location will be 0x540

; start with cabbage.
cabbage:
	lbu v0, 0x1A2B(v1)				; cabbage count
	lw s4, 0x191C(v1)				; flags (seeds and stock)
	li s6, 7					; mask base
	li s5, 3					; max count  (this will keep)
	subu v0, s5, v0					; shift amount
	srlv v0, s6, v0					; 0x7 >> (3 - cabbage count)
	or s4, s4, v0					; flags |= mask
potato:
	lbu v0, 0x1A2C(v1)				; count
	li s6, 7					; load delay
	subu v0, s5, v0
	srlv v0, s6, v0
	sll v0, v0, 3					; finish mask
	or s4, s4, v0

spinach:
	lbu v0, 0x1A2D(v1)				; count
	li s6, 7					; load delay
	subu v0, s5, v0
	srlv v0, s6, v0
	sll v0, v0, 6					; finish mask
	or s4, s4, v0
tomato:
	lbu v0, 0x1A2E(v1)				; count
	li s6, 7					; load delay
	subu v0, s5, v0
	srlv v0, s6, v0
	sll v0, v0, 9					; finish mask
	or s4, s4, v0
store:
	sw s4, 0x191C(v1)
	beq zero, zero, 0x8015E2EC			; skip the rest
	nop
.close

.openfile VK19.BIN, 0x8015DC50
.headersize 0
.org 0x8015DE40
; file location will be 0x1F0
chick:
	lbu v0, 0x1A2F(v1)				; chick count
	lw s4, 0x191C(v1)				; flags (seeds and stock)
	li s6, 7					; mask base
	li s5, 3					; max count  (this will keep)
	subu v0, s5, v0					; shift amount
	srlv v0, s6, v0					; 0x7 >> (3 - chick count)
	sll v0, v0, 12					; finish mask
	or s4, s4, v0					; flags |= mask
pig:
	lbu v0, 0x1A30(v1)				; count
	li s6, 7					; load delay
	subu v0, s5, v0
	srlv v0, s6, v0
	sll v0, v0, 15					; finish mask
	or s4, s4, v0
sheep:
	lbu v0, 0x1A31(v1)				; count
	li s6, 0xF					; mask base (can have 4 sheep)
	li s3, 4					; max count
	subu v0, s3, v0					; shift amount
	srlv v0, s6, v0					; 0xF >> (4 - sheep count)
	sll v0, v0, 18					; finish mask
	or s4, s4, v0
calf:
	lbu v0, 0x1A32(v1)				; count
	li s6, 7					; mask base (back to 3)
	subu v0, s5, v0
	srlv v0, s6, v0
	sll v0, v0, 22					; finish mask
	or s4, s4, v0
store2:
	sw s4, 0x191C(v1)
	beq zero, zero, 0x8015DFB0			; skip the rest
	nop
.close