;==============================================================================
; Strings
;==============================================================================

.INCLUDE "header.i"

.DEFINE numberOffset	$80
.DEFINE alphaOffset	numberOffset+11
.EXPORT numberOffset, alphaOffset

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

TextMainMenu1:
.ASC "NEW GAME@"
TextMainMenu2:
.ASC "OPTIONS@"

TextOptions0:
.ASC "SOUND@"
TextOptions1:
.ASC "EXIT@"

TextGameSelect0:
.ASC "BEST OUT OF@"
TextGameSelect1:
.ASC "1 GAME@"
TextGameSelect2:
.ASC "3 GAMES@"
TextGameSelect3:
.ASC "5 GAMES@"

TextPause0:
.ASC "PAUSE@"
TextPause1:
.ASC "CONTINUE@"
TextPause2:
.ASC "QUIT@"

TextRoundWon:
.ASC "ROUND WON@"
TextRoundLost:
.ASC "ROUND LOST@"
TextRoundTied:
.ASC "ROUND TIED@"

Credits1a:
.ASC "CODE  ART  MUSIC@"
Credits1b:
.ASC "SAM@"
Credits2a:
.ASC "CONCEPT ART@"
Credits2b:
.ASC "HEIDI@"

.ENDS

; vim: filetype=wla
