; Suikoden II Armor Effects Fix
; Written by Pyriel
;
; Rather than using the properties available in the armor struct and handling effects
; based on them, Konami opted for hard-coded searches when the effects are relevant.
; This means the armor data for effects and resistances are essentially documentary, and
; don't necessary reflect reality.
;
; A few searches were screwed up.  Notably, they seem to have given the Master Robe
; properties it wasn't meant to have.

.psx
.align 4

.openfile BP0_SEC.BIN, 0x8002B000
.headersize 0

; Fix the Repel Magic effect so it applies to the Robe of Mist
.org 0x800394E4
.area 0x800394E8-.
	li $a1, 0x1F
.endarea

; Fix the status affliction resistance so it applies to Earth Armor.
.org 0x8004CDD0
.area 0x8004CDD4-.
	li $a1, 0x20
.endarea
.close