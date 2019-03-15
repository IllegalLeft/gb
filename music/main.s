
;==============================================================================
;
; MUSIC
;
; Samuel Volk, March 2019
;
; Just plays music. My attempt at a Gameboy sound 'engine' in hopes that it
; might be used for other GameBoy projects of mine.
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"

;==============================================================================
; INTERRUPTS
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
; WRAM DEFINITIONS
;==============================================================================

.ENUM $C000
    MusicCounter    DB	    ; counter for current ticks (+1 per vblank)
    MusicTicks	    DB	    ; ticks limit for step
    MusicPointer    DSW 4   ; pointer to next music data for each channel
    MusicTimers     DS  4   ; counter for length stuff for each channel
    MusicVoices	    DSW 3   ; music voice/instruments
.ENDE

.DEF MusicChannels  4	    ; total number of music channels
;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
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
    ldh a, (R_LCDC)
    or %01000000
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

.ENDS

;==============================================================================
; START
;==============================================================================
.BANK 0
.ORG $150
Start:
    di
    ld sp, $FFFE    ; setup stack

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
    call BlankMap


    ; load palette
    ld a, %11100100	; bg
    ldh (R_BGP), a
    ld a, %00011011	; obj
    ldh (R_OBP0), a

    call DMACopy ; set up DMA subroutine

    ; Load waveform
    ld hl, WaveRamp
    call LoadWaveform

    ; select interrupts to enable
    ld a, %00000001
    ldh (R_IE), a

    ; setup screen
    ld a, %10010011
    ldh (R_LCDC), a

    ei

    ld hl, Song_CmdTests
    call LoadMusic

    ; setup sound
    ld a, %10000000
    ldh (R_NR52), a
    ld a, %01110111 ; full volume
    ldh (R_NR50), a
    ld a, $FF	    ; mono
    ldh (R_NR51), a

MainLoop:
    halt    ; wait for vblank
    nop

    call $FF80 ; DMA routine in HRAM

    call UpdateMusic

    jp MainLoop


;==============================================================================
; DATA
;==============================================================================
.BANK 0
.SECTION "Data" FREE

.DEFINE TileCount   0
Tiles:
.DB $00

.ENDS

.SECTION "MusicData" FREE
Pitches:
.DW $F82C   ; C	    1
.DW $F89D   ; C#    2
.DW $F907   ; D	    3
.DW $F96B   ; D#    4
.DW $F9CA   ; E	    5
.DW $FA23   ; F	    6
.DW $FA77   ; F#    7
.DW $FAC7   ; G	    8
.DW $FB12   ; G#    9
.DW $FB58   ; A	    a
.DW $FB9B   ; A#    b
.DW $FBDA   ; B	    c

Instruments:
Inst1:
    .DB $84, $F2
Inst2:
    .DB $07, $40
Inst3:
    .DB $27, $F2

WaveSquare:
.DS 8 $FF
.DS 8 $00
WaveRamp:
.DB $00, $11, $22, $33, $44, $55, $66, $77
.DB $88, $99, $AA, $BB, $CC, $DD, $EE, $FF

NoiseSamples:
Kick:		; 1
.DB $81, $56
Snare:		; 2
.DB $82, $51
HiHat2:		; 3
.DB $81, $00
HiHat2Open:	; 4
.DB $82, $00
HiHat:		; 5
.DB $42, $14

; Music format:
; $00 = end of song
; $YX = note Y in octave X
;	notes $1-C, octaves $0-$6
; $7X = pause for X counts
; $FX = commands followed by operand bytes
;	$0 = tempo
;	$1 = loop
;	$2 = change instrument/voice
Song_MaryLamb:
    .DB $10,	; Tempo $20
    .DB $00, $00, $01
    .DW Song_MaryLambCh0
    .DW Song_MaryLambCh1
    .DW Song_MaryLambCh2
    .DW Song_MaryLambCh3
Song_MaryLambCh0:
    .DB $35, $33, $31, $33, $35, $35, $35, $71
    .DB $33, $33, $33, $71, $35, $38, $38, $71
    .DB $35, $33, $31, $33, $35, $35, $35
    .DB $35, $33, $33, $35, $33, $31, $73
    .DB $F1, $1E 		; loop
Song_MaryLambCh1:
Song_MaryLambCh2:
    .DB $00
Song_MaryLambCh3:
    .DB $01, $03
    .DB $02, $03
    .DB $F1, $04
    .DB $00

Song_WavTest:
    .DB $08
    .DB $00, $00, $01
    .DW Song_WavTestCh0
    .DW Song_WavTestCh1
    .DW Song_WavTestCh2
    .DW Song_WavTestCh3
Song_WavTestCh0:
Song_WavTestCh1:
    .DB $00
Song_WavTestCh2:
    .DB $35, $33, $31, $33, $35, $35, $35, $71
    .DB $33, $33, $33, $71, $35, $38, $38, $71
    .DB $35, $33, $31, $33, $35, $35, $35
    .DB $35, $33, $33, $35, $33, $31, $73
    .DB $F1, $1E 		; loop
Song_WavTestCh3:
    .DB $01, $03
    .DB $02, $03
    .DB $F1, $04
    .DB $00

Song_CmdTests:
    .DB $10
    .DB $00, $00, $01
    .DW Song_CmdTestsCh0
    .DW Song_CmdTestsCh1
    .DW Song_CmdTestsCh2
    .DW Song_CmdTestsCh3
Song_CmdTestsCh0:
    .DB $31, $35, $38, $35
    .DB $F0, $0A
    .DB $F2, $03
    .DB $31, $35, $38, $35
    .DB $F0, $10
    .DB $F2, $00
    .DB $F1, 16
Song_CmdTestsCh1:
Song_CmdTestsCh2:
Song_CmdTestsCh3:
    .DB $00

.ENDS

; vim: filetype=wla
