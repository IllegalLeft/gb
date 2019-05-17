.INCLUDE "header.i"
.INCLUDE "hram.i"

.SECTION "GraphicsRoutines" FREE
DMACopy:
    ; https://exez.in/gameboy-dma
    ld de, DMARoutine   ; destination of HRAM for DMA routine
    rst $28
    .DB $00, $0D        ; assembled DMA subroutine length
                        ; then assembled DMA subroutine
    .DB $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
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

;vim: set filetype=wla
