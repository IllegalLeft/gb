; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

;.DEFINE font_tombi_tile_data_size  $04B0
.DEFINE font_tombi_tile_count	27
.DEFINE font_tombi_tile_data_size  $01B0
.EXPORT font_tombi_tile_data_size, font_tombi_tile_count

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

font_tombi_tile_data:
.DB $FF,$FF,$FF,$FF,$C7,$C7,$FB,$FB
.DB $C3,$C3,$BB,$BB,$C1,$C1,$FF,$FF
.DB $FF,$FF,$BF,$BF,$BF,$BF,$83,$83
.DB $BD,$BD,$BD,$BD,$83,$83,$FF,$FF
.DB $FF,$FF,$FF,$FF,$C3,$C3,$BD,$BD
.DB $BF,$BF,$BD,$BD,$C3,$C3,$FF,$FF
.DB $FF,$FF,$FD,$FD,$FD,$FD,$C1,$C1
.DB $BD,$BD,$BD,$BD,$C1,$C1,$FF,$FF
.DB $FF,$FF,$FF,$FF,$C3,$C3,$BD,$BD
.DB $81,$81,$BF,$BF,$C1,$C1,$FF,$FF
.DB $FF,$FF,$E3,$E3,$DD,$DD,$DF,$DF
.DB $87,$87,$DF,$DF,$DF,$DF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$C1,$C1,$BD,$BD
.DB $BD,$BD,$C1,$C1,$FD,$FD,$83,$83
.DB $FF,$FF,$BF,$BF,$BF,$BF,$83,$83
.DB $BD,$BD,$BD,$BD,$BD,$BD,$FF,$FF
.DB $FF,$FF,$F7,$F7,$FF,$FF,$F7,$F7
.DB $F7,$F7,$F7,$F7,$F7,$F7,$FF,$FF
.DB $FF,$FF,$FB,$FB,$FF,$FF,$FB,$FB
.DB $FB,$FB,$FB,$FB,$BB,$BB,$C7,$C7
.DB $FF,$FF,$BF,$BF,$B9,$B9,$A7,$A7
.DB $9F,$9F,$A7,$A7,$B9,$B9,$FF,$FF
.DB $FF,$FF,$EF,$EF,$EF,$EF,$EF,$EF
.DB $EF,$EF,$EF,$EF,$EF,$EF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$FF,$81,$81
.DB $B6,$B6,$B6,$B6,$B6,$B6,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$FF,$83,$83
.DB $BD,$BD,$BD,$BD,$BD,$BD,$FF,$FF
.DB $FF,$FF,$FF,$FF,$C3,$C3,$BD,$BD
.DB $BD,$BD,$BD,$BD,$C3,$C3,$FF,$FF
.DB $FF,$FF,$FF,$FF,$83,$83,$BD,$BD
.DB $BD,$BD,$83,$83,$BF,$BF,$BF,$BF
.DB $FF,$FF,$FF,$FF,$C3,$C3,$BB,$BB
.DB $BB,$BB,$C3,$C3,$FA,$FA,$F9,$F9
.DB $FF,$FF,$FF,$FF,$B1,$B1,$AF,$AF
.DB $9F,$9F,$BF,$BF,$BF,$BF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$C3,$C3,$BF,$BF
.DB $C3,$C3,$FD,$FD,$83,$83,$FF,$FF
.DB $FF,$FF,$EF,$EF,$83,$83,$EF,$EF
.DB $EF,$EF,$EF,$EF,$F3,$F3,$FF,$FF
.DB $FF,$FF,$FF,$FF,$BD,$BD,$BD,$BD
.DB $BD,$BD,$BD,$BD,$C1,$C1,$FF,$FF
.DB $FF,$FF,$FF,$FF,$BD,$BD,$BD,$BD
.DB $DB,$DB,$DB,$DB,$E7,$E7,$FF,$FF
.DB $FF,$FF,$FF,$FF,$BE,$BE,$BE,$BE
.DB $B6,$B6,$AA,$AA,$DD,$DD,$FF,$FF
.DB $FF,$FF,$FF,$FF,$BD,$BD,$DB,$DB
.DB $E7,$E7,$DB,$DB,$BD,$BD,$FF,$FF
.DB $FF,$FF,$FF,$FF,$BD,$BD,$BD,$BD
.DB $BD,$BD,$C1,$C1,$FD,$FD,$83,$83
.DB $FF,$FF,$FF,$FF,$81,$81,$FB,$FB
.DB $E7,$E7,$DF,$DF,$81,$81,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

; vim: filetype=wla
