
;==============================================================================
; GRAPHICS
;==============================================================================

.INCLUDE "header.i"


.SECTION "Graphics" FREE

Tiles:
.INCBIN "numbers.bin"	FSIZE size_of_numbers
.INCBIN "alphas.bin"	FSIZE size_of_alphas
.INCLUDE "menutiles.i"


.INCLUDE "turt.i"
.INCLUDE "shell.i"
.INCLUDE "ox.i"
.INCLUDE "cursor.i"

.DEFINE TileCount	size_of_numbers + size_of_alphas + menutiles_count
.EXPORT TileCount

.ENDS

; vim: filetype=wla
