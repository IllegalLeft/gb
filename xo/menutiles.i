; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////
.DEFINE menutiles_count	    13*16
.EXPORT menutiles_count

menutiles_data:
menucursor_data:
.DB $C0,$C0,$F0,$F0,$FC,$FC,$FF,$FF
.DB $FF,$FF,$FC,$FC,$F0,$F0,$C0,$C0

.DB $3F,$7F,$7F,$FF,$D8,$E0,$E0,$C0
.DB $E0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
.DB $FC,$FE,$FE,$FF,$1B,$07,$07,$03
.DB $07,$03,$03,$03,$03,$03,$03,$03
.DB $03,$03,$03,$03,$03,$03,$07,$03
.DB $07,$03,$1B,$07,$FE,$FF,$FC,$FE
.DB $C0,$C0,$C0,$C0,$C0,$C0,$E0,$C0
.DB $E0,$C0,$D8,$E0,$7F,$FF,$3F,$7F
.DB $FF,$FF,$FF,$FF,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00
.DB $03,$03,$03,$03,$03,$03,$03,$03
.DB $03,$03,$03,$03,$03,$03,$03,$03
.DB $00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$FF,$FF,$FF,$FF
.DB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
.DB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0

.DB $0F,$00,$0F,$00,$0F,$00,$0F,$00
.DB $F0,$00,$F0,$00,$F0,$00,$F0,$00
.DB $E1,$00,$1E,$00,$1E,$00,$1E,$00
.DB $1E,$00,$E1,$00,$E1,$00,$E1,$00
.DB $C3,$00,$C3,$00,$3C,$00,$3C,$00
.DB $3C,$00,$3C,$00,$C3,$00,$C3,$00
.DB $87,$00,$87,$00,$87,$00,$78,$00
.DB $78,$00,$78,$00,$78,$00,$87,$00

; vim: filetype=wla
