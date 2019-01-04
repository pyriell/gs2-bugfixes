; Suikoden II Gregminster Recruiting Crash
; Written by Pyriel
;
; Fixes an issue with the translation that causes a crash during the meeting with Lepant in Gregminster.
; Two of the three options were extended to a second line in the German text, pushing the choices beyond
; the size allowed by the game.  When the last option is selected, it returns an option number
; not allowed by the script, resulting in a crash when no scripting is found to handle the player's
; choice.
;
; Changing the last newline character in the strings to a space fixes the issue, and the text
; has plenty of space left before it would overflow the right margin of the box.
;

.psx
.openfile VF04.BIN, 0x8015DC50
.align 4

.org 0x80168115
.byte 0x10

.org 0x8016813D
.byte 0x10


.close
