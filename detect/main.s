
;==============================================================================
;
; Detect
;
; Samuel Volk, March 2019
;
; Detects what system the cart is plugged into.
;
;==============================================================================

.INCLUDE "cgb_hardware.i"

.GBHEADER
    NAME "DETECT"
    CARTRIDGETYPE $00	    ; RAM only
    RAMSIZE $00		    ; 32KByte, no ROM banking
    COUNTRYCODE $01	    ; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    LICENSEECODEOLD $33
    ROMGBC		    ; gameboy color compatible rom
    ROMSGB		    ; SGB compatible rom
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
    MAP "0" TO "9" = $01
    MAP "A" TO "Z" = $01+11
    MAP " " = $8A
    MAP "@" = $00
.ENDA



;==============================================================================
; ZeroPage
;==============================================================================
.ENUM $FF8D
    System	DB	; 00 for DMG (original)
			; 01 for MGB (pocket)
			; 02 for CGB (color)
			; 03 for SGB (super)
			; 04 for SGB2 (super2)
.ENDE

;==============================================================================
; WRAM
;==============================================================================
.ENUM $C200
    TileMapBuff	DS	20*18
.ENDE

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
.ORG $28    ; Reset $28	- Copy Data routine
CopyData:
    pop hl  ; pop return address off stack
    push bc

    ; get number of bytes to copy
    ; hl contains the address of the bytes following the rst call
    ldi a, (hl)
    ld b, a
    ldi a, (hl)
    ld c, a

-   ldi a, (hl)	; start transfering data
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, -

    ; all done
    pop bc
    jp hl
    reti

.ORG $30    ; Reset $30
    ;jp $100	; is overwritten above
.ORG $38    ; Reset $38
    ;jp $100	; is overwritten above
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
.SECTION "Subroutines" FREE

MLT_REQ1P:
    .DB ($11 << 3) + 1
    .DS 15, $00
MLT_REQ2P:
    .DB ($11 << 3) + 1
    .DB $01
    .DS 14, $00
MLT_REQ4P:
    .DB ($11 << 3) + 1
    .DB $03
    .DS 14, $00

SGBSend:
    ; hl    SGB data to send (16 bytes long)
    ; RESET pulse
    xor a
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a
    ; send the rest of the data
    ld c, 16		; # of bytes to send 
--  ld e, 8		; counter for shifting
    ldi a, (hl)		; load byte to send
    ld b, a		; keep data to send safe in b
-   bit 0, b
    jr nz, @send1
@send0:
    ld a, $20
    jr +
@send1:
    ld a, $10
+   ldh (R_P1), a	; send data
    ld a, $30
    ldh (R_P1), a	; reset pins
    rr b
    dec e
    jr nz, -
    dec c
    jr nz, --
    ; stop bit
    ld a, $20
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a
    ret

DetectSystem:
    ldh ($8D), a	; save startup value in accumulator
    ld a, $30
    ldh (R_P1), a	; reset joypad selector pins for test

    ;MLT_REQ test
    ld hl, MLT_REQ2P
    call SGBSend
    ld a, $30
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    ld b, a
    ld a, $20
    ldh (R_P1), a
    ld a, $10
    ldh (R_P1), a
    ld a, $30
    ldh (R_P1), a
    ldh a, (R_P1)
    ldh a, (R_P1)
    ldh a, (R_P1)
    cp b
    jr nz, @IsSGB

@NotSGB:
    ldh a, ($8D)
    cp $01
    jr z, @DMG
    cp $FF
    jr z, @MGB
    jr @CGB
@IsSGB:
    ld hl, MLT_REQ1P
    call SGBSend
    ldh a, ($8D)
    cp $01
    jr z, @SGB
    jr @SGB2


@DMG:
    xor a
    jr @end
@MGB:
    ld a, $01
    jr @end
@CGB:
    ld a, $02
    jr @end
@SGB:
    ld a, $03
    jr @end
@SGB2:
    ld a, $04
@end:
    ldh ($8D), a
    ret

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
    ret

BlankWRAM:
    ld hl, $C000    ; WRAM
    ld bc, $2000    ; counter
-   ld a, 0
    ldi (hl), a
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

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
    ld hl, Map
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

UpdateMap:
    ld hl, TileMapBuff
    ld de, $9800
    ld c, $12
--  ld b, $14
-   ldi a, (hl)
    ld (de), a
    inc de
    dec b
    jp nz, -
    ld a, 12
    add e
    ld e, a
    ld a, 0
    adc d
    ld d, a
    dec c
    jp nz, --
    ret

ScreenOn:
    ldh a, (R_LCDC)
    or %10000000
    ldh (R_LCDC), a
    ret

ScreenOff:
    ld a, 0
    ldh (R_LCDC), a
    ret

DMACopy:
    ; https://exez.in/gameboy-dma
    ld de, $FF80    ; destination of HRAM for DMA routine
    rst $28
    .DB $00, $0D    ; assembled DMA subroutine length
		    ; then assembled DMA subroutine
    .DB $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
    ret

PrintStr:
    ; Prints $00 terminated string to VRAM tile map.
    ; hl    source of string ending in $00
    ; de    tile destination (somewhere in VRAM tilemap probably)
-   ldi a, (hl)
    cp 0
    ret z
    ld (de), a
    inc de
    jp -

.ENDS


;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE	; setup stack

    call DetectSystem


    ; wait for vblank
-   ld a, (LY)
    cp $91
    jr nz, -
    ; turn screen off
    call ScreenOff

    ; no sound needed
    xor a
    ldh (R_NR52), a

    call BlankWRAM
    call BlankOAM
    call BlankSprites
    call LoadTiles

    call BlankMap
    ;call LoadMap

    ; load palette
    ld a, %11100100	; bg
    ldh (R_BGP), a
    ld a, %00011011	; obj
    ldh (R_OBP0), a

    ; CGB Palette
    ld a, $80
    ldh (R_BCPS), a
    ld hl, PaletteDMG
    ld c, 8
-   ldi a, (hl)
    ldh (R_BCPD), a
    dec c
    jr nz, -

    call DMACopy ; set up DMA subroutine

    ; setup screen
    ld a, %00010001
    ldh (R_LCDC), a

    ; enable vblank interrupt
    ld a, $01		; just vblank interrupt
    ldh (R_IE), a

    ldh a, ($8D)	; system value
    cp $00
    jr z, DMGtext
    cp $01
    jr z, MGBtext
    cp $02
    jr z, CGBtext
    cp $03
    jr z, SGBtext
    cp $04
    jr z, SGB2text

DMGtext:
    ld hl, TextGB
    jr +
MGBtext:
    ld hl, TextGBP
    jr +
CGBtext:
    ld hl, TextGBC
    jr +
SGBtext:
    ld hl, TextSGB
    jr +
SGB2text:
    ld hl, TextSGB2

+   ld de, TileMapBuff
    call PrintStr

    call UpdateMap

    call ScreenOn
    ei

MainLoop:
    halt
    nop
    call $FF80		; DMA routine in HRAM

    jp MainLoop


;==============================================================================
; DATA
;==============================================================================
.SECTION "Palettes" FREE
PaletteDMG:
.DW $24A6
.DW $4609
.DW $2B72
.DW $77DC
.ENDS


.SECTION "Tiles" FREE
Tiles:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.INCBIN "numbers.bin"	FSIZE sizeofnums
.INCBIN "alphas.bin"	FSIZE sizeofalphas
.ENDS
.DEFINE TileCount   sizeofnums+sizeofalphas

.SECTION "Text" FREE
TextGB:
.ASC "GAMEBOY@"
TextGBC:
.ASC "GAMEBOY COLOR@"
TextGBP:
.ASC "GAMEBOY POCKET@"
TextSGB:
.ASC "SUPER GAMEBOY@"
TextSGB2:
.ASC "SUPER GAMEBOY 2@"
.ENDS

.SECTION "Map" FREE
Map:
.DB $00
.ENDS

; vim: filetype=wla
