
;==============================================================================
;
; MUSIC.S
; 
; Samuel Volk, March 2019
;
;==============================================================================

.INCLUDE "gb_hardware.i"
.INCLUDE "header.i"

;==============================================================================
; WRAM DEFINITIONS
;==============================================================================

.RAMSECTION "MusicVars" SLOT 2 ; Internal WRAM
    MusicTicks:		db
    MusicTickLimit:	db
    MusicPointer:	dsw 4
    MusicTimers:	ds  4
    MusicVoices:	dsw 3
.ENDS

.DEF MusicChannels  4	    ; total number of music channels

;==============================================================================
; SUBROUTINES
;==============================================================================
.BANK 0
.SECTION "MusicSubroutines" FREE

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
    ld (MusicTickLimit), a

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
    ld a, (MusicTickLimit)
    ld b, a
    ld a, (MusicTicks)
    inc a
    cp b
    ld (MusicTicks), a
    ret nz			; no update needed
    xor a			; zero music counter, will do an update
    ld (MusicTicks), a
    
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
    jr @checkRest

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
    ld (MusicTickLimit), a		; set new frame ticks limit/tempo
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

@checkRest:
    ld d, a
    and $F0
    cp $70
    jp nz, @checkTimer

    ; it's a rest
    ld a, d
    and $0F
    dec a
    ld d, a

    ld hl, MusicTimers
    add hl, bc			; channel offset
    ld a, (hl)			; pull current timer
    add d
    ld (hl), a			; set the timer
    jp @end


@checkTimer:
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

.SECTION "AudioConstants" FREE
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
.ENDS

; vim: filetype=wla
