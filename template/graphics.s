;==============================================================================
; Graphics
;==============================================================================

.INCLUDE "header.i"

.SECTION "Graphics" FREE

DMACopy:
    ; https://exez.in/gameboy-dma
    ld de, DMARoutine    ; destination of HRAM for DMA routine
    rst $28
    .DB $00, $0D    ; assembled DMA subroutine length
		    ; then assembled DMA subroutine
    .DB $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
    ret


;.INCLUDE "graphic.i"

.ENDS

; vim: filetype=wla
