
;==============================================================================
;
; MUSIC
;
; Samuel Volk, January 2019
;
; Just plays music. My attempt at a Gameboy sound 'engine' in hopes that it
; might be used for other GameBoy projects of mine.
;
;==============================================================================

.INCLUDE "gb_hardware.i"

.GBHEADER
    NAME "MUSIC DEMO"
    CARTRIDGETYPE $00	    ; RAM only
    RAMSIZE $00		    ; 32KByte, no ROM banking
    COUNTRYCODE $01	    ; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW "SV"
    ROMDMG		    ; DMG rom
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

LoadWaveform:
    ; hl    address to load from
    ld de, $FF30
    ld c, 16
-   ldi a, (hl)
    ld (de), a
    inc de
    dec c
    jp nz, -
    ret

LoadMusic:
    ; Loads music to play
    ; hl    address to load from

    ; load tempo
    ldi a, (hl)
    ld (MusicTicks), a

    ; load instruments/voices
    ; voice 1
    ld de, MusicVoices
.REPEAT 3
    ld bc, Instruments
    ldi a, (hl)
    add a		    ; 2 bytes for instruments/voices
    add c
    ld c, a
    jr nc, +
    inc b		    ; carry just in case
+   ld a, (bc)
    ld (de), a
    inc bc
    inc de
    ld a, (bc)
    ld (de), a
    inc de
.ENDR

    ; load pointers to channels
    ld c, $00
    ld de, MusicPointer
-   ldi a, (hl)		    ; lsb
    ld (de), a
    inc de
    ldi a, (hl)		    ; msb
    ld (de), a
    inc de
    inc c
    ld a, MusicChannels
    cp c
    jp nz, -
    ret

UpdateMusic:
    ; check to see update is needed (counter will equal ticks)
    ld a, (MusicTicks)
    ld b, a
    ld a, (MusicCounter)
    inc a
    cp b
    ld (MusicCounter), a
    ret nz			; no update needed
    xor a			; zero music counter, will do an update
    ld (MusicCounter), a
    
    ld c, 0			; start with channel 0
    ld b, 0
@readSongData:
    ; load first song byte
    ld hl, MusicPointer
    add hl, bc			; channel offset
    add hl, bc
    ldi a, (hl)			; lower byte of music pointer
    ld e, a
    ld a, (hl)			; upper byte of music pointer
    ld d, a
    ld a, (de)			; get next music byte

    ; Check for various commands and special cases
    cp $00			; if the next byte $00...
    jp z, @nextChannel		; ...means score is done
    cp $F0
    jr z, @tempoCmd
    cp $F1
    jr z, @loopCmd
    cp $F2
    jr z, @ChVoiceCmd
    jr @notCmd

@tempoCmd:
    ld hl, MusicPointer		; load MusicPointer
    add hl, bc			; x2 since 2 bytes long
    add hl, bc
    ldi a, (hl)
    ld e, a
    ldd a, (hl)			; decrement to go back for when storing again
    ld d, a
    inc de
    ld a, (de)
    inc de
    ld (MusicTicks), a		; set new frame ticks limit/tempo
    ld a, e
    ldi (hl), a
    ld a, d
    ld (hl), a
    jp @readSongData

@loopCmd:			; ...loop back by moving the pointer
    ld hl, MusicPointer		; load MusicPointer
    add hl, bc			; channel offset
    add hl, bc
    ldi a, (hl)
    ld e, a
    ldd a, (hl)			; decrement to go back for when storing again
    ld d, a
    inc de
    ld a, (de)			; load loop argument
    dec de
-   dec de
    dec a
    jp nz, -
    ld a, e
    ldi (hl), a
    ld a, d
    ld (hl), a
    jp @readSongData

@ChVoiceCmd:			; edit the channel's MusicVoice data
    ; load music pointer and increment it
    ld hl, MusicPointer
    add hl, bc			; x2 since 2byte len for pointer
    add hl, bc
    ldi a, (hl)
    ld e, a
    ldd a, (hl)
    ld d, a
    inc de
    ld a, (de)			; load argument
    push de			; store MusicPointer value for later
    ld e, a
    xor a
    ld d, a
    ; add argument to Instruments to get instrument
    ld hl, Instruments
    add hl, de
    ; add channel offset (c) to MusicVoices to get destination
    ld de, MusicVoices
    ld a, c
    add e
    jr nc, +			; handle carry to d
    inc d
+   ld e, a
    ldi a, (hl)			; move instrument to destination (2 bytes)
    ld (de), a
    inc de
    ld a, (hl)
    ld (de), a
    pop de			; retrieve MusicPointer value
    ld hl, MusicPointer
    add hl, bc
    add hl, bc
    inc de			; advance it
    ld a, e
    ldi (hl), a
    ld a, d
    ld (hl), a			; store it back
    jp @readSongData

@notCmd:
    ld d, a
    and $F0
    cp $70
    jp nz, @notrest

    ; it's a rest
    ld a, d
    and $0F
    dec a
    ld hl, MusicTimers
    add hl, bc			; channel offset
    ld (hl), a			; set the timer
    jp @end


@notrest:
    ld hl, MusicTimers
    add hl, bc
    ld a, (hl)			; is there a counter?
    cp $00
    jp z, @note
    dec a			; lower counter
    ld (hl), a
    jp @nextChannel		; and skip this music update

@note:
    ld a, $03			; will skip freq if noise channel
    cp c
    jr z, @handleCh3

    ld a, d
    ; it's note
    and $0F			; just note

    dec a			; entry 0 in LUT is C
    add a			; pitch LUT is 2 bytes/ entry
    ld hl, Pitches
    add l
    ld l, a
    ldi a, (hl)			; get pitch value
    ld e, a
    ld a, (hl)
    ld b, a

    ; divide to get octave
    ld a, d
    and $F0			; just octave
    swap a
-   cp $00
    jp z, +
    sra b
    rr e
    dec a
    jp -

+
    ; handle note based on channel number
    ld a, $00
    cp c
    jp z, @handleCh0
    ld a, $01
    cp c
    jp z, @handleCh1
    ld a, $02
    cp c
    jp z, @handleCh2
    jp @end			; if no handler, ignore it

@handleCh0:
    ld a, (MusicVoices + 0)
    ldh (R_NR11), a
    ld a, (MusicVoices + 1)
    ldh (R_NR12), a
    ld a, e
    ldh (R_NR13), a
    ld a, %00000111		; high 3 bit freq mask
    and b
    add %11000000		; high bits to restart sound
    ldh (R_NR14), a
    jr @end

@handleCh1:
    ld a, (MusicVoices + 2)
    ldh (R_NR21), a
    ld a, (MusicVoices + 3)
    ldh (R_NR22), a
    ld a, e
    ldh (R_NR23), a
    ld a, %00000111		; high 3 bit freq mask
    and b
    add %11000000		; high bits to restart sound
    ldh (R_NR24), a
    jr @end

@handleCh2:
    ld a, %10000000
    ldh (R_NR30), a
    ld a, (MusicVoices + 4)
    ldh (R_NR31), a
    ld a, (MusicVoices + 5)
    ldh (R_NR32), a
    ld a, e
    ldh (R_NR33), a
    ld a, %00000111
    and b
    add %11000000
    ldh (R_NR34), a
    jr @end

@handleCh3:
    ld hl, NoiseSamples
    ld e, d
    ld d, 0
    dec e 
    srl d
    rl e
    add hl, de
    ldi a, (hl)
    ldh (R_NR42), a
    ld a, (hl)
    ldh (R_NR43), a
    ld a, %11000000
    ldh (R_NR44), a

@end:
    ld b, 0
    ld hl, MusicPointer
    add hl, bc
    add hl, bc
    ldi a, (hl)
    ld e, a
    ldd a, (hl)			; decrement hl for later storing music pointer
    ld d, a
    inc de			; increment music pointer
    ld a, e			; lower byte
    ldi (hl), a
    ld a, d			; upper byte
    ld (hl), a

@nextChannel:
    inc c
    ld a, MusicChannels
    cp c			; done with all channels?
    jp nz, @readSongData
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
