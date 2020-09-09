;==============================================================================
; Graphics
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "hram.i"


.BANK 0
.SECTION "Graphics" FREE

DMARoutineOriginal:
    ld a, >OAMBuffer
    ldh (R_DMA), a
    ld a, $28       ; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

ScreenOn:
    ldh a, (R_LCDC)
    or %01000000
    ldh (R_LCDC), a
    ret

ScreenOff:
    ld a, 0
    ldh (R_LCDC), a
    ret

LoadScreen:
    ; hl    source
    ld de, $9800
    ld c, $16       ; height
--  ld b, $14	    ; width
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

DrawMapLine:
    ; draws line of the map given the vram start addr and map line
    ; hl    map addr
    ; de    first tile address 
    ret

DrawScreen:
    ; draws screen extending up and down a 4 rows
    ; used initially when viewing the tapestry

.ENDS

; vim: filetype=wla
