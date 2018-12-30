; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: turt.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

.DEFINE turt_tile_map_size  $0168
.DEFINE turt_tile_map_width  $14
.DEFINE turt_tile_map_height  $12

.DEFINE turt_tile_data_size  $07D0
.DEFINE turt_tile_count  $7D

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

turt_map_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$01,$02,$03,$04,$00,$00,$05,$06,$07,$08,$09,$0A,$0B,$00
.DB $00,$00,$00,$00,$00,$0C,$0D,$0E,$0F,$10,$00,$11,$12,$13,$14,$15
.DB $0F,$16,$17,$18,$00,$00,$00,$00,$00,$19,$1A,$1B,$1C,$1D,$1E,$1F
.DB $20,$21,$22,$23,$24,$25,$0F,$26,$27,$00,$00,$00,$00,$28,$29,$2A
.DB $2B,$2C,$2D,$2E,$2F,$30,$0F,$0F,$31,$32,$33,$34,$35,$00,$00,$00
.DB $00,$00,$00,$00,$36,$37,$38,$0F,$39,$3A,$3B,$3C,$3D,$3E,$3F,$0F
.DB $40,$41,$00,$00,$00,$00,$00,$00,$42,$43,$44,$45,$46,$47,$48,$49
.DB $4A,$4B,$0F,$0F,$4C,$4D,$4E,$00,$00,$00,$00,$00,$4F,$50,$51,$0F
.DB $0F,$52,$0F,$0F,$0F,$53,$54,$55,$56,$57,$58,$00,$00,$00,$00,$00
.DB $59,$5A,$5B,$5C,$5D,$5E,$5F,$60,$60,$61,$62,$63,$64,$65,$66,$00
.DB $00,$00,$00,$00,$67,$68,$69,$00,$00,$00,$00,$00,$00,$6A,$6B,$6C
.DB $00,$00,$6D,$00,$00,$00,$00,$6E,$6F,$70,$00,$00,$00,$00,$00,$00
.DB $00,$71,$72,$73,$74,$00,$00,$00,$00,$00,$00,$75,$76,$77,$00,$00
.DB $00,$00,$00,$00,$00,$00,$78,$79,$7A,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7B,$7C,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

turt_tile_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$03,$03,$07,$07
.DB $00,$00,$00,$00,$07,$07,$3F,$3F,$7F,$7F,$FF,$FC,$FF,$E0,$FF,$80
.DB $00,$00,$78,$78,$FE,$FE,$FF,$FF,$FF,$CF,$FF,$03,$FF,$00,$FF,$00
.DB $00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0,$E0,$E0,$F0,$F0,$F0,$70
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$0F,$0F
.DB $00,$00,$00,$00,$00,$00,$07,$07,$1F,$1F,$7F,$7F,$FF,$FC,$EF,$F0
.DB $00,$00,$00,$00,$3F,$3F,$FF,$FF,$FF,$FF,$FF,$E0,$FF,$00,$FF,$00
.DB $00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$FF,$00,$FF,$00
.DB $00,$00,$00,$00,$C0,$C0,$FE,$FE,$FF,$FF,$FF,$7F,$FF,$03,$FF,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$F8,$F8,$FF,$FF,$FF,$FF,$FF,$0F
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0,$F0,$F0
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$03,$03,$03,$03
.DB $0F,$0F,$1F,$1E,$3F,$3C,$7F,$78,$FF,$F0,$FF,$E0,$FF,$C0,$FF,$80
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FB,$07,$FF,$0F,$FF,$0F,$FD,$0E
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $F8,$78,$F8,$38,$F8,$38,$DC,$3C,$DC,$3C,$FC,$1C,$FC,$1C,$FC,$1C
.DB $00,$00,$00,$00,$01,$01,$03,$03,$07,$07,$1F,$1F,$3F,$3E,$7F,$78
.DB $3F,$3F,$7F,$7E,$FF,$F8,$FF,$F0,$FF,$C0,$FF,$00,$FF,$00,$FF,$00
.DB $8F,$F0,$CF,$30,$C7,$38,$C7,$38,$C3,$3C,$C1,$3E,$C0,$3F,$80,$7F
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$3F,$C0,$00,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$7F,$80
.DB $FD,$03,$FC,$03,$FC,$03,$F0,$0F,$F0,$0F,$F1,$0E,$E1,$1E,$E3,$1C
.DB $FC,$FC,$7F,$FF,$FF,$1F,$FF,$07,$FF,$01,$FF,$00,$FF,$00,$FF,$00
.DB $00,$00,$00,$00,$80,$80,$C0,$C0,$F0,$F0,$F8,$F8,$FC,$3C,$FE,$1E
.DB $07,$07,$0F,$0F,$0F,$0E,$1F,$1E,$1F,$1C,$3F,$3C,$3F,$38,$3F,$38
.DB $FF,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$01
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$10,$FF,$38,$FF,$78,$FF,$F0,$FF,$E0
.DB $FC,$1C,$FC,$1C,$FE,$1E,$FE,$1E,$EE,$1E,$EE,$1E,$FE,$0E,$FE,$0E
.DB $00,$00,$01,$01,$03,$03,$07,$07,$07,$07,$0F,$0F,$0E,$0F,$1C,$1F
.DB $FF,$F0,$FF,$E0,$FF,$C0,$FF,$80,$FF,$00,$7F,$80,$3F,$C0,$00,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FE,$01,$FC,$03,$F0,$0F,$C0,$3F,$00,$FF
.DB $80,$7F,$87,$78,$0F,$F0,$3F,$C0,$3F,$C0,$7F,$80,$7F,$80,$FF,$00
.DB $00,$FF,$FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$E0,$1F,$FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$E0,$1F,$F0,$0F,$FC,$03,$FE,$01
.DB $03,$FC,$0F,$F0,$1F,$E0,$1F,$E0,$1F,$E0,$1F,$E0,$0F,$F0,$03,$FC
.DB $FF,$0F,$FF,$07,$FF,$03,$FF,$01,$FF,$01,$FF,$00,$FF,$00,$FF,$00
.DB $00,$00,$80,$80,$C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0,$F0,$F0,$F0,$70
.DB $3F,$38,$3F,$38,$3F,$3C,$1F,$1F,$0F,$0F,$07,$07,$00,$00,$00,$00
.DB $FF,$00,$FF,$00,$FF,$03,$FF,$FF,$FF,$FF,$FE,$FE,$00,$00,$00,$00
.DB $FF,$07,$FF,$3F,$FF,$FF,$FF,$FF,$C3,$C3,$03,$03,$01,$01,$00,$00
.DB $FF,$C0,$BF,$C0,$7F,$80,$7F,$80,$FF,$80,$FF,$C0,$FF,$C0,$FF,$E0
.DB $FE,$0E,$FE,$0E,$FE,$0E,$FE,$0E,$FE,$0E,$FE,$0E,$FE,$0E,$FE,$0E
.DB $1C,$1F,$3C,$3F,$38,$3F,$78,$7F,$71,$7E,$73,$7C,$73,$7C,$F7,$F8
.DB $00,$FF,$00,$FF,$3F,$C0,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$C0,$3F,$F8,$07,$FC,$03,$FC,$03,$FE,$01,$FE,$01
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$7F,$80,$3F,$C0,$3F,$C0,$1F,$E0
.DB $FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $03,$FC,$01,$FE,$81,$7E,$C0,$3F,$E0,$1F,$F0,$0F,$F0,$0F,$F0,$0F
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$3F,$C0,$00,$FF,$00,$FF,$00,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$00,$FF,$00,$FF,$00,$FF
.DB $F8,$78,$F8,$38,$F8,$38,$FC,$1C,$9C,$7C,$1C,$FC,$1E,$FE,$0E,$FE
.DB $FF,$E0,$7F,$70,$7F,$78,$3F,$38,$3F,$38,$1F,$1C,$1F,$1E,$0F,$0F
.DB $FF,$0F,$F7,$0F,$FB,$07,$FB,$07,$F9,$07,$FF,$0F,$FF,$7F,$FE,$FF
.DB $EF,$F0,$EF,$F0,$CF,$F0,$DF,$E0,$9F,$E0,$BF,$C0,$3F,$C0,$7F,$80
.DB $FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FE,$01
.DB $1F,$E0,$0F,$F0,$0F,$F0,$0F,$F0,$0F,$F0,$07,$F8,$03,$FC,$01,$FE
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FE,$01
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$F0,$0F,$00,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$E0,$1F,$80,$7F,$00,$FF,$00,$FF
.DB $E0,$1F,$E0,$1F,$E0,$1F,$C0,$3F,$00,$FF,$01,$FE,$03,$FC,$03,$FC
.DB $03,$FC,$1F,$E0,$7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $0E,$FE,$8F,$7F,$C7,$3F,$E7,$1F,$E7,$1F,$F3,$0F,$F3,$0F,$FB,$07
.DB $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$C0,$C0
.DB $0F,$0F,$1F,$1F,$3E,$3F,$78,$7F,$71,$7E,$73,$7C,$73,$7C,$79,$7E
.DB $F8,$FF,$C0,$FF,$1C,$E3,$FC,$03,$FE,$01,$FE,$01,$FF,$00,$FF,$00
.DB $FF,$00,$FF,$00,$7F,$80,$7F,$80,$3F,$C0,$1E,$E1,$00,$FF,$00,$FF
.DB $FF,$00,$FF,$00,$FE,$01,$F0,$0F,$C0,$3F,$01,$FE,$0F,$F0,$3F,$C0
.DB $FC,$03,$E0,$1F,$00,$FF,$00,$FF,$FE,$01,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$C1,$3E,$C1,$3E,$E1,$1E
.DB $00,$FF,$00,$FF,$00,$FF,$00,$FF,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$03,$FC,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $00,$FF,$00,$FF,$FC,$03,$FE,$01,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $07,$F8,$07,$F8,$0F,$F0,$0F,$F0,$07,$F8,$83,$7C,$C1,$3E,$C0,$3F
.DB $F9,$07,$FC,$03,$FC,$03,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $C0,$C0,$E0,$E0,$F8,$F8,$7C,$FC,$FE,$3E,$CF,$3F,$E3,$1F,$E3,$1F
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$C0,$C0
.DB $39,$3E,$3C,$3F,$1E,$1F,$0F,$0F,$07,$07,$03,$03,$01,$01,$00,$00
.DB $FF,$00,$FF,$00,$7E,$81,$3E,$C1,$8C,$F3,$E0,$FF,$F8,$FF,$FC,$FF
.DB $03,$FC,$0F,$F0,$1F,$E0,$3F,$C0,$7F,$80,$7F,$80,$3F,$C0,$03,$FC
.DB $E3,$1C,$E3,$1C,$E3,$1C,$C3,$3C,$C3,$3C,$C3,$3C,$C3,$3C,$C7,$38
.DB $F0,$0F,$FC,$03,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $1F,$E0,$03,$FC,$01,$FE,$80,$7F,$C0,$3F,$E0,$1F,$E0,$1F,$F0,$0F
.DB $FF,$00,$FF,$00,$FF,$00,$7F,$80,$3F,$C0,$07,$F8,$00,$FF,$00,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$FC,$03,$E0,$1F,$00,$FF,$00,$FF
.DB $E1,$1F,$E1,$1F,$C1,$3F,$01,$FF,$03,$FF,$0F,$FF,$1F,$FF,$FE,$FF
.DB $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$E0,$E0,$E0,$E0,$60,$E0
.DB $00,$00,$00,$00,$00,$00,$01,$01,$03,$03,$03,$03,$07,$07,$0F,$0F
.DB $3F,$3F,$7F,$7F,$FB,$FF,$F0,$FF,$DC,$E3,$FE,$81,$FF,$80,$FE,$01
.DB $80,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$07,$FF,$1F,$FF,$3E,$FE,$FC,$FC
.DB $3F,$C0,$01,$FE,$E0,$FF,$FE,$FF,$FF,$FF,$3F,$3F,$03,$03,$00,$00
.DB $FF,$00,$FF,$00,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00
.DB $87,$78,$07,$F8,$03,$FC,$00,$FF,$F0,$FF,$FF,$FF,$FF,$FF,$1F,$1F
.DB $FF,$00,$FF,$00,$FF,$00,$7F,$80,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $FF,$00,$FF,$00,$FF,$00,$00,$FF,$03,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $F0,$0F,$C0,$3F,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$80,$FF
.DB $00,$FF,$00,$FF,$03,$FF,$3F,$FF,$FF,$FF,$FE,$FE,$DC,$FC,$3C,$FC
.DB $07,$FF,$3F,$FF,$FF,$FF,$F8,$F8,$E0,$E0,$00,$00,$00,$00,$00,$00
.DB $FC,$FF,$F9,$FE,$BF,$BC,$0F,$0F,$03,$03,$01,$01,$00,$00,$00,$00
.DB $E0,$60,$F0,$70,$F0,$30,$F0,$30,$F0,$90,$F8,$D8,$F8,$F8,$38,$38
.DB $0F,$0E,$1F,$1E,$1F,$1C,$3F,$38,$3F,$38,$7F,$78,$7F,$70,$7F,$70
.DB $FF,$03,$FF,$07,$FF,$0F,$FE,$1E,$FC,$3C,$FC,$3C,$F8,$78,$F8,$78
.DB $F0,$F0,$C0,$C0,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $03,$03,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
.DB $80,$FF,$BF,$C0,$7F,$80,$7F,$80,$FF,$00,$FF,$00,$FF,$00,$FF,$00
.DB $38,$F8,$78,$F8,$F0,$70,$F0,$70,$F0,$70,$F0,$70,$F0,$70,$F8,$78
.DB $10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$07,$07,$0F,$0F,$1F,$1F
.DB $7F,$70,$FF,$F0,$FF,$E0,$FF,$E0,$FF,$C0,$FF,$C0,$FF,$80,$FF,$01
.DB $F0,$70,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$E0,$E0,$E0,$E0,$E0,$E0
.DB $03,$03,$03,$03,$01,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00
.DB $FF,$80,$FF,$80,$FF,$C0,$FF,$E0,$FF,$F0,$7F,$78,$3F,$3C,$1F,$1E
.DB $FC,$3C,$FF,$1F,$FF,$0F,$FF,$03,$FF,$01,$FF,$00,$FF,$00,$FF,$00
.DB $00,$00,$00,$00,$80,$80,$E0,$E0,$F0,$F0,$F8,$F8,$FC,$3C,$FC,$1C
.DB $3F,$3C,$7F,$78,$7F,$70,$7F,$7C,$3F,$3F,$1F,$1F,$07,$07,$00,$00
.DB $FF,$01,$FF,$01,$FF,$01,$FF,$03,$FF,$FF,$FF,$FF,$FC,$FC,$00,$00
.DB $E0,$E0,$C0,$C0,$C0,$C0,$C0,$C0,$80,$80,$00,$00,$00,$00,$00,$00
.DB $0F,$0F,$07,$07,$03,$03,$01,$01,$01,$01,$01,$01,$03,$03,$03,$03
.DB $FF,$00,$FF,$80,$FF,$C0,$FF,$C0,$FF,$C1,$FF,$C3,$FF,$C7,$FF,$9F
.DB $FC,$1C,$FC,$3C,$F8,$78,$F0,$70,$E0,$E0,$C0,$C0,$80,$80,$00,$00
.DB $03,$03,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $FE,$FE,$FC,$FC,$F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
