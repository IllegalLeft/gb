
;==============================================================================
; WRAM
;==============================================================================


.ENUM $C000 EXPORT
    vbcounter:	    DB		; counter for vblank
    state:	    DB		; 0 main menu, 1 xturn, 2 oturn, 3 end game
    games:	    DB		; total games
    gamesplayed:    DB
    initiator:	    DB		; holds player who started last
    won:	    DB
    lost:	    DB
    tied:	    DB
    menucursor:	    DB		; line of menu cursor is on (0-n)
    cursorx:	    DB		; 0-2
    cursory:	    DB		; 0-2
    field:	    DS 9	; field is 3x3, 0 empty, 1 x, 2 o
    seed:	    DB		; seed for random integer generator
    menubgtile:	    DB		; tile index for menu bg tile
.ENDE
.DEFINE OAMbuffer $C100 EXPORT
.STRUCT OAMentry
    y		DB
    x		DB
    tile	DB
    attr	DB
.ENDST
.ENUM OAMbuffer EXPORT
    OAM:	INSTANCEOF OAMentry 40
.ENDE
.ENUM $C200 EXPORT
    tilemapbuff	DS	20*18	; tilemap buffer
.ENDE


; vim: filetype=wla
