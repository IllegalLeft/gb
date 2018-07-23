;==============================================================================
;
; SPRITE
;
; Samuel Volk, September 2016
;
; It will just draw a sprite on the screen (hopefully)
;
;==============================================================================

.ROMBANKSIZE $4000
.ROMBANKS 2
.CARTRIDGETYPE 0

.COMPUTEGBCHECKSUM
.COMPUTEGBCOMPLEMENTCHECK

.MEMORYMAP
DEFAULTSLOT 0
SLOTSIZE $4000
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.INCLUDE "nintendo_logo.i"

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
;.ORG $104   ; Nintendo Logo
;   .DB $CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
;   .DB $00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
;   .DB $BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E
.ORG $134   ; Game Title
    .DB "SAM SPRITE"
.ORG $13F   ; Product code
    .DB "    "
.ORG $143   ; Color Gameboy compatibility code
    .DB $01
.ORG $144   ; Licence code
    .DB $00,$00

.ORG $146   ; Gameboy indicator
    .DB $00 ; $00 - GameBoy
.ORG $147   ; Cartridge type
    .DB $00 ; $00 - ROM Only
.ORG $148   ; ROM Size
    .DB $00
.ORG $149   ; RAM Size
    .DB $00 ; $00 - None

.ORG $14A   ; Destination code
    .DB $01 ; $01 - non-japanese
.ORG $14B
    .DB $33 ; $33 - Check $0144/$0145 for Licensee code.

; $014C (Mask ROM version - handled by RGBFIX)
.ORG $14C
    .DB $00

; $014D (Complement check - handled by RGBFIX)
;.ORG $14D
;   .DB $00

; $014E-$014F (Cartridge checksum - handled by RGBFIX)
;   .DW $00


;==============================================================================
; CODE
;==============================================================================

; OAM BLOCK:
; byte0 - Ypos
; byte1 - Xpos
; byte2 - Pattern #
; byte3 - Flags:
;           bit7 - priority
;           bit6 - Yflip
;           bit5 - Xflip
;           bit4 - Palette#
;

.ORG $150
Start:
    di
    ld sp, $FFFE        ; setup stack
    call SCREEN_OFF

    call BlankSprites

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
    ei

GameLoop:
    ;halt ; TODO: this doesn't seem to help anything
    nop

    call ReadDpad
    call HandleInput

    call WaitVBlank

    jp GameLoop


;==============================================================================
; SUBROUTINES
;==============================================================================

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
