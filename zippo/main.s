.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "hram.i"
.INCLUDE "wram.i"


.BANK 0
.ORG $150
Start:
    di
    ld sp, $FFFE
    
    ld a, $01
    ldh (R_IE), a	    ; vblank enabled

-   ld a, (LY)              ; wait for vblank
    cp $91
    jr nz, -
    xor a		    ; turn off screen
    ldh (R_LCDC), a
    ldh (R_NR52), a	    ; turn off sound

    ld hl, $C000
    ld bc, $2000
    call BlankData	    ; blank RAM
    ld hl, $8000
    ld bc, $2000
    call BlankData	    ; blank VRAM

    ld hl, DMARoutineOriginal
    ld de, DMARoutine
    ld bc, _sizeof_DMARoutineOriginal
    call MoveData
    call DMARoutine

    ld hl, invbg_tile_data  ; load tiles
    ld de, $8000
    ld bc, invbg_tile_data_size
    call MoveData

    ld hl, font_tombi_tile_data
    ld de, $8500
    ld bc, font_tombi_tile_data_size
    call MoveData

    ld hl, items_tile_data
    ld de, $8700
    ld bc, items_tile_data_size
    call MoveData

    ld hl, invbg_map_data
    call LoadScreen

    ; load test inventory
    ld hl, test_inv
    ld de, w_inv
    ld bc, 14 * 2 ;bytes
    call MoveData

    call Inv_DrawInv
    ;ld a, 0
    ;call Inv_DrawText

    ld a, %11100100
    ldh (R_BGP), a	    ; background palette

    ld a, %00011011
    ldh (R_OBP0), a	    ; sprite palette
    ldh (R_OBP1), a	    ; sprite palette

    ld a, %10010011	    ; turn on screen
    ldh (R_LCDC), a

    ei

Loop:
    halt
    nop
    call DMARoutine
    jr Loop


.SECTION "MiscData" FREE
test_inv:
.DB 1, 1
.DB 2, 3
.DB 3, 15
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 0, 0
.DB 3, 1
.DB 0, 0
.DB 0, 0
.ENDS

; vim: filetype=wla
