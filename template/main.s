;==============================================================================
;
; TEMPLATE
;
; Samuel Volk, July 2018
;
; Description
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"


.DEFINE DMARoutine  $FF80

;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
.SECTION "Subroutines" FREE
; Init Subroutines
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
    ;hl  source
    ;de  destination
    ;bc  length/size
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
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


.ENDS

;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE            ; setup stack

-   ld a, (LY)              ; wait vblank
    cp $91
    jr nz, -
    xor a
    ldh (R_LCDC), a         ; turn off screen
    ldh (R_NR52), a         ; turn off sound

    ;xor a
    ld hl, $C000
    ld bc, $2000
    call BlankData          ; blank WRAM
    ld hl, $8000
    ld bc, $2000
    call BlankData          ; blank VRAM

    ; load palette
    ld a, %11100100	    ; bg
    ldh (R_BGP), a
    ld a, %00011011	    ; obj
    ldh (R_OBP0), a

    ld hl, DMARoutineOriginal
    ld de, DMARoutine
    ld bc, _sizeof_DMARoutineOriginal
    call MoveData

    ld a, %10010011         ; setup screen
    ldh (R_LCDC), a

    ld a, $01 
    ldh (R_IE), a           ; enable vblank interrupt
    ei

MainLoop:
    halt
    nop
    call DMARoutine

    jp MainLoop


; vim: filetype=wla
