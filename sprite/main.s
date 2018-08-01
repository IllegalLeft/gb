;==============================================================================
;
; SPRITE
;
; Samuel Volk, September 2016
;
; It will just draw a sprite on the screen (hopefully)
;
;==============================================================================

.GBHEADER
    NAME "SAM SPRITE"
    CARTRIDGETYPE $00	; RAM only
    RAMSIZE $00		; 32KByte, no ROM banking
    COUNTRYCODE $01	; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    ROMDMG		; DMG rom
.ENDGB

.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2


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
; CODE
;==============================================================================

.ORG $150
Start:
    di
    ld sp, $FFFE        ; setup stack

    ;ld a, 0
    ;ldh ($26), 0    ; sound off

    call ScreenOff
    call BlankSprites
    call BlankOAM

    ; OBJ0 Palette
    ld a, %11100100
    ldh ($48), a

    ; load OAM for sprite
    ld a, 16
    ld ($FE00), a
    ld a, 8
    ld ($FE01), a
    ld a, $00
    ld ($FE02), a
    ld a, $00
    ld ($FE03), a

    ; load sprite data
    call LoadSprites

    ; Setup screen
    ld a, %10000010
    ldh ($40), a    ; $FF40 LCDC status
    
    ; set interrupts up
    ld a, %00000001 ; vblank
    ldh ($FF), a
    ei

GameLoop:
    halt
    nop

    call ReadDpad
    call HandleInput

    call WaitVBlank

    jp GameLoop


;==============================================================================
; SUBROUTINES
;==============================================================================

ScreenOff:
    ld a, 0
    ldh ($40), a
    ret

ReadDpad:
    ld a, $20       ; select P14
    ld ($FF00), a
    ld a, ($FF00)   ; read pad
    ld a, ($FF00)   ; a bunch of times
    ld a, ($FF00)
    cpl             ; active low so flip dat sucka
    and $0f         ; only need last 4 bits
    ld ($FF80), a   ; store into 0page for later use

    ld a, $30       ; reset joypad
    ld ($FF00), a
    ret

; $01 right
; $02 left
; $04 up
; $08 down
HandleInput:
    ; move sprite based on dpad
    ld a, ($FF80)   ; load data
    ld b, a
    ; right
    and $01
    jp z, NoRight
    ld a, ($FE01)   ; move right
    adc $01
    ld ($FE01), a
NoRight:
    ld a, b
    ; left
    and $02
    jp z, NoLeft
    ld a, ($FE01)
    sbc $01
    ld ($FE01), a
NoLeft:
    ld a, b
    ; up
    and $04
    jp z, NoUp
    ld a, ($FE00)
    sbc $01
    ld ($FE00), a
NoUp:
    ld a, b
    ; down
    and $08
    jp z, NoDown
    ld a, ($FE00)
    adc $01
    ld ($FE00), a
NoDown:
    ret

WaitVBlank:
    ld a, ($FF44)
    cp $91
    jr nz, WaitVBlank
    ret


BlankSprites:
    ld hl, $8000
    ld bc, 4080
BlankSpritesLoop:
    ld a, 0         ; load data to blank with (0)
    ldi (hl), a     ; put in destination and increment destination
    dec bc          ; decrement counter
    ld a, b
    or c            ; a = b|c
    jp nz, BlankSpritesLoop ; if b|c != 0...
    ret


LoadSprites:
    ld hl, SpriteTiles  ; tile source address
    ld de, $8000        ; tile memory destination address
    ld bc, 16           ; counter
LoadSpritesLoop:
    ldi a, (hl)         ; get a byte from the tile
    ld (de), a          ; put byte into tilemem
    inc de              ; increment destination address
    dec bc              ; decrement counter
    ld a, b
    or c                ; a = b | c
    jp nz, LoadSpritesLoop  ; if b|c != 0...
    ret

BlankOAM
    ld hl, $FE00
    ld bc, 40*4
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -
    ret


;==============================================================================
; DATA
;==============================================================================
SpriteTiles:
SmileyTiles:
    .DB %01111110
    .DB %01111110
    .DB %11111111
    .DB %10000001
    .DB %11111111
    .DB %10100101
    .DB %11111111
    .DB %10100101
    .DB %11111111
    .DB %11000011
    .DB %11111111
    .DB %10111101
    .DB %11111111
    .DB %10000001
    .DB %01111110
    .DB %01111110
