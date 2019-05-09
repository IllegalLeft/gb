.INCLUDE "header.i"

.SECTION "Memory" FREE
BlankData:
    ; a     value
    ; hl    destination
    ; bc    length/size
    ld d, a             ; will need later
-   ldi (hl), a
    dec bc
    ld a, b
    or c
    ld a, d
    jr nz, -
    ret


MoveData:
    ; hl    source
    ; de    destination
    ; bc    length/size
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, -
    ret

.ENDS

; vim: filetype=wla
