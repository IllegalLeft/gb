.RAMSECTION "Map Variables" BANK 0 SLOT 2

mapx        DB      ; no scroll for x
mapxpix     DB
mapy        DB      ; where the player is at, in accordance with the map
mapypix     DB      ; pixel counter for calculating when need to inc/dec mapy

drawline        DB  ; 1 = above, 2 = below
linevramaddr    DW  ; vram addr for line to draw during vblank
linemapaddr     DW  ; map addr for line to draw during vblank

.ENDS

; vim: filetype=wla
