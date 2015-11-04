; Suikoden II Suikoden I Load Tai Ho Bonuses
; Written by Pyriel
;
; For whatever reason, Vincent, who is not a party character in Suikoden
; receives bonuses when a Suikoden file is loaded, while Tai Ho who is
; playable in both games receives nothing.
;
; Patch swaps Vincent for Tai Ho and defaults his level to 27.

.psx
.align 4

.openfile G1LOAD.BIN, 0x8010DC50
.headersize 0
.org 0x80115AEC
.area 0x80115B20-.

;Array of struct (byte s1_id, byte s2_id, byte default_level)
.byte 0x2	;Flik (s2 id)
.byte 0x11  ;Flik (s1 id)
.byte 0x14  ;Flik Default Level
.byte 0x3	;Viktor
.byte 0x23
.byte 0x14
.byte 0x5	;Sheena
.byte 0x3E
.byte 0x26
.byte    6	;Clive
.byte 0x35
.byte 0x10
.byte    7	;Hix
.byte 0x3F
.byte 0x1B
.byte    8	;Tengaar
.byte 0x21
.byte 0x1B
.byte    9	;Futch
.byte 0x13
.byte 0x22
.byte  0xA	;Humphrey
.byte 0x15
.byte 0x22
.byte  0xC	;Valeria
.byte 0x24
.byte 0x26
.byte  0xD	;Pesmerga
.byte 0x6B
.byte 0x32
.byte  0xE	;Lorelai
.byte 0x2F
.byte 0x26
.byte 0x26	;Tai Ho
.byte 0x20
.byte 0x1B
.byte 0x29	;Meg
.byte 0x4C
.byte 0x1F
.byte 0x35	;Luc
.byte 0x1A
.byte 0x1B
.byte 0x43	;Stallion
.byte 0x4B
.byte 0x1F
.byte 0x49	;Kasumi
.byte 0x17
.byte 0x26
.byte 0x52	;McDohl
.byte    8
.byte 0x26

.endarea
.close