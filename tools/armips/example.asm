 ; Final Fantasy 7 Spirit Fix written by Gemini
 ; This file serves as a simple example for how to
 ; use assembler for changing code


.psx					; Set the architecture to PSX
.open "SLPS_010.57",0x8000F800		; Open SLPS_010.57 for output.
					; 0x8000F800 will be used as the
					; header size

.org 0x800104C4				; Some new code

spirit_fix:

        sll     v0, a3, 2
        addu    v0, a0
        lw      v1, 0(v0)
        nop
        sll     v0, v1, 5
        addu    v0, v1
        sll     v0, 2
        la      at, 0x8009BDA5
        addu    at, v0
        lbu     v1, 0(at)
        nop
        sll     v0, v1, 3
        addu    v0, v1
        sll     v0, 2
        la      at, 0x80071CAF
        addu    at, v0
        lbu     a2, 0(at)
        j       0x8001FC94
        move    v0, a2

.org 0x8001FBD0				; here, a branch to the new code is
					; added

        beq     a1, v0, spirit_fix


					; the rest of the file will remain
					; unchanged			

.close

 ; make sure to leave an empty line at the end
