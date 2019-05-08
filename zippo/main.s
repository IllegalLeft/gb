.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "hram.i"

.DEFINE OAM_Buffer $C100

.BANK 0
.ORG $150
Start:
    di
    ld sp, $FFFE
    
    ld a, $01
    ldh (R_IE), a	    ; vblank enabled

    xor a		    ; turn off screen
    ldh (R_LCDC), a
    ldh (R_NR52), a	    ; turn off sound

    xor a
    ld hl, $C000
    ld bc, $2000
    call BlankData	    ; blank RAM
    ld hl, $8000
    ld bc, $2000
    call BlankData	    ; blank VRAM

    call DMACopy	    ; setup DMA Routine
    call DMARoutine

    ld hl, invbg_tile_data  ; load tiles
    ld de, $8000
    ld bc, invbg_tile_data_size
    call MoveData

    ld hl, font_tombi_tile_data
    ld de, $8500
    ld bc, font_tombi_tile_data_size
    call MoveData

    ld hl, invbg_map_data
    call LoadScreen

    ld hl, Text_Items
    ld de, $9863
    call PrintStr

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
