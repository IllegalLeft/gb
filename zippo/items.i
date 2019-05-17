; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: items.png
; Pixel Width: 16px
; Pixel Height: 64px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

.DEFINE items_tile_data_size  $0100
.DEFINE items_tile_count  $10
.EXPORT items_tile_data_size, items_tile_count

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

items_tile_data:
.DB $FF,$FF,$FF,$FF,$FF,$C0,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF
.DB $FF,$FF,$FF,$FF,$FF,$03,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB
.DB $FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$C0,$FF,$FF,$FF,$FF
.DB $FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$03,$FF,$FF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$C0,$FF,$DF,$F0,$D0,$F7,$D7,$F7,$D0,$FF,$D7
.DB $FF,$FF,$FF,$FF,$FF,$03,$FF,$FB,$0F,$0B,$EF,$EB,$EF,$0B,$FF,$EB
.DB $F7,$DB,$F3,$D8,$F0,$DA,$F0,$DA,$F8,$DF,$FF,$C0,$FF,$FF,$FF,$FF
.DB $EF,$DB,$CF,$1B,$0F,$5B,$0F,$5B,$1F,$FB,$FF,$03,$FF,$FF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$C0,$FF,$DF,$FF,$DE,$FE,$D8,$FC,$D8,$F8,$D0
.DB $FF,$FF,$FF,$FF,$FF,$03,$FF,$FB,$FF,$3B,$3F,$1B,$1F,$0B,$1F,$0B
.DB $FC,$D8,$FC,$D8,$F3,$DC,$E7,$DB,$EF,$D7,$FF,$C0,$FF,$FF,$FF,$FF
.DB $1F,$0B,$1F,$0B,$7F,$1B,$FF,$7B,$FF,$FB,$FF,$03,$FF,$FF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$C0,$FF,$DF,$E7,$C7,$E1,$C1,$E0,$CC,$E0,$C2
.DB $FF,$FF,$FF,$FF,$FF,$03,$FF,$FB,$E7,$E3,$87,$83,$87,$1B,$87,$23
.DB $E0,$C0,$E0,$CC,$E0,$C2,$E0,$CC,$E0,$C2,$FF,$C0,$FF,$FF,$FF,$FF
.DB $87,$1B,$87,$23,$87,$03,$87,$1B,$87,$23,$FF,$03,$FF,$FF,$FF,$FF

; vim: filetype=wla
