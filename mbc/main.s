;==============================================================================
;
; mbc
;
; Samuel Volk, May 2019
;
; Just me fooling with memory bank controller stuff. Hopefully this gives
; some insight on how to do master boot controller related stuff. Just MBC1
; with four banks of ROM.
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"


.DEFINE OAMBuffer   $C100
.DEFINE DMARoutine  $FF80

;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
.SECTION "Subroutines" FREE
DMARoutineOriginal:
    ld a, >OAMBuffer
    ldh (R_DMA), a
    ld a, $28		; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

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
    ; hl    source
    ; de    destination
    ; bc    length/size
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

.SECTION "BankRoutines" FREE
BankMode:
    ; a	    bank mode - $00 ROM, $01 RAM
    ld hl, $6000
    ld (hl), a
    ret

RAMEnable:
    ; a	    enable/disable
    ld hl, $0000
    ld (hl), a
    ret

SwitchBank:
    ; a	    new bank
    ld hl, $2000
    ld (hl), a
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
    call MoveData	    ; move DMA Routine into HRAM
    call DMARoutine

    ld a, $03
    call SwitchBank	    ; switch to bank 3

    ld hl, turt_tile_data
    ld de, $8000
    ld bc, turt_tile_data_size
    call MoveData	    ; load tile data

    ld hl, turt_map_data
    call LoadScreen	    ; load tile map data

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
