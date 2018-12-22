; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: ox.png
; Pixel Width: 16px
; Pixel Height: 32px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

.DEFINE ox_tile_data_size  $80
.DEFINE ox_tile_count  $08

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

ox_tile_data:
empty_tile_data:
.DB $7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00 ;
.DB $FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$7F,$80
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FE,$01
o_tile_data:
.DB $7F,$80,$FC,$00,$F0,$00,$E1,$00,$C7,$00,$CF,$00,$8F,$00,$9F,$00
.DB $FE,$01,$3F,$00,$0F,$00,$87,$00,$E3,$00,$F3,$00,$F1,$00,$F9,$00
.DB $9F,$00,$8F,$00,$CF,$00,$C7,$00,$E1,$00,$F0,$00,$FC,$00,$7F,$80
.DB $F9,$00,$F1,$00,$F3,$00,$E3,$00,$87,$00,$0F,$00,$3F,$00,$FE,$01
x_tile_data:
.DB $7F,$80,$FF,$20,$FF,$70,$FF,$38,$FF,$1C,$FF,$0E,$FF,$07,$FF,$03
.DB $FE,$01,$FF,$04,$FF,$0E,$FF,$1C,$FF,$38,$FF,$70,$FF,$E0,$FF,$C0
.DB $FF,$03,$FF,$07,$FF,$0E,$FF,$1C,$FF,$38,$FF,$70,$FF,$20,$7F,$80
.DB $FF,$C0,$FF,$E0,$FF,$70,$FF,$38,$FF,$1C,$FF,$0E,$FF,$04,$FE,$01
