; Suikoden II Matilda Gate Fix
; Written by Pyriel
;
; Makes the Matilda Gate an immovable object.

.psx
.align 4

.openfile VI11.BIN, 0x8010DC50
.org 0x80112994

gate:
	.byte 0x03		; start object
	.byte 0x00
	.byte 0x04		
	.byte 0xFF		; properties 0xFF - immovable, 0x1 - pushable
	.byte 0x0C		; sprite
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x02
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x10		; x position (halfword)
	.byte 0x00
	.byte 0x33		; y postion  (halfword)
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x00
	.byte 0x00
.close
