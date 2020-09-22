
;==============================================================================
;
; XO
;
; Samuel Volk, July 2018
;
; Eckses and Ohes. That tic tac toe game you all know.
;
;==============================================================================

.INCLUDE "cgb_hardware.i"
.INCLUDE "header.i"
.INCLUDE "palettes.i"
.INCLUDE "wram.i"
.INCLUDE "hram.i"


;==============================================================================
; START
;==============================================================================
.ORG $150
Start:
    di
    ld sp, $FFFE    ; setup stack

    call DetectSystem

    ld a, %000000001 ; setup interrupts
    ldh (R_IE), a

@waitVblank:
    ldh a, (R_LY)
    cp 144
    jr nz, @waitVblank
    ; turn screen off
    call ScreenOff

    ; Blank a buncha stuff
    xor a
    ld hl, $C000	    ; blank WRAM
    ld bc, $2000
    call BlankData
    ld hl, $8000	    ; blank sprites
    ld bc, 4080
    call BlankData
    ld hl, $9800	    ; blank map
    ld bc, 1024
    call BlankData

    ; load palette
    ld a, %00000000	; bg
    ldh (R_BGP), a
    ld a, %11100100	; obj
    ldh (R_OBP0), a

    ; CGB palette
    ldh a, (h_CGB)
    cp 1
    jr nz, +
    ; background palette
    ld a, $80
    ldh (R_BCPS), a
    ld hl, Pal_SeaGreen
    ld c, 8
-   ldi a, (hl)
    ldh (R_BCPD), a
    dec c
    jr nz, -
    ; sprite palette
    ld a, $80
    ldh (R_OCPS), a
    ld hl, Pal_GreyScale
    ld c, 8
-   ldi a, (hl)
    ldh (R_OCPD), a
    dec c
    jr nz, -
+

    ; SGB Palette
    ldh a, (h_SGB)
    cp 1
    jr nz, +
    ld hl, SGBPal_SeaGreen
    call SGBSend
+

    ld hl, DMARoutineOriginal
    ld de, DMARoutine
    ld bc, _sizeof_DMARoutineOriginal
    call MoveData	    ; copy DMA routine to HRAM
    call DMARoutine	    ; blank sprites

    ; setup screen
    ld a, %00010011
    ldh (R_LCDC), a

    ; start with sound on
    ld a, $80
    ldh (R_NR52), a

    ; set random seed
    ld a, 88
    ld (seed), a
    ; set starting player
    ld hl, initiator
    ld (hl), 1

    call ScreenOn
    ei

SoftReset:
    call ScreenOff
    xor a
    ld (games), a		    ; blank some variables in wram
    ld (gamesplayed), a
    ld (won), a
    ld (lost), a
    ld (tied), a
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

    xor a
    ld hl, OAMbuffer	; blank OAM buffer
    ld bc, 160
    call BlankData

    call UpdateScreen

    ; setup sound
    ld a, $77
    ldh (R_NR50), a
    ld a, $FF
    ldh (R_NR51), a

    ld hl, WaveRamp
    call LoadWaveform
    ld hl, SongTitle
    call LoadMusic

    call ScreenOn
    call FadeIn


TitleScreen:
    ld hl, state
    ld (hl), $0	; main menu state
@loop:
    halt
    nop
    call DMARoutine
    call UpdateMusic

    call ReadInput
    ld a, (joypadStateNew)
    cp (JOY_A | JOY_SELECT)
    jp z, Credits
    ld a, (joypadStateDiff)
    and JOY_START
    jr nz, MainMenu
    jr @loop

MainMenu:
    call ScreenOff
    ld a, $AE
    ld hl, tilemapbuff		    ; blank map buffer
    ld bc, 1024
    call BlankData

    xor a
    ld (menucursor), a
    ld a, $10
    ld (cursorx), a
    ld (cursory), a

    call DrawMenuBox

    ; Menu text
    ld hl, TextMainMenu1
    ld de, tilemapbuff+($14*6)+6
    call PrintStr
    ld hl, TextMainMenu2
    ld de, tilemapbuff+($14*7)+6
    call PrintStr

    ; setup cursor oam
    ld hl, OAMbuffer
    ld a, $40
    ldi (hl), a
    ld a, $2A
    ldi (hl), a
    ld a, $A5
    ldi (hl), a

    call UpdateScreen
    call ScreenOn
@loop:
    halt
    nop
    call DMARoutine
    call UpdateMusic

    call ScrollBG
    
    call ReadInput
    ld a, (joypadStateDiff)
    ld b, a
    and (JOY_UP | JOY_DOWN)
    jr z, +
    ld a, (menucursor)
    cpl
    and 1
    ld (menucursor), a
    ; cursor.y = menucursor*8 + $40
.REPEAT 3
    sla a
.ENDR
    add $40
    ld hl, OAMbuffer
    ld (hl), a

+   ld a, b
    and (JOY_A | JOY_START)
    jr z, +
    ld a, (menucursor)
    cp 0
    jp z, GameSelectSetup	; New Game
    cp 1
    jp z, Options		; Options
    ld a, b

+   jr @loop

Options:
    call ScreenOff
    ld a, $AE
    ld hl, tilemapbuff		    ; blank map buffer
    ld bc, 1024
    call BlankData

    xor a
    ld (menucursor), a
    ld a, $10
    ld (cursorx), a
    ld (cursory), a

    call DrawMenuBox

    ; menu text
    ld hl, TextOptions0
    ld de, tilemapbuff+($14*6)+6
    call PrintStr
    ld hl, TextOptions1
    ld de, tilemapbuff+($14*7)+6
    call PrintStr

    ; setup cursor oam
    ld hl, OAMbuffer
    ld a, $40
    ldi (hl), a
    ld a, $2A
    ldi (hl), a
    ld a, $A5
    ldi (hl), a

    call UpdateScreen
    call ScreenOn
@loop:
    halt
    nop
    call DMARoutine
    call UpdateMusic

    call ScrollBG

    call ReadInput
    ld a, (joypadStateDiff)
    ld b, a
    and (JOY_UP | JOY_DOWN)
    jr z, +
    ld a, (menucursor)
    cpl
    and 1
    ld (menucursor), a
    ; cursor.y = menucursor*8 + $40
.REPEAT 3
    sla a
.ENDR
    add $40
    ld hl, OAMbuffer
    ld (hl), a

+   ld a, b
    and (JOY_A | JOY_START)
    jr z, +
    ld a, (menucursor)
    cp 0
    jp nz, ++
    ldh a, (R_NR52)	    ; toggle sound
    cpl
    and 1 << 7
    ldh (R_NR52), a
    jr z, +
    push bc
    ld a, $77
    ldh (R_NR50), a
    ld a, %11111111
    ldh (R_NR51), a
    ld hl, WaveRamp
    call LoadWaveform
    ld hl, SongTitle	    ; reload song since it was stopped
    call LoadMusic
    pop bc
    jr +
++  cp 1
    jp z, MainMenu

+   ld a, b
    and JOY_START
    jp nz, MainMenu

    jp @loop
    
GameSelectSetup:
    call ScreenOff
    ld a, $AE
    ld hl, tilemapbuff
    ld bc, 1024
    call BlankData		    ; blank map data

    xor a
    ld (menucursor), a
    ld a, $10
    ld (cursorx), a
    ld (cursory), a

    call DrawMenuBox
    ; game select text
    ld hl, TextGameSelect0	    ; Out of how many games?
    ld de, tilemapbuff+($14*5)+5
    call PrintStr
    ld hl, TextGameSelect1	    ; 1 game
    ld de, tilemapbuff+($14*6)+6
    call PrintStr
    ld hl, TextGameSelect2	    ; 3 games
    ld de, tilemapbuff+($14*7)+6
    call PrintStr
    ld hl, TextGameSelect3	    ; 5 games
    ld de, tilemapbuff+($14*8)+6
    call PrintStr

    ; setup cursor OAM
    ld hl, OAMbuffer
    ld a, $40
    ldi (hl), a
    ld a, $2A
    ldi (hl), a
    ld a, $A5
    ldi (hl), a

    call UpdateScreen
    call ScreenOn
@loop:
    halt
    nop

    call DMARoutine
    call UpdateMusic

    call ScrollBG

    call ReadInput
    ld a, (joypadStateDiff)
    ld b, a
    and (JOY_UP | JOY_DOWN)
    jr z, @nocursormove
    and JOY_UP
    jr z, +
    ld a, (menucursor)
    and a
    jr z, ++
    dec a
    jr ++
+   ;and JOY_DOWN
    ld a, (menucursor)
    inc a
++  
    ; limit menucursor to 0-2
    cp 3
    jr c, +
    ld a, 2
+   ld (menucursor), a
    
    ; cursor.y = menucursor*8 + $40
    sla a
    sla a
    sla a
    add $40
    ld hl, OAMbuffer
    ld (hl), a
@nocursormove:

    ld a, b
    and (JOY_A | JOY_START)
    jr z, @noselect
    ld a, (menucursor)
    cp 0
    jr nz, +
    ld a, 1		    ; best out of 1
    jr ++
+   cp 1
    jr nz, +
    ld a, 3		    ; best out of 3
    jr ++
+   cp 2
    jr nz, +
    ld a, 5		    ; best out of 5
++  ld (games), a
    call FadeOut
    jr GameSetup
@noselect:
    jp @loop

GameSetup:
    ldh a, (R_LCDC)	    ; toggle objs
    res 1, a
    ldh (R_LCDC), a
    call ScreenOff

    xor a
    ld hl, $9800	    ; blank map
    ld bc, 1024
    call BlankData
    ld hl, $8000	    ; blank sprites
    ld bc, 4080
    call BlankData

    ; font tiles
    ld hl, Tiles
    ld de, $8800
    ld bc, TileCount
    call MoveData

    ld hl, shell_tile_data
    ld de, $8000
    ld bc, $420+16*12
    call MoveData
    ld hl, cursor_tile_data
    ld de, $8500
    ld bc, cursor_tile_data_size
    call MoveData
    ld hl, shell_map_data
    call LoadScreen

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

    ldh a, (R_NR51)
    res 5, a
    res 1, a
    ldh (R_NR51), a

    call DMARoutine
    call ScreenOn

    call FadeIn
    ldh a, (R_LCDC)	; toggle objs
    set 1, a
    ldh (R_LCDC), a

MainLoop:
    halt
    nop
    call DMARoutine
    call UpdateMusic

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
    halt		    ; wait for VBlank
    nop
    ld hl, TextRoundWon
    ld de, $9825
    call PrintStr
    jp @end
@loss:
    ; increment losses
    ld a, (lost)
    adc 1
    daa
    ld (lost), a
    halt		    ; wait for VBlank
    nop
    ld hl, TextRoundLost
    ld de, $9825
    call PrintStr
    jp @end
@tie:
    ; increment ties
    ld a, (tied)
    adc 1
    daa
    ld (tied), a
    halt		    ; wait for VBlank
    nop
    ld hl, TextRoundTied
    ld de, $9825
    call PrintStr
@end:
    ld hl, gamesplayed	    ; increment games played
    inc (hl)
    ld de, $0000
    call CursorMove
@endloop:
    halt
    nop
    call DMARoutine
    call UpdateMusic
    call ReadInput
    
    ld a, (joypadStateDiff)
    and (JOY_A | JOY_B | JOY_START | JOY_SELECT)
    jr z, @endloop

    call FadeOut
    ; figure out if we need another round
    ld a, (games)
    sra a
    add 1		; games to win = games/2+1
    ld hl, won
    cp (hl)
    jp z, SoftReset
    inc hl
    cp (hl)
    jp z, SoftReset
    inc hl
    cp (hl)
    jp z, SoftReset
    ; have we played enough games since there's no clear winner/loser?
    ld a, (gamesplayed)
    ld b, a
    ld a, (games)
    cp b		; games - gamesplayed
    jp z, SoftReset
    jp GameSetup	; else, new round


Credits:
    call FadeOut
    call ScreenOff

    xor a
    ld hl, $9800	; Blank map
    ld bc, 1024
    call BlankData
    ld hl, $8000	; Blank mprites
    ld bc, 4080
    call BlankData
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
    call DMARoutine
    call UpdateMusic

    call ReadInput
    ld a, (joypadStateDiff)
    and $FF
    jp z, @loop

    call FadeOut
    jp SoftReset


;==============================================================================
; DATA
;l==============================================================================
.SECTION "MiscData" FREE

FieldAddr:
.DW $98A6, $98A9, $98AC, $9906, $9909, $990C, $9966, $9969, $996C

CursorPos:  ; yyxx
.DW $3844, $385C, $3874, $5044, $505C, $5074, $6844, $685C, $6874

.ENDS

; vim: filetype=wla
