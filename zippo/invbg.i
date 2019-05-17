; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: invbg.png
; Pixel Width: 160px
; Pixel Height: 144px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

.DEFINE invbg_tile_map_size  $0168
.DEFINE invbg_tile_map_width  $14
.DEFINE invbg_tile_map_height  $12
.EXPORT invbg_tile_map_size, invbg_tile_map_width, invbg_tile_map_height

.DEFINE invbg_tile_data_size  $04B0
.DEFINE invbg_tile_count  $4B
.EXPORT invbg_tile_data_size, invbg_tile_count

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

invbg_map_data:
.DB $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
.DB $10,$11,$11,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D
.DB $1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D
.DB $2E,$2F,$30,$2A,$2B,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$11
.DB $11,$11,$11,$11,$11,$11,$39,$3A,$11,$11,$11,$11,$11,$11,$3B,$3C
.DB $3D,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$3E,$3F,$11,$11,$11,$11
.DB $11,$11,$11,$40,$41,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$39,$3A
.DB $11,$11,$11,$11,$11,$11,$11,$42,$43,$3E,$3F,$11,$11,$11,$11,$11
.DB $11,$11,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$44,$38,$39,$3A,$11
.DB $11,$11,$11,$11,$11,$11,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$40
.DB $3D,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$3E,$3F,$11,$11,$11,$11
.DB $11,$11,$11,$42,$41,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$39,$3A
.DB $11,$11,$11,$11,$11,$11,$11,$45,$38,$3E,$3F,$11,$11,$11,$11,$11
.DB $11,$11,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$45,$3D,$39,$3A,$11
.DB $11,$11,$11,$11,$11,$11,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$44
.DB $41,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$3E,$3F,$11,$11,$11,$11
.DB $11,$11,$11,$40,$43,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$39,$3A
.DB $11,$11,$11,$11,$11,$11,$11,$42,$43,$3E,$3F,$11,$11,$11,$11,$11
.DB $11,$11,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$44,$38,$39,$3A,$11
.DB $11,$11,$11,$11,$11,$11,$39,$3A,$11,$11,$11,$11,$11,$11,$11,$40
.DB $3D,$3E,$3F,$11,$11,$11,$11,$11,$11,$11,$3E,$3F,$11,$11,$11,$11
.DB $11,$11,$46,$47,$48,$49,$49,$49,$49,$49,$49,$49,$49,$49,$49,$49
.DB $49,$49,$49,$49,$49,$49,$49,$4A

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

invbg_tile_data:
.DB $FF,$FF,$E0,$E0,$CC,$C3,$D8,$C4,$DC,$C2,$DC,$C2,$DD,$C2,$DA,$C4
.DB $FF,$FF,$00,$00,$2F,$D0,$06,$29,$E4,$EA,$C1,$C5,$EC,$ED,$37,$2C
.DB $FF,$FF,$00,$00,$FF,$00,$44,$BB,$00,$6E,$60,$64,$EA,$E0,$EE,$6A
.DB $FF,$FF,$00,$00,$FF,$00,$C7,$38,$03,$C4,$D3,$D4,$EB,$AC,$E7,$88
.DB $FF,$FF,$7F,$70,$3E,$21,$BC,$22,$BC,$22,$BC,$22,$BC,$22,$BD,$22
.DB $FF,$FF,$FF,$00,$3F,$C0,$1F,$20,$CA,$F5,$60,$6A,$E6,$E6,$D9,$2E
.DB $FF,$FF,$FF,$00,$FF,$00,$3F,$C0,$09,$36,$A0,$A9,$75,$E5,$F2,$2D
.DB $FF,$FF,$FF,$00,$BF,$40,$18,$A7,$20,$B8,$1A,$1A,$9D,$B5,$5C,$B1
.DB $FF,$FF,$FF,$38,$FF,$10,$FE,$11,$7E,$91,$7D,$93,$7C,$92,$FD,$12
.DB $FF,$FF,$FF,$00,$0B,$F4,$11,$1A,$59,$5A,$B0,$31,$BB,$BB,$C7,$3B
.DB $FF,$FF,$FF,$00,$FB,$04,$F1,$0A,$11,$EA,$80,$91,$5B,$5B,$FF,$5B
.DB $FF,$FF,$FF,$00,$FF,$00,$F8,$07,$00,$F8,$5A,$5A,$5D,$55,$FC,$11
.DB $FF,$FF,$FF,$1C,$FF,$08,$FF,$08,$7F,$88,$7F,$88,$7F,$88,$FF,$08
.DB $FF,$FF,$FF,$00,$C5,$3A,$80,$45,$1D,$9D,$1D,$BD,$5D,$9D,$BF,$45
.DB $FF,$FF,$FF,$00,$FF,$00,$F9,$06,$10,$E9,$45,$55,$53,$57,$FF,$11
.DB $FF,$FF,$FF,$00,$FF,$00,$8F,$70,$07,$88,$A7,$A8,$D7,$58,$CF,$10
.DB $FF,$FF,$FF,$0F,$FF,$07,$FF,$07,$FF,$07,$FF,$07,$FF,$07,$FF,$07
.DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.DB $DC,$C3,$8F,$80,$80,$80,$00,$00,$00,$00,$00,$01,$00,$02,$02,$00
.DB $04,$FB,$FF,$00,$00,$00,$00,$00,$70,$F0,$08,$08,$F5,$65,$94,$95
.DB $00,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$00,$21
.DB $0F,$F0,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$20
.DB $BE,$21,$3F,$20,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$21
.DB $06,$F9,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $00,$FF,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$07,$1F,$1B,$32
.DB $01,$FE,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$FC,$FC,$F6,$E2
.DB $FE,$11,$FF,$10,$FF,$00,$00,$00,$00,$00,$00,$00,$80,$9F,$00,$90
.DB $30,$CF,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$00,$90
.DB $00,$FF,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$04,$00,$1F,$00,$84
.DB $01,$FE,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$21
.DB $FF,$08,$FF,$08,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $C4,$3B,$FF,$00,$FF,$00,$00,$00,$07,$0F,$00,$10,$0F,$2E,$29,$09
.DB $00,$FF,$FF,$00,$FF,$00,$00,$00,$00,$00,$80,$80,$50,$51,$40,$52
.DB $1F,$E0,$FF,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$E0,$00,$10
.DB $FF,$07,$FF,$07,$FF,$00,$00,$00,$00,$00,$00,$80,$00,$87,$00,$88
.DB $FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$87,$00,$48
.DB $FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$87,$00,$08
.DB $FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$40
.DB $02,$00,$02,$00,$01,$00,$00,$00,$00,$00,$02,$01,$04,$02,$01,$04
.DB $F4,$F4,$91,$95,$00,$09,$F0,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$21,$00,$21,$00,$1F,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$1E,$00,$01,$00,$3E,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$3F,$00,$20,$00,$1F,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $16,$26,$0A,$3A,$08,$17,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $F6,$F6,$76,$36,$00,$FC,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$10,$80,$90,$00,$90,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$90,$00,$90,$00,$8F,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$84,$00,$84,$00,$03,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $2E,$0E,$29,$09,$16,$0F,$0F,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $40,$42,$10,$52,$00,$91,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$00,$00,$10,$00,$E0,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$88,$00,$88,$00,$87,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$47,$00,$40,$00,$8F,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$8F,$00,$48,$00,$87,$00,$00,$00,$00,$00,$FF,$00,$00,$FF,$00
.DB $00,$C0,$00,$00,$00,$C0,$00,$00,$00,$00,$40,$80,$20,$40,$80,$20
.DB $01,$04,$01,$04,$01,$04,$01,$04,$01,$04,$81,$04,$81,$04,$81,$04
.DB $FF,$FF,$FF,$FF,$FF,$C0,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF
.DB $FF,$FF,$FF,$FF,$FF,$03,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB
.DB $FF,$FF,$FF,$F8,$FC,$F8,$FD,$F8,$FE,$F9,$FC,$FA,$FC,$F8,$FC,$FB
.DB $80,$20,$80,$70,$80,$10,$50,$90,$30,$50,$10,$30,$11,$10,$71,$F0
.DB $81,$04,$81,$04,$01,$84,$C1,$84,$C1,$84,$81,$C4,$41,$84,$C1,$04
.DB $FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$DF,$FF,$C0,$FF,$FF,$FF,$FF
.DB $FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$FB,$FF,$03,$FF,$FF,$FF,$FF
.DB $81,$20,$82,$21,$82,$21,$81,$23,$87,$23,$81,$23,$83,$21,$80,$21
.DB $C1,$04,$81,$04,$81,$04,$01,$04,$01,$04,$01,$04,$01,$04,$01,$04
.DB $81,$20,$81,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20
.DB $01,$04,$01,$04,$01,$04,$01,$04,$01,$04,$01,$04,$01,$04,$01,$04
.DB $80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$81,$20,$81,$20
.DB $80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$20
.DB $FC,$FB,$FC,$F8,$FC,$FA,$FE,$F9,$FD,$F8,$FC,$F8,$FF,$F8,$FF,$FF
.DB $71,$F0,$11,$10,$10,$30,$30,$50,$50,$90,$80,$10,$80,$70,$80,$20
.DB $C1,$04,$84,$02,$82,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $FF,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.DB $80,$20,$20,$40,$40,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; vim: filetype=wla
