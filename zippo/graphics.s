.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "hram.i"

.SECTION "GraphicsRoutines" FREE
DMARoutineOriginal:
    ld a, >OAM_Buffer
    ldh (R_DMA), a
    ld a, $28	    ; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

LoadScreen:
    ; hl    map source
    ld de, $9800
    ld c, $12
--  ld b, $14
-   ldi a, (hl)
    ld (de), a
    inc de
    dec b
    jr nz, -
    ld a, 12
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    dec c
    jr nz, --
    ret

PrintStr:
    ; Prints $00 terminated string to VRAM tilemap.
    ; hl    source of string
    ; de    destination address
-   ldi a, (hl)
    cp 0
    ret z
    ld (de), a
    inc de
    jr -
    ret		; just in case problems

.ENDS


.SECTION "GraphicsData" FREE

.INCLUDE "invbg.i"
.INCLUDE "font_tombi.i"
.INCLUDE "items.i"

.ENDS

; vim: filetype=wla
