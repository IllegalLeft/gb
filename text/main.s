
;==============================================================================
;
; TEXT
;
; Samuel Volk, July 2018
;
; Displays some text.
;
;==============================================================================

.INCLUDE "gb_hardware.i"

.GBHEADER
    NAME "TEXT"
    CARTRIDGETYPE $00 ; RAM only
    RAMSIZE $00 ; 32KByte, no ROM banking
    COUNTRYCODE $01 ; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    ROMDMG  ; DMG rom
.ENDGB


.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

.ASCIITABLE
    MAP "A" TO "Z" = 1
    MAP ' ' = 0
.ENDA


.DEFINE OAMBuffer   $C100
.DEFINE DMARoutine  $FF80

;==============================================================================
; GAMEBOY HEADER
;==============================================================================
.BANK 0
.ORG $00    ; Reset $00
    jp $100
.ORG $08    ; Reset $08
    jp $100
.ORG $10    ; Reset $10
    jp $100
.ORG $18    ; Reset $18
    jp $100
.ORG $20    ; Reset $20
    jp $100
.ORG $28    ; Reset $28
    jp $100
.ORG $30    ; Reset $30
    jp $100
.ORG $38    ; Reset $38
    jp $100
.ORG $40    ; Vblank IRQ Vector
    reti
.ORG $48    ; LCD IRQ Vector
    reti
.ORG $50    ; Timer IRQ Vector
    reti
.ORG $58    ; Serial IRQ Vector
    reti
.ORG $60    ; Joypad IRQ Vector
    reti

.ORG $100   ; Code Execution Start
    nop
    jp Start


;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
.ORGA $3000

; Init Subroutines
BlankSprites:
    ld hl, $8000
    ld bc, 4080
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

BlankOAM:
    ld hl, $C100
    ld bc, 160	; entries
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -

BlankWRAM:
    ld hl, $C000    ; WRAM
    ld bc, $2000    ; counter
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -

LoadTiles:
    ld hl, Tiles
    ld de, $8000
    ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
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

BlankMap:
    ld hl, $9800
    ld bc, 1024
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

LoadMap:
    ld hl, Tiles
    ld de, $9800
    ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

ScreenOn:
    ldh a, ($40)
    or %01000000
    ldh ($40), a
    ret

ScreenOff:
    ld a, 0
    ldh ($40), a
    ret

DMARoutineOriginal:
    ld a, >OAMBuffer
    ldh (R_DMA), a
    ld a, $28		    ; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

WaitVBlank:
    ld a, ($FF44)
    cp $91
    jr nz, WaitVBlank
    ret

;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE    ; setup stack

    ; wait for vblank
    call WaitVBlank
    ; turn screen off
    call ScreenOff

    ; no sound needed
    xor a
    ldh ($26), a

    call BlankWRAM
    call BlankSprites
    call BlankMap

    call LoadTiles
    ;call LoadMap

    ; load palette
    ld a, %11100100	; bg
    ldh ($47), a
    ld a, %00011011	; obj
    ldh ($48), a

    ld hl, DMARoutineOriginal
    ld de, DMARoutine
    ld bc, _sizeof_DMARoutineOriginal
    call MoveData

    ; setup screen
    ld a, %10010011
    ldh ($40), a
    ei

    ; text
    call WaitVBlank
    ld de, $9800
    ld hl, Text
    ld bc, TextLen
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -


MainLoop:
    call WaitVBlank
    call $FF80 ; DMA routine in HRAM

    jp MainLoop


;==============================================================================
; DATA
;==============================================================================

.ORG $500
.DEFINE TextLen	    8
Text:
.ASC "ABBA CAB"

.DEFINE TileCount   5*16
Tiles:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $7C,$7C,$C6,$C6,$C6,$C6,$FE,$FE,$C6,$C6,$C6,$C6,$C6,$C6,$00,$00
.DB $FC,$FC,$C6,$C6,$C6,$C6,$FE,$FE,$C6,$C6,$C6,$C6,$FC,$FC,$00,$00
.DB $7C,$7C,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$7C,$7C,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; vim: filetype=wla
