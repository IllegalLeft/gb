;==============================================================================
; Strings
;==============================================================================

.INCLUDE "header.i"

.DEFINE numberOffset	$80
.DEFINE alphaOffset	numberOffset+11

.ASCIITABLE
    MAP "0" TO "9" = numberOffset
    MAP "A" TO "Z" = alphaOffset
    MAP " " = $8A
    MAP "@" = $00
.ENDA


.SECTION "Strings" FREE

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
