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
