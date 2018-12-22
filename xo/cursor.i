; ///////////////////////
; //                   //
; //  File Attributes  //
; //                   //
; ///////////////////////

; Filename: cursor.png
; Pixel Width: 16px
; Pixel Height: 16px

; /////////////////
; //             //
; //  Constants  //
; //             //
; /////////////////

.DEFINE cursor_tile_map_size  $04
.DEFINE cursor_tile_map_width  $02
.DEFINE cursor_tile_map_height  $02

.DEFINE cursor_tile_data_size  $40
.DEFINE cursor_tile_count  $04

; ////////////////
; //            //
; //  Map Data  //
; //            //
; ////////////////

cursor_map_data:
.DB $00,$01,$02,$03

; /////////////////
; //             //
; //  Tile Data  //
; //             //
; /////////////////

cursor_tile_data:
.DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7F,$7F,$BF,$C0
.DB $00,$00,$00,$00,$E0,$F0,$F8,$88,$5C,$64,$3E,$22,$ED,$F3,$FF,$00
.DB $7F,$7F,$07,$04,$03,$03,$03,$02,$01,$01,$01,$01,$00,$00,$00,$00
.DB $7F,$80,$FF,$00,$BF,$C0,$FF,$00,$BF,$C0,$FF,$00,$FF,$FF,$00,$00
