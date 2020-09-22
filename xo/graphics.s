
.INCLUDE "header.i"
.INCLUDE "cgb_hardware.i"

;==============================================================================
; GRAPHICS
;==============================================================================

.SECTION "Graphic Routines" FREE

DMARoutineOriginal:
    ld a, >OAMbuffer
    ldh (R_DMA), a
    ld a, $28		; 5x40 cycles, approx. 200ms
-   dec a
    jr nz, -
    ret

ScreenOn:
    ldh a, (R_LCDC)
    or %10000000
    ldh (R_LCDC), a
    ret

ScreenOff:
    halt    ; wait for VBlank
    nop
    ldh a, (R_LCDC)
    xor %10000000
    ldh (R_LCDC), a
    ret

UpdateScreen:
    ; moves tilemapbuff to VRAM
    ld hl, tilemapbuff
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

FadePause:
    ld a, 2
-   halt
    nop
    call UpdateMusic
    dec a
    jp nz, -
    ret

FadeInRev:
    ld a, %11111111
    ldh (R_BGP), a
    call FadePause
    ld a, %11111110
    ldh (R_BGP), a
    call FadePause
    ld a, %11111010
    ldh (R_BGP), a
    call FadePause
    ld a, %11100100
    ldh (R_BGP), a
    call FadePause
    ret

FadeIn:
    ld a, %00000000
    ldh (R_BGP), a
    call FadePause
    ld a, %01000000
    ldh (R_BGP), a
    call FadePause
    ld a, %10010100
    ldh (R_BGP), a
    call FadePause
    ld a, %11100100
    ldh (R_BGP), a
    call FadePause
    ret

FadeOut:
    ld a, %11100100
    ldh (R_BGP), a
    call FadePause
    ld a, %10100100
    ldh (R_BGP), a
    call FadePause
    ld a, %01010000
    ldh (R_BGP), a
    call FadePause
    ld a, %00000000
    ldh (R_BGP), a
    call FadePause
    ret

FadeOutRev:
    ld a, %11100100
    ldh (R_BGP), a
    call FadePause
    ld a, %11111001
    ldh (R_BGP), a
    call FadePause
    ld a, %11111110
    ldh (R_BGP), a
    call FadePause
    ld a, %11111111
    ldh (R_BGP), a
    call FadePause
    ret

ScrollBG:
    ; Scrolls the bg tile every 4 frames
    ld a, (vbcounter)
    and 3
    cp 3
    jr nz, ++			; all finished if not zero
    ld a, (menubgtile)		; load tile index # and increment
    inc a
    cp 4
    jr nz, +
    xor a
+   ld (menubgtile), a
    ld hl, menubg_data		; move new tile data into tile memory
    swap a			; a*16 into bc
    ld c, a
    ld b, 0
    add hl, bc
    ld de, $8000 + ($AE*16)
    ld bc, 16
    call MoveData
++  ret

InitCursor:
    ld a, $50	    ; tile #
    ld e, 4	    ; 4 sprites
    ld hl, OAMbuffer; starting of OAM buffer

    ; tile number
-   inc hl	    ; skip y
    inc hl	    ; skip x
    ldi (hl), a
    inc hl	    ; and skip attr/flags
    inc a	    ; next tile
    dec e
    jp nz, -

    ld de, $3844
    call CursorMove ; sets up coordinates
    ret

CursorMove:
    ; d	    y ordinate
    ; e	    x ordinate
    ld a, e
    ldh ($90), a    ; store x ord for later
    ld hl, OAMbuffer; starting of OAM buffer
    ;ld d, 16	    ; y ord
    ld b, 2	    ; y
--  ldh a, ($90)    ; x ord
    ld e, a
    ld c, 2	    ; x
-   ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
    inc hl
    inc hl
    ld a, 8
    add e
    ld e, a
    dec c
    jp nz, -
    ld a, 8
    add d
    ld d, a
    dec b
    jp nz, --    
    ret

CursorUpdate:
    ; Updates cursor sprites based on cursorx and cursory
    ld a, (cursory)
    cp 0
    jp z, +	    ; don't need to multiply y as it is 0
    ld c, a
    xor a
-   add 3
    dec c
    jp nz, -
+   ld c, a
    ld a, (cursorx)
    add c
    rla		    ; x2 since it's words
    ld hl, CursorPos
    ld d, 0
    ld e, a
    add hl, de
    ldi a, (hl)	    ; first byte
    ld e, a
    ld d, (hl)	    ; second byte
    call CursorMove
    ret

DrawMenuBox:
.DEFINE tile_empty  0
.DEFINE tile_boxtl  $A6
.DEFINE tile_boxtr  $A7
.DEFINE tile_boxbr  $A8
.DEFINE tile_boxbl  $A9
.DEFINE tile_boxt   $AA
.DEFINE tile_boxl   $AB
.DEFINE tile_boxb   $AC
.DEFINE tile_boxr   $AD
    ; Draws a box with the screen in the top left of the map
    ; b	    x of top left of box
    ; c	    y of top left of box
    ; d	    width
    ; e	    height
    ld hl, tilemapbuff+$53
    ld de, $6
    ld b, 5	    ; y of box
    ; first row
    ld c, 14	    ; x of box
    ld a, tile_boxtl
    ldi (hl), a
    dec c
-   ld a, tile_boxt
    ldi (hl), a
    dec c
    ld a, c
    cp 1
    jr nz, -
    ld a, tile_boxtr
    ldi (hl), a
    dec c
    add hl, de	    ; next row

    ; middle rows
--  ld c, 14
-   ld a, c
    cp 14
    jr z, @right
    cp 1
    jr z, @left
@empty:
    ld a, tile_empty
    jr +
@left:
    ld a, tile_boxl
    jr +
@right:
    ld a, tile_boxr
+   ldi (hl), a
    dec c
    jr nz, -
    add hl, de
    dec b
    ld a, b
    cp 1
    jr nz, --
    
    ;last row
    ld c, 14
    ld a, tile_boxbl
    ldi (hl), a
    dec c
-   ld a, tile_boxb
    ldi (hl), a
    dec c
    ld a, c
    cp 1
    jr nz, -
    ld a, tile_boxbr
    ldi (hl), a
    ;dec c
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

PrintInt:
    ; Prints 1 byte to VRAM tilemap three digits/tiles
    ; a	    byte to print out
    ; de    tile destination (somewhere in VRAM tilemap)
    daa
    ld b, a	    ; store for later
    and $F0
    swap a
    add numberOffset
    ld (de), a
    inc de
    ld a, b
    and $0F	    ; bottom
    add numberOffset
    ld (de), a
    ret

DrawFieldTile2:
    ; b    field value
    ; de    tile to change
.DEFINE empty_tile	$42
.DEFINE o_tile		$46
.DEFINE	x_tile		$4A
    
    ld hl, FieldAddr
    sla e	    ; x2 because it's words and not bytes
    add hl, de
    ldi a, (hl)	    ; low byte of address
    ld e, a
    ld a, (hl)	    ; high byte of address
    ld d, a

    ld a, b

    cp 1		; is the tile an x?
    jp nz, +
    ld b, x_tile
    jp ++
+   cp 2		; is the tile an o?
    jp nz, +
    ld b, o_tile
    jp ++
+   ld b, empty_tile	; anything else will be empty
++
    halt    ; wait for VBlank
    nop
    ld l, e
    ld h, d
    ld c, 4
-   ld (hl), b
    inc hl
    inc b
    dec c
    ld a, c
    cp 2
    jp nz, +
    ld de, $1E
    add hl, de
+   cp 0
    jp nz, -
    ret


.ENDS

.SECTION "Graphics" FREE

Tiles:
.INCBIN "numbers.bin"	FSIZE size_of_numbers
.INCBIN "alphas.bin"	FSIZE size_of_alphas
.INCLUDE "menutiles.i"


.INCLUDE "turt.i"
.INCLUDE "shell.i"
.INCLUDE "ox.i"
.INCLUDE "cursor.i"

.DEFINE TileCount	size_of_numbers + size_of_alphas + menutiles_count
.EXPORT TileCount

.ENDS

; vim: filetype=wla
