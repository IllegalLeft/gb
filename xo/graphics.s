
;==============================================================================
; GRAPHICS
;==============================================================================

.INCLUDE "header.i"

.SECTION "Graphics" FREE

Tiles:
.INCBIN "numbers.bin"	FSIZE size_of_numbers
.INCBIN "alphas.bin"	FSIZE size_of_alphas
menucursor_data:
.DB $C0,$C0,$F0,$F0,$FC,$FC,$FF,$FF
.DB $FF,$FF,$FC,$FC,$F0,$F0,$C0,$C0


.INCLUDE "turt.i"
.INCLUDE "shell.i"
.INCLUDE "ox.i"
.INCLUDE "cursor.i"

.DEFINE TileCount	size_of_numbers + size_of_alphas
.EXPORT TileCount

.ENDS

; vim: filetype=wla
