
;==============================================================================
;
; RUN
;
; Samuel Volk, July 2018
;
; Culmination of sprite work and background scrolling to show an animal
; running.
;
;
;==============================================================================

.GBHEADER
    NAME "RUN"
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

; WRAM Variables
.DEFINE DogeX $C000
.DEFINE DogeY $C001
.DEFINE DogeFrame $C002
.DEFINE MapX $C004
.DEFINE MapY $C005
.DEFINE CloudY $C006
.DEFINE CloudX $C007
.DEFINE Cloud2Y $C008
.DEFINE Cloud2X $C009
.DEFINE GrassY $C00A
.DEFINE GrassX $C00B
.DEFINE Grass2Y $C00C
.DEFINE Grass2X $C00D
.DEFINE Grass3Y	$C00E
.DEFINE Grass3X	$C00F

; WRAM Addresses for specifc OAMs
.DEFINE Doge $C100
.DEFINE Cloud Doge+(16*4) 
.DEFINE Cloud2 Cloud+(4*4)
.DEFINE Grass Cloud2+(4*4)

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
    ld hl, Doge
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
    ld hl, bg_tile_data
    ld de, $8000
    ld bc, bg_tile_count
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
    ld hl, bg_map_data
    ld de, $9800
    ld bc, bg_tile_map_size
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

WaitVBlank:
    ld a, ($FF44)
    cp $91
    jr nz, WaitVBlank
    ret

DMACopy:
    ld de, $FF80    ; destination of HRAM for DMA routine
    rst $28
    .DB $00, $0D    ; assembled DMA subroutine length
		    ; then assembled DMA subroutine
    .DB $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
    ret


; Sprite Subroutines
InitDoge:   ; setup oam in wram for doge sprites
    xor a
    ld (DogeFrame), a
    ld a, 72
    ld (DogeX), a
    ld a, 90
    ld (DogeY), a
    ; tile numbers
    ld hl, Doge+2   ; first tile number of first sprite
    ld b, 16	    ; 16 sprites total
    ld c, $10	    ; tile starts at x and goes up from there
    ld de, 4
-   ld (hl), c
    add hl, de
    dec b
    inc c
    ld a, 0
    cp b
    jp nz, -
    ret


MoveDoge:   ; modifies doge OAM x & Ys 
    ; Y ordinates
    ld hl, Doge     ; OAM in WRAM
    ld b, 16	    ; total sprites to modify
    ld a, (DogeY)   ; starting Y
    ld c, a
    ld de, 4	    ; next entry is 4 bytes away
-   ld (hl), c
    add hl, de
    dec b
    ; if b = 12, c =+ 8
    ld a, 12
    cp b
    jp z, Change
    ; if b = 8, c =+ 8
    ld a, 8
    cp b
    jp z, Change
    ; if b = 4, c =+ 8
    ld a, 4
    cp b
    jp nz, noChange
Change:
    ld a, 8
    add c
    ld c, a
noChange:
    xor a
    cp b
    jp nz, -

    ; x ordinates
    ld hl, Doge+1   ; oam in wram
    ld b, 16	    ; total sprites to modify
    ld a, (DogeX)   ; starting x
    ld c, a
    ld de, 4	    ; next entry is 4 bytes away
-   ld (hl), c
    add hl, de
    dec b
    ld a, 8
    add c
    ld c, a
    ; if b = 12, c -= 24
    ld a, 12
    cp b
    jp z, ChangeX
    ; if b = 8, c -= 24
    ld a, 8
    cp b
    jp z, ChangeX
    ; if b = 4, c -= 24
    ld a, 4
    cp b
    jp nz, noChangeX
ChangeX:
    ld a, c
    ld c, 32
    sub c
    ld c, a
noChangeX:
    xor a
    or b
    jp nz, -
    ret

DogeAnim:
    ; figure out tile to start on
    ld a, (DogeFrame)	; frame should be 0-16
    inc a		; next frame
    and $0F		; keep frame within 0-16
    ld (DogeFrame), a	; put back for safe keeping
    and %1000
    jp z, frame1
frame0:
    ld hl, doge_map_data1
    jp +
frame1:
    ld hl, doge_map_data2

+   ; set tiles up
    ld de, Doge+2   ; tile # of first sprite
    ld bc, 16	    ; 16 sprites to modify
		    ; hl = start of tilemap memory
-   ldi a, (hl)
    add 16	    ; sprites for doge starts at #16...
    ld (de), a
    ld a, 4	; de+4
    add e	; ...
    ld e, a	; ...
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

InitClouds:
    ; set initial coordinates of clouds
    ld a, 8
    ld (CloudX), a
    ld a, 20
    ld (CloudY), a
    ld a, 40
    ld (Cloud2Y), a
    ld a, 160
    ld (Cloud2X), a

    ; set up tiles
    ; cloud 1
    ld bc, cloud_tile_count ; num of tiles
    ld de, Cloud+2	    ; cloud oam tile # in wram
    ld hl, cloud_map_data   ; map data
-   ldi a, (hl)
    add $30
    ld (de), a
    ld a, 4	; de+4
    add e	; ...
    ld e, a	; ...
    dec bc
    ld a, c
    or b
    jp nz, -

    ; cloud 2
    ld bc, cloud_tile_count ; num of tiles
    ld de, Cloud2+2	    ; cloud oam tile # in wram
    ld hl, cloud_map_data   ; map data
-   ldi a, (hl)
    add $30
    ld (de), a
    ld a, 4	; de+4
    add e	; ...
    ld e, a	; ...
    dec bc
    ld a, c
    or b
    jp nz, -

    ret

MoveCloud:
    ; hl = cloudX
    ld a, (DogeFrame)
    and %0001
    jp z, +
    ld a, (hl)
    dec a
    ld (hl), a
+   ret

UpdateCloud:
    ; move sprites for the cloud based off of the coordinates
    push de
    push hl
    ld a, (de)
    ; y ordinate
    ;ld hl, Cloud    ; cloud oam in wram
    ld de, 4	    ; y ordinates are 4 away from eachother
    ;ld a, (CloudY)  ; starting y ordinate
    ld c, a
    ld (hl), c	    ; first sprite
    add hl, de
    ld (hl), c	    ; second sprite
    add hl, de
    ld a, 8
    add c
    ld c, a
    ld (hl), c	    ; third sprite
    add hl, de
    ld (hl), c	    ; fourth

    ; x ordinate
    pop hl
    pop de
    inc hl	; x is +1 from y ordinate in oam
    inc de	; x ord is +1 from y
    ld a, (de)
    ;ld hl, Cloud+1  ; cloud oam in wram
    ld de, 4	    ; x ordinates are 4 away from eachother
    ;ld a, (CloudX)  ; starting x ordinate
    ld c, a
    ld (hl), c	    ; first sprite
    add hl, de
    ld a, 8
    add c
    ld c, a
    ld (hl), c	    ; second sprite
    add hl, de
    ld a, c
    ld c, 8
    sub c
    ld c, a
    ld (hl), c	    ; third sprite
    add hl, de
    ld a, 8
    add c
    ld c, a
    ld (hl), c	    ; fourth
    ret
    
InitGrass:
    ; set initial coordinates
    ; grass1
    xor a
    ld (GrassX), a
    ld a, 133
    ld (GrassY), a
    ; grass2
    ld a, 200
    ld (Grass2X), a
    ld a, 110
    ld (Grass2Y), a
    ; grass3
    ld a, 100
    ld (Grass3X), a
    ld a, 140
    ld (Grass3Y), a

    ; set up OAM tile numbers
    ld hl, Grass+2  ; start of wram oam tile numbers
    ld c, 3	    ; how many grasses
    ld de, 4	    ; every 4th tile
-   ld a, $34	    ; tile number
    ld (hl), a
    add hl, de
    dec c
    xor a
    cp c
    jp nz, -
    ret
    

MoveGrass:
    ld b, 2 ; grass moves 2 per frame
    ; grass 1
    ld a, (GrassX)
    sub b
    ld (GrassX), a
    ; grass 2
    ld a, (Grass2X)
    sub b
    ld (Grass2X), a
    ; grass 3
    ld a, (Grass3X)
    sub b
    ld (Grass3X), a
    ret


UpdateGrass:
    ; Y Ordinate
    ld hl, GrassY   ; start of grass Ys
    ld c, 3	    ; 3 grasses
    ld de, Grass+0  ; grass OAM in WRAM
-   ldi a, (hl)
    ld (de), a
    inc hl	    ; next grass y is +2 from first one
    ld a, 4
    add e
    ld e, a
    dec c
    xor a
    cp c
    jp nz, -

    ; X ordinate
    ld hl, GrassX   ; start of grass Xs
    ld c, 3	    ; 3 grasses
    ld de, Grass+1  ; grass OAM in WRAM
-   ldi a, (hl)
    ld (de), a
    inc hl	    ; next grass x is +2 from first one
    ld a, 4
    add e
    ld e, a
    dec c
    xor a
    cp c
    jp nz, -
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
    call BlankOAM
    call BlankSprites
    call LoadTiles

    ; load dog tiles
    ld hl, doge_tile_data
    ld de, $8100
    ld bc, doge_tile_data_size
    call MoveData

    ; load cloud data
    ld hl, cloud_tile_data
    ld de, $8300
    ld bc, cloud_tile_data_size
    call MoveData

    ;grass data
    ld hl, grass_tile_data
    ld de, $8340
    ld bc, $10
    call MoveData

    call BlankMap
    call LoadMap

    ; load palette
    ld a, %11100100	; bg
    ldh ($47), a
    ld a, %00011011	; obj
    ldh ($48), a

    call DMACopy ; set up DMA subroutine

    ; doge
    call InitDoge
    call MoveDoge

    ; clouds
    call InitClouds
    ld hl, CloudX
    call MoveCloud
    ld hl, Cloud2X
    call MoveCloud
    ld hl, Cloud
    ld de, CloudY
    call UpdateCloud
    ld hl, Cloud2
    ld de, Cloud2Y
    call UpdateCloud

    ; grass
    call InitGrass
    call MoveGrass
    call UpdateGrass
    
    ; setup screen
    ld a, %10010011
    ldh ($40), a
    ei

MainLoop:
    call WaitVBlank
    call $FF80 ; DMA routine in HRAM

    ; move map
    ldh a, ($43)
    inc a
    ldh ($43), a

    ld hl, CloudX
    call MoveCloud
    ld hl, Cloud2X
    call MoveCloud
    ld hl, Cloud
    ld de, CloudY
    call UpdateCloud
    ld hl, Cloud2
    ld de, Cloud2Y
    call UpdateCloud

    call MoveGrass
    call UpdateGrass

    call DogeAnim

    jp MainLoop


;==============================================================================
; DATA
;==============================================================================

.ORG $500
; Doge
.DEFINE doge_tile_map_size $20
.DEFINE doge_tile_map_width $04
.DEFINE doge_tile_map_height $08

.DEFINE doge_tile_data_size $0170
.DEFINE doge_tile_count $20

doge_map_data:
doge_map_data1:
.DB $00,$00,$01,$00,$00,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$00
doge_map_data2:
.DB $00,$00,$00,$00,$00,$0C,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$16

doge_tile_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$00
.DB $01,$00,$03,$01,$07,$03,$0F,$06,$1E,$0D,$0F,$10,$00,$00,$00,$00
.DB $FE,$C0,$FF,$FE,$FF,$7F,$7F,$FC,$FF,$FB,$7F,$FF,$FF,$7F,$BF,$7F
.DB $00,$00,$80,$00,$C0,$80,$FF,$C0,$F9,$FE,$F9,$FE,$FA,$FC,$7C,$80
.DB $00,$00,$00,$00,$01,$00,$02,$01,$07,$03,$0F,$07,$0D,$07,$1B,$0F
.DB $00,$00,$00,$00,$FF,$00,$70,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF
.DB $73,$3C,$7E,$3C,$BE,$7C,$FC,$FE,$FF,$FE,$FB,$FE,$FB,$FE,$FA,$FC
.DB $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $1F,$0B,$9D,$0B,$FE,$99,$F9,$70,$70,$00,$00,$00,$00,$00,$00,$00
.DB $CF,$FF,$F7,$FF,$FF,$F0,$FC,$F8,$BD,$78,$74,$38,$34,$18,$1E,$0C
.DB $DA,$FC,$D2,$FC,$F4,$18,$F4,$18,$F8,$F0,$F8,$20,$E0,$40,$40,$00
.DB $00,$00,$0F,$00,$17,$0F,$05,$02,$02,$01,$01,$00,$01,$00,$00,$00
.DB $00,$00,$C0,$00,$BF,$C0,$F7,$FF,$FF,$7F,$FF,$38,$7F,$FF,$FF,$7F
.DB $00,$00,$00,$00,$00,$00,$80,$00,$C0,$80,$FF,$C0,$F9,$FE,$F9,$FE
.DB $00,$00,$01,$00,$02,$01,$07,$03,$0F,$07,$0D,$07,$9B,$0F,$FB,$8F
.DB $00,$00,$FF,$00,$71,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF,$CF
.DB $7F,$FF,$67,$FF,$F7,$F8,$FF,$FE,$F7,$FE,$F6,$FF,$F7,$FB,$FF,$F9
.DB $FA,$FC,$38,$C0,$C0,$00,$00,$00,$00,$00,$80,$00,$40,$80,$A0,$C0
.DB $FF,$73,$75,$03,$07,$07,$1F,$0F,$3B,$1C,$EC,$70,$F0,$00,$00,$00
.DB $EF,$C7,$C7,$80,$C0,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $DE,$FC,$F5,$0E,$07,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $D0,$60,$78,$20,$BC,$18,$D4,$88,$C8,$60,$40,$20,$00,$00,$00,$00

; Background
.DEFINE bg_tile_map_size $0400
.DEFINE bg_tile_map_width $20
.DEFINE bg_tile_map_height $20

.DEFINE bg_tile_data_size $D0
.DEFINE bg_tile_count $0168

bg_map_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02
.DB $01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02,$01,$02
.DB $03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04
.DB $03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04,$03,$04
.DB $05,$06,$07,$08,$09,$06,$07,$08,$09,$06,$07,$08,$09,$06,$07,$08
.DB $05,$06,$07,$08,$09,$06,$07,$08,$09,$06,$07,$08,$09,$06,$07,$08
.DB $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
.DB $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
.DB $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
.DB $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

bg_tile_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $FF,$00,$B3,$00,$08,$00,$02,$00,$40,$00,$08,$00,$00,$00,$00,$00
.DB $FF,$00,$6A,$00,$44,$00,$08,$00,$10,$00,$00,$00,$04,$00,$00,$00
.DB $44,$00,$00,$00,$00,$00,$02,$00,$20,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$10,$00,$44,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00
.DB $80,$00,$E0,$00,$F8,$00,$FF,$00,$FF,$00,$FD,$02,$BF,$40,$FF,$00
.DB $00,$00,$07,$00,$1F,$00,$FF,$00,$F7,$08,$FF,$00,$DF,$20,$FF,$00
.DB $FC,$00,$BF,$40,$FD,$02,$FF,$00,$EF,$10,$FF,$00,$7D,$82,$FF,$00
.DB $1F,$00,$FB,$04,$FF,$00,$EF,$10,$FF,$00,$FF,$00,$BD,$42,$FF,$00
.DB $02,$00,$E0,$00,$B8,$40,$FF,$00,$FF,$00,$DF,$20,$FD,$02,$FF,$00
.DB $FF,$00,$BB,$44,$FF,$00,$F7,$08,$FF,$00,$FF,$00,$B7,$48,$45,$BA
.DB $FF,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF
.DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF

grass_tile_data:
;.DB $00,$00,$82,$00,$64,$00,$24,$00,$14,$00,$54,$00,$55,$00,$00,$00
;.DB $00,$00,$82,$82,$64,$64,$24,$24,$14,$14,$54,$54,$55,$55,$00,$00
.DB $00,$00,$82,$82,$64,$64,$34,$34,$15,$15,$55,$55,$84,$84,$80,$80

.DEFINE cloud_tile_map_size $04
.DEFINE cloud_tile_map_width $02
.DEFINE cloud_tile_map_height $02

.DEFINE cloud_tile_data_size $40
.DEFINE cloud_tile_count $04

cloud_map_data:
.DB $00,$01,$02,$03

cloud_tile_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$0F,$10,$1F,$20,$3D,$42
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$40,$C0,$30,$D4,$2A
.DB $7A,$85,$15,$6A,$00,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $A9,$57,$44,$BC,$60,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; vim: filetype=wla
