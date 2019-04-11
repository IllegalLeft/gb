.INCLUDE "header.i"

.SECTION "MusicData" FREE

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

SongTitle:
    .DB 5	    ; tempo
    .DB 0, 0, 1	    ; instruments/voices
    .DW SongTitleCh0, SongTitleCh1, SongTitleCh2, SongTitleCh3
SongTitleCh0:
    .DB 0
    .DB $78, $3A, $7F
    .DB $F1, 2
    .DB 0
SongTitleCh1:
    .DB $37, $73, $3A, $71, $35, $79
    .DB $74, $3A, $75, $37, $75
    .DB $F1, 11
    .DB 0
SongTitleCh2:
    .DB $1A, $73, $1A, $77, $22, $73
    .DB $1C, $73, $1C, $77, $1C, $73
    .DB $F1, 12
    .DB 0
SongTitleCh3:
    .DB 1, $73
    .DB 3, $73
    .DB 2, $73
    .DB 3, $71
    .DB 3, $71
    .DB 1, $73
    .DB 3, $73
    .DB 2, $71
    .DB 3, $71
    .DB 3, $73
    .DB $F1, 20
    .DB 0

.ENDS

; vim: filetype=wla
