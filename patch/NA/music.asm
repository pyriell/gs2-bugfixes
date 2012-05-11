; Suikoden II Music Fixes
; Written by Pyriel
;
; Fix the songs that fail to play because the master disc
; build was poor.

.psx
.align 4

.openfile SLUS_009.58, 0x8006A800

;War Theme 3
.org 0x800ECFAB
.byte 1
;War Theme 1
.org 0x800ECFB7
.byte 1
;Annallee Song
.org 0x800ECFE7
.byte 1
;Chant Song
.org 0x800ECFFF
.byte 1

.close