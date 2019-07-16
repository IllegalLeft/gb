;==============================================================================
; Graphics
;==============================================================================

.INCLUDE "header.i"

.BANK 0 SLOT 0
.SECTION "GraphicsRoutines" FREE
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
.ENDS

.BANK 3 SLOT 1
.ORG $0000
.SECTION "Graphics" FREE

.INCLUDE "turt.i"

.ENDS

; vim: filetype=wla
