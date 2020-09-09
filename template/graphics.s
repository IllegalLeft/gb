;==============================================================================
; Graphics
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"

.DEFINE OAMBuffer   $C100

.SECTION "Graphics" FREE

DMARoutineOriginal:
    ld a, >OAMBuffer
    ldh (R_DMA), a
    ld a, $28			; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

;.INCLUDE "graphic.i"

.ENDS

; vim: filetype=wla
