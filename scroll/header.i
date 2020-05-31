;==============================================================================
; Header
;==============================================================================

.GBHEADER
    NAME		"SCROLL"
    CARTRIDGETYPE	$00 ; RAM only
    RAMSIZE		$00 ; 32KByte, no banks
    COUNTRYCODE		$01 ; outside Japan
    NINTENDOLOGO
    LICENSEECODENEW	"SV"
    ROMDMG
.ENDGB


.MEMORYMAP
    DEFAULTSLOT 0
    SLOTSIZE $4000
    SLOT 0 $0000
    SLOT 1 $4000
    SLOT 2 $C000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2

; vim: filetype=wla
