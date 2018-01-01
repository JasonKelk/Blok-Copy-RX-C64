;
; BLOK COPY RX IN-GAME SCREEN DATA - STANDARD VERSION
;

; Top and bottom frame (two characters high)
scr_top_edge	!byte $2a,$2b,$2c,$2d,$2e,$2d,$2c,$2d
		!byte $2e,$2d,$2c,$2d,$2e,$2d,$2c,$2d
		!byte $2e,$2d,$2c,$2d,$2e,$2d,$2c,$2d
		!byte $2e,$2d,$2c,$2d,$2e,$2d,$2c,$2a
		!byte $2b,$2c,$2d,$2e,$2d,$2c,$2d,$2e

		!byte $2f,$30,$31,$32,$33,$32,$31,$32
		!byte $33,$32,$31,$32,$33,$32,$31,$32
		!byte $33,$32,$31,$32,$33,$32,$31,$32
		!byte $33,$32,$31,$32,$33,$32,$31,$2f
		!byte $30,$31,$32,$33,$32,$31,$32,$33

scr_top_edge_cl	!byte $0f,$0f,$0c,$0b,$0d,$0b,$0c,$0b
		!byte $0d,$0b,$0c,$0b,$0d,$0b,$0c,$0b
		!byte $0d,$0b,$0c,$0b,$0d,$0b,$0c,$0b
		!byte $0d,$0b,$0c,$0b,$0d,$0b,$0c,$0f
		!byte $0f,$0c,$0b,$0d,$0b,$0c,$0b,$0d

		!byte $0b,$0b,$0a,$0d,$0c,$0d,$0a,$0d
		!byte $0c,$0d,$0a,$0d,$0c,$0d,$0a,$0d
		!byte $0c,$0d,$0a,$0d,$0c,$0d,$0a,$0d
		!byte $0c,$0d,$0a,$0d,$0c,$0d,$0a,$0b
		!byte $0b,$0a,$0d,$0c,$0d,$0a,$0d,$0c

; Separator row (one character high)
scr_sep		!byte $34,$35,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$34
		!byte $35,$00,$00,$00,$00,$00,$00,$00

scr_sep_cl	!byte $0c,$0c,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$0c
		!byte $0c,$00,$00,$00,$00,$00,$00,$00

; Tile row (three characters high)
scr_tiles	!byte $36,$37,$00,$40,$41,$42,$00,$49
		!byte $4a,$4b,$00,$40,$41,$42,$00,$54
		!byte $55,$42,$00,$59,$41,$5a,$00,$54
		!byte $4a,$4b,$00,$40,$41,$61,$00,$36
		!byte $37,$00,$00,$00,$00,$00,$00,$00

		!byte $38,$39,$00,$43,$44,$45,$00,$4c
		!byte $4d,$45,$00,$4c,$51,$52,$00,$56
		!byte $57,$52,$00,$5b,$5c,$5d,$00,$56
		!byte $60,$45,$00,$43,$62,$45,$00,$38
		!byte $39,$00,$00,$00,$00,$00,$00,$00

		!byte $36,$37,$00,$46,$47,$48,$00,$4e
		!byte $4f,$50,$00,$4e,$4f,$53,$00,$46
		!byte $58,$53,$00,$5e,$47,$5f,$00,$46
		!byte $47,$48,$00,$63,$47,$48,$00,$36
		!byte $37,$00,$00,$00,$00,$00,$00,$00

scr_tiles_col	!byte $0b,$0d,$00,$0c,$0b,$0d,$00,$0a
		!byte $0a,$0c,$00,$0d,$0b,$0d,$00,$0f
		!byte $0b,$0c,$00,$0a,$0b,$0a,$00,$0d
		!byte $0c,$0d,$00,$0b,$0f,$0b,$00,$0b
		!byte $0d,$00,$00,$00,$00,$00,$00,$00

		!byte $0d,$0c,$00,$0b,$0b,$0b,$00,$0c
		!byte $0c,$0c,$00,$0b,$0b,$0b,$00,$0f
		!byte $0f,$0f,$00,$0c,$0b,$0c,$00,$0d
		!byte $0d,$0d,$00,$0f,$0f,$0f,$00,$0b
		!byte $0d,$00,$00,$00,$00,$00,$00,$00

		!byte $0b,$0d,$00,$0d,$0b,$0c,$00,$0c
		!byte $0a,$0a,$00,$0b,$0d,$0b,$00,$0c
		!byte $0b,$0f,$00,$0a,$0b,$0a,$00,$0a
		!byte $0d,$0a,$00,$0b,$0f,$0b,$00,$0b
		!byte $0d,$00,$00,$00,$00,$00,$00,$00

; Blok Copy logo
scr_logo_1	!byte $81,$82,$83,$84,$85,$83,$00
scr_logo_2	!byte $86,$87,$88,$89,$8a,$8b,$8c
scr_logo_3	!byte $8d,$8e,$8f,$90,$91,$92,$93
scr_logo_4	!byte $94,$95,$96,$97,$98,$99,$00
scr_logo_5	!byte $9a,$9b,$9c,$9d,$9e,$9f,$a0
scr_logo_6	!byte $a1,$a2,$a3,$a4,$a5,$a6,$a7
scr_logo_7	!byte $00,$00,$00,$a8,$00,$a9,$aa

scr_logo_col_1	!byte $0f,$0f,$0f,$0f,$0a,$0f,$0f
scr_logo_col_2	!byte $0b,$0b,$0b,$0f,$0a,$0b,$0b
scr_logo_col_3	!byte $0d,$0b,$0d,$0b,$0a,$0d,$0b
scr_logo_col_4	!byte $0f,$0f,$0a,$0f,$0f,$0f,$0f
scr_logo_col_5	!byte $0b,$0f,$0a,$0b,$0b,$0b,$0b
scr_logo_col_6	!byte $0d,$0b,$0a,$0d,$0d,$0d,$0d
scr_logo_col_7	!byte $0c,$0c,$0c,$0c,$0c,$0c,$0c
