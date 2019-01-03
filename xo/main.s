
;==============================================================================
;
; XO
;
; Samuel Volk, July 2018
;
; Eckses and Ohes. That tic tac toe game you all know.
;
;==============================================================================

.GBHEADER
    NAME "XOXOXO"
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
.ENUM $C000
    state	DB		; 0 main menu, 1 xturn, 2 oturn, 3 end game
    initiator	DB		; holds player who started last
    won		DB
    lost	DB
    tied	DB
    cursorx	DB		; 0-2
    cursory	DB		; 0-2
    field	DS	9	; field is 3x3, 0 empty, 1 x, 2 o
    seed	DB		; seed for randint generator
.ENDE
; $C100 is OAM buffer
.ENUM $C200
    tilemapbuff	DS	20*18	; tilemap buffer
.ENDE

; HRAM constants
.ENUM $FF8D	; before this is after the DMA routine
    joypadStateNew	DB
    joypadStateOld	DB
    joypadStateDiff	DB
.ENDE

.DEFINE numberOffset	$80
.DEFINE alphaOffset	numberOffset+11

.ASCIITABLE
MAP "0" TO "9" = numberOffset
MAP "A" TO "Z" = alphaOffset
MAP " " = $8A
MAP "@" = $00
.ENDA

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
.ORG $3000
.SECTION "Subroutines" FREE

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
    ; hl    tile source address
    ; bc    # of bytes to load (tiles * 16)
    ld de, $8000
    ;ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

BlankData:
    ; a	    value
    ; hl    destination
    ; bc    length/size
    ld d, a	; will need to retrieve later
-   ldi (hl), a
    dec bc
    ld a, b
    or c
    ld a, d
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
    ;ld hl, Tiles
    ld de, $9800
    ;ld bc, TileCount
-   ldi a, (hl)
    ld (de), a
    inc de
    dec bc
    ld a, b
    or c
    jp nz, -
    ret

LoadScreen:
    ; hl    map source
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

ScreenOn:
    ldh a, ($40)
    or %10000000
    ldh ($40), a
    ret

ScreenOff:
    halt    ; wait for VBlank
    nop
    ldh a, ($40)
    xor %10000000
    ldh ($40), a
    ret

FadePause:
    ld a, 2
-   halt
    nop
    dec a
    jp nz, -
    ret

FadeInRev:
    ld a, %11111111
    ldh ($47), a
    call FadePause
    ld a, %11111110
    ldh ($47), a
    call FadePause
    ld a, %11111010
    ldh ($47), a
    call FadePause
    ld a, %11100100
    ldh ($47), a
    call FadePause
    ret

FadeIn:
    ld a, %00000000
    ldh ($47), a
    call FadePause
    ld a, %01000000
    ldh ($47), a
    call FadePause
    ld a, %10010100
    ldh ($47), a
    call FadePause
    ld a, %11100100
    ldh ($47), a
    call FadePause
    ret

FadeOut:
    ld a, %11100100
    ldh ($47), a
    call FadePause
    ld a, %10100100
    ldh ($47), a
    call FadePause
    ld a, %01010000
    ldh ($47), a
    call FadePause
    ld a, %00000000
    ldh ($47), a
    call FadePause
    ret


FadeOutRev:
    ld a, %11100100
    ldh ($47), a
    call FadePause
    ld a, %11111001
    ldh ($47), a
    call FadePause
    ld a, %11111110
    ldh ($47), a
    call FadePause
    ld a, %11111111
    ldh ($47), a
    call FadePause
    ret

DMACopy:
    ; https://exez.in/gameboy-dma
    ld de, $FF80    ; destination of HRAM for DMA routine
    rst $28
    .DB $00, $0D    ; assembled DMA subroutine length
		    ; then assembled DMA subroutine
    .DB $F5, $3E, $C1, $EA, $46, $FF, $3E, $28, $3D, $20, $FD, $F1, $D9
    ret

InitCursor:
    ld a, $50	    ; tile #
    ld e, 4	    ; 4 sprites
    ld hl, $C100    ; starting of OAM buffer

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
    ld hl, $C100    ; starting of OAM buffer
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


ReadInput:
    ld a, (joypadStateNew)	; move old keypad state
    ld (joypadStateOld), a

    ld a, $20	    ; select P14
    ld ($FF00), a
    ld a, ($FF00)   ; read pad
    ld a, ($FF00)   ; a bunch of times
    cpl		    ; active low so flip 'er 
    and $0f	    ; only need last 4 bits
    swap a
    ld b, a
    ld a, $10	    ; select P15
    ld ($FF00), a   ;
    ld a, ($FF00)
    ld a, ($FF00)
    cpl
    and $0F	    ; only need last 4 bits
    or b	    ; put a and b together
    ld (joypadStateNew), a ; store into 0page for later

    ld b, a			; Find difference in two keystates
    ld a, (joypadStateOld)
    xor b
    ld b, a
    ld a, (joypadStateNew)
    and b
    ld (joypadStateDiff), a

    ld a, $30	    ; reset joypad
    ld ($FF00), a
    ret

HandleInput:
    ld a, (joypadStateDiff)
    ld b, a
    and %00010000   ; right
    jp z, @noright
    ld a, (cursorx)
    cp 2
    jp z, @noright
    inc a
    ld (cursorx), a
    call CursorUpdate
@noright:
    ld a, b
    and %00100000   ; left
    jp z, @noleft
    ld a, (cursorx)
    cp 0
    jp z, @noleft
    dec a
    ld (cursorx), a
    call CursorUpdate
@noleft:
    ld a, b
    and %01000000   ; up
    jp z, @noup
    ld a, (cursory)
    cp 0
    jp z, @noup
    dec a
    ld (cursory), a
    call CursorUpdate
@noup:
    ld a, b
    and %10000000   ; down
    jp z, @nodown
    ld a, (cursory)
    cp 2
    jp z, @nodown
    inc a
    ld (cursory), a
    call CursorUpdate
@nodown:
    ld a, b
    and %00000001   ; A
    jp z, @noa
    ld hl, state    ; is it player's turn?
    ld a, (hl)
    cp 1
    jp nz, @noa	    ; jump if it isn't
    ld a, (cursory)
    cp 0
    jp z, +	; you don't need to multiply it if it's 0
    ld c, a
    xor a
-   add 3
    dec c
    jp nz, -
+   ld c, a
    ld a, (cursorx)
    add c	; offset for cursor square in a
    ld hl, field
    ld d, 0
    ld e, a
    add hl, de	; add offset to find selected field spot
    ld a, (hl)
    cp 0
    jp z, @place
@noa:
    ret
@place:
    ld b, 1
    push hl	    ; need to save hl (offset for field spot)
    call DrawFieldTile2
    pop hl
    ld (hl), 1	    ; Xs are 1
    ld hl, state
    ld (hl), 2	    ; Os turn
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

RandomInt:
    ld a, (seed)
    sla a
    jp nc, +
    xor %00011101
+   ld (seed), a
    ret

CPUTurn:
-   call RandomInt  ; get a random spot
    and $0F
    cp 9
    jp nc, -
    ld hl, field    ; is it occupied?
    ld d, 0
    ld e, a
    add hl, de
    ld a, (hl)
    cp 0
    jp nz, -	    ; ...then pick another!
    ld (hl), 2	    ; place
    ld b, 2
    ;ld de, ..	; already loaded up to go!
    call DrawFieldTile2
    ld a, 1
    ld (state), a   ; players turn now
    ret

CheckforWin:
    ; This function will return 1 on x win and 2 on o win and 3 for tie
    ; return value in accumulator

    ; horizontal wins
    ld hl, field
    ld b, 3	    ; three rows
--  ld c, 3	    ; three spots per row
    ldi a, (hl)	    ; load the first one
    jp +
-   and (hl)	    ; but and it with the next two for result
    inc hl
+   dec c
    jp nz, -
    and 3	    ; row is finished check, compare result
    jp nz, @hwin    ; handle win
    dec b	    ; next row
    jp nz, --
    jp @nohwin
@hwin:
    ret		    ; acc. has the winning side already
@nohwin:

    ; vertical wins
    ld hl, field
    ld de, 3	    ; column items are 3 bytes apart
    ld b, 3	    ; three columns
--  ld c, 3	    ; three spots
    ld a, (hl)	    ; load first one
    jp +
-   and (hl)	    ; but and it with the next two for result
+   add hl, de
    dec c
    jp nz, -
    and 3	    ; column is finished check, compare result
    jp nz, @vwin    ; handle win
    dec b	    ; next column
    jp z, @novwin   ; b = 0 so we are done
    bit 0, b
    jp nz, @col2    ; b must be odd
@col1:
    ld hl, (field+1)
    jp @coladdrpicked
@col2:
    ld hl, (field+2)
@coladdrpicked:
    xor a
    cp b
    jp nz, --	    ; start new column
    jp @novwin
@vwin:
    ret		    ; acc. has the winning side already
@novwin:

    ; diagonal wins
    ld hl, field	; top left to bottom right
    ld a, (hl)
    inc l
    inc l
    inc l
    inc l
    and (hl)
    inc l
    inc l
    inc l
    inc l
    and (hl)
    jp nz, @diagonalwin
    ; top right to bottom left
    ld hl, (field+2)	; top left to bottom right
    ld a, (hl)
    inc l
    inc l
    and (hl)
    inc l
    inc l
    and (hl)
    jp nz, @diagonalwin
    jp @diagonalnowin
@diagonalwin:
    ret		    ; acc. has winning side
@diagonalnowin:

    ; check for filled field (tie)
    ld hl, field
    ld c, 9
-   ldi a, (hl)
    and $0F	    ; just to get the Z flag really
    jp z, @notie
    dec c
    jp nz, -
@tie:
    ld a, 3	    ; tie
    ret
@notie:
    ld a, 0
    ret

.ENDS

;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE    ; setup stack

    ld a, %000000001 ; setup interrupts
    ldh ($FF), a

    ; wait for vblank
    halt
    nop
    ; turn screen off
    call ScreenOff

    ; no sound needed
    xor a
    ldh ($26), a

    ; Blank a buncha stuff
    call BlankWRAM
    call BlankOAM
    call BlankSprites
    call BlankMap

    ; load palette
    ld a, %00000000	; bg
    ldh ($47), a
    ld a, %11100100	; obj
    ldh ($48), a

    call DMACopy    ; set up DMA subroutine
    call $FF80	    ; DMA routine in HRAM

    ; setup screen
    ld a, %00010011
    ldh ($40), a

    ; set random seed
    ld a, 88
    ld (seed), a
    ; set starting player
    ld hl, initiator
    ld (hl), 1

    call ScreenOn
    ei

SoftReset:
    ld hl, state
    ld (hl), $0	; main menu state

    ; reset field
    ld hl, field
    ld c, 9
    xor a
-   ldi (hl), a
    dec c
    jp nz, -

    ; reset cursor to center
    ld a, 1
    ld (cursorx), a
    ld (cursory), a

    call ScreenOff
    ; font tiles
    ld hl, Tiles
    ld de, $8800
    ld bc, TileCount
    call MoveData
    ; load title screen
    ld hl, turt_tile_data
    ld de, $8000
    ld bc, turt_tile_data_size
    call MoveData
    ld hl, turt_map_data
    ld de, tilemapbuff
    ld bc, turt_tile_map_size
    call MoveData

    ; Turtle Tic Tac Toe
    ld hl, TextTitle
    ld de, tilemapbuff+($14*$1)+$1
    call PrintStr
    ; Press Start
    ld hl, TextStart
    ld de, tilemapbuff+($14*$10)+$4
    call PrintStr

    call BlankOAM

    call UpdateScreen
    call ScreenOn

    call FadeIn


TitleScreen:
    halt
    nop

    call $FF80	    ; DMA routine in HRAM
    call ReadInput
    ld a, (joypadStateNew)
    cp %00000101
    jp z, Credits
    ld a, (joypadStateDiff)
    and %00001000   ; start
    jp z, TitleScreen


GameSetup:
    call FadeOut
    call ScreenOff
    call BlankMap
    call BlankSprites

    ; font tiles
    ld hl, Tiles
    ld de, $8800
    ld bc, TileCount
    call MoveData

    ld hl, shell_tile_data
    ld bc, $420+16*12
    call LoadTiles
    ld hl, cursor_tile_data
    ld de, $8500
    ld bc, cursor_tile_data_size
    call MoveData
    ld hl, shell_map_data
    call LoadScreen

    call InitCursor
    call CursorUpdate

    ; figure out who goes first
    ld a, (initiator)
    ld (state), a
    dec a
    jp nz, +
    ld a, 2
+   ld (initiator), a

    ; Score text
    ld de, $9831
    ld a, $A1	    ; W
    ld (de), a
    ld a, (won)
    ld de, $9832
    call PrintInt
    ld de, $9851
    ld a, $9E	    ; T
    ld (de), a
    ld a, (tied)
    ld de, $9852
    call PrintInt
    ld de, $9871
    ld a, $96	    ; L
    ld (de), a
    ld a, (lost)
    ld de, $9872
    call PrintInt

    call ScreenOn

    call FadeIn

MainLoop:
    halt
    nop

    call $FF80		    ; DMA routine in HRAM

    call ReadInput
    call HandleInput

    call CheckforWin
    ld (tilemapbuff+10), a  ; top right corner
    cp 0
    jp nz, EndGame	    ; someone won? Or tie!

    ld hl, state
    ld a, (hl)
    cp 2		    ; is it the CPU's turn?
    call z, CPUTurn

    jp MainLoop


EndGame:
    ; a = endgame code
    cp 1
    jp z, @won
    cp 2
    jp z, @loss
    cp 3
    jp z, @tie
    jp @end	; failsafe
@won:
    ; increment wins
    ld a, (won)
    adc 1
    daa	; bcd is bae
    ld (won), a
    halt    ; wait for VBlank
    nop
    ld hl, TextWin
    ld de, $9826
    call PrintStr
    jp @end
@loss:
    ; increment losses
    ld a, (lost)
    adc 1
    daa
    ld (lost), a
    halt    ; wait for VBlank
    nop
    ld hl, TextLose
    ld de, $9826
    call PrintStr
    jp @end
@tie:
    ; increment ties
    ld a, (tied)
    adc 1
    daa
    ld (tied), a
    halt    ; wait for VBlank
    nop
    ld hl, TextTie
    ld de, $9826
    call PrintStr
@end:
    ld de, $0000
    call CursorMove
    halt    ; wait for VBlank
    nop
    call $FF80		    ; DMA routine in HRAM

@endloop:
    halt
    nop

    call ReadInput
    
    ld a, (joypadStateDiff)
    and %00001111
    jp z, @endloop
    call FadeOut
    jp SoftReset


Credits:
    call FadeOut
    call ScreenOff

    call BlankMap
    call BlankSprites
    xor a
    ld hl, tilemapbuff
    ld bc, 20*18
    call BlankData

    ;font
    ld hl, Tiles
    ld de, $8800
    ld bc, TileCount
    call MoveData

    ld hl, Credits1a
    ld de, tilemapbuff + (2*$14) + 1
    call PrintStr
    ld hl, Credits1b
    ld de, tilemapbuff + (4*$14) + 15
    call PrintStr
    ld hl, Credits2a
    ld de, tilemapbuff + (10*$14) + 1
    call PrintStr
    ld hl, Credits2b
    ld de, tilemapbuff + (12*$14) + 13
    call PrintStr

    call UpdateScreen

    call ScreenOn
    call FadeIn

@loop:
    halt
    nop

    call ReadInput
    ld a, (joypadStateDiff)
    and $FF
    jp z, @loop

    call FadeOut
    jp SoftReset


;==============================================================================
; DATA
;==============================================================================
.SECTION "Data" FREE
Tiles:
.INCBIN "numbers.bin" FSIZE size_of_numbers
.INCBIN "alphas.bin" FSIZE size_of_alphas

.INCLUDE "turt.s"
.INCLUDE "shell.s"
.INCLUDE "ox.i"
.INCLUDE "cursor.i"

.DEFINE TileCount   size_of_numbers + size_of_alphas

.INCBIN "boot.bin"  FSIZE size_of_boot

FieldAddr:
.DW $98A6, $98A9, $98AC, $9906, $9909, $990C, $9966, $9969, $996C

CursorPos:  ; yyxx
.DW $3844, $385C, $3874, $5044, $505C, $5074, $6844, $685C, $6874

; Strings
TextTitle:
.ASC "TURTLE TIC TAC TOE@"
TextStart:
.ASC "PRESS  START@"
TextWin:
.ASC "YOU WIN@"
TextLose:
.ASC "YOU LOSE@"
TextTie:
.ASC "YOU TIE@"

Credits1a:
.ASC "CODE AND ART@"
Credits1b:
.ASC "SAM@"
Credits2a:
.ASC "CONCEPT ART@"
Credits2b:
.ASC "HEIDI@"
.ENDS

; vim: filetype=wla
