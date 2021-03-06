;
; BLOK COPY RX IN-GAME SCREEN DATA - PETSCII VERSION
;

; Top and bottom frame (two characters high)
pet_top_edge	!byte $f0,$ee,$72,$40,$40,$40,$72,$40
		!byte $40,$40,$72,$40,$40,$40,$72,$40
		!byte $40,$40,$72,$40,$40,$40,$72,$40
		!byte $40,$40,$72,$40,$40,$40,$72,$f0
		!byte $ee,$40,$40,$40,$40,$40,$40,$40

		!byte $ed,$fd,$71,$40,$40,$40,$71,$40
		!byte $40,$40,$71,$40,$40,$40,$71,$40
		!byte $40,$40,$71,$40,$40,$40,$71,$40
		!byte $40,$40,$71,$40,$40,$40,$71,$ed
		!byte $fd,$40,$40,$40,$40,$40,$40,$40

pet_top_edge_cl	!byte $01,$0f,$0b,$0c,$0c,$0c,$0f,$0c
		!byte $0c,$0c,$0f,$0c,$0c,$0c,$0f,$0c
		!byte $0c,$0c,$0f,$0c,$0c,$0c,$0f,$0c
		!byte $0c,$0c,$0f,$0c,$0c,$0c,$0f,$01
		!byte $0f,$0b,$0c,$0c,$0c,$0c,$0c,$0c

		!byte $0f,$0c,$09,$0b,$0b,$0b,$0c,$0b
		!byte $0b,$0b,$0c,$0b,$0b,$0b,$0c,$0b
		!byte $0b,$0b,$0c,$0b,$0b,$0b,$0c,$0b
		!byte $0b,$0b,$0c,$0b,$0b,$0b,$0c,$0f
		!byte $0c,$09,$0b,$0b,$0b,$0b,$0b,$0b

; Separator row (one character high)
pet_sep		!byte $6b,$73,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$6b
		!byte $73,$00,$00,$00,$00,$00,$00,$00

pet_sep_cl	!byte $0b,$09,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$0b
		!byte $09,$00,$00,$00,$00,$00,$00,$00

; Tile row (three characters high)
pet_tiles	!byte $5d,$5d,$00,$6c,$e2,$7b,$00,$ec
		!byte $e2,$fb,$00,$7f,$00,$ff,$00,$fe
		!byte $62,$fc,$00,$6c,$a0,$7b,$00,$f0
		!byte $a0,$ee,$00,$ff,$a0,$7f,$00,$5d
		!byte $5d,$20,$20,$20,$20,$20,$20,$20

		!byte $5d,$5d,$00,$61,$31,$e1,$00,$61
		!byte $32,$e1,$00,$00,$b3,$00,$00,$e1
		!byte $34,$61,$00,$a0,$b5,$a0,$00,$a0
		!byte $b6,$a0,$00,$a0,$37,$a0,$00,$5d
		!byte $5d,$20,$20,$20,$20,$20,$20,$20

		!byte $5d,$5d,$00,$7c,$62,$7e,$00,$fc
		!byte $62,$fe,$00,$ff,$00,$7f,$00,$fb
		!byte $e2,$ec,$00,$7c,$a0,$7e,$00,$ed
		!byte $a0,$fd,$00,$7f,$a0,$ff,$00,$5d
		!byte $5d,$20,$20,$20,$20,$20,$20,$20

pet_tiles_col	!byte $0c,$0b,$00,$02,$02,$02,$00,$0a
		!byte $08,$0a,$00,$0f,$0f,$0f,$00,$0d
		!byte $05,$0d,$00,$0e,$0e,$0e,$00,$04
		!byte $04,$04,$00,$06,$06,$06,$00,$0c
		!byte $0b,$00,$00,$00,$00,$00,$00,$00

		!byte $0c,$0b,$00,$02,$0a,$02,$00,$08
		!byte $0c,$08,$00,$07,$07,$07,$00,$05
		!byte $0d,$05,$00,$0e,$03,$0e,$00,$04
		!byte $0c,$04,$00,$06,$0e,$06,$00,$0c
		!byte $0b,$00,$00,$00,$00,$00,$00,$00

		!byte $0c,$0b,$00,$02,$02,$02,$00,$0a
		!byte $08,$0a,$00,$0f,$0f,$0f,$00,$0d
		!byte $05,$0d,$00,$0e,$0e,$0e,$00,$04
		!byte $04,$04,$00,$06,$06,$06,$00,$0c
		!byte $0b,$00,$00,$00,$00,$00,$00,$00

; Blok Copy logo
pet_logo_1	!byte $62,$00,$7b,$00,$00,$6c,$00
pet_logo_2	!byte $61,$61,$61,$e9,$4d,$e1,$6c
pet_logo_3	!byte $ec,$7b,$61,$a0,$6a,$e1,$ff
pet_logo_4	!byte $fc,$7e,$7f,$5f,$4e,$e1,$e1
pet_logo_5	!byte $6c,$7b,$00,$00,$00,$00,$00
pet_logo_6	!byte $61,$e9,$4d,$6c,$7f,$e1,$6c
pet_logo_7	!byte $61,$a0,$6a,$e1,$e1,$e1,$e1
pet_logo_8	!byte $7f,$5f,$4e,$e1,$ff,$7c,$fe
pet_logo_9	!byte $00,$00,$00,$e1,$00,$6c,$ff

pet_logo_col_1	!byte $02,$02,$08,$07,$07,$05,$05
pet_logo_col_2	!byte $02,$02,$08,$0e,$06,$05,$05
pet_logo_col_3	!byte $02,$02,$08,$0e,$06,$05,$05
pet_logo_col_4	!byte $02,$02,$08,$0e,$06,$05,$05
pet_logo_col_5	!byte $05,$05,$05,$05,$05,$05,$05
pet_logo_col_6	!byte $05,$07,$0a,$04,$04,$06,$06
pet_logo_col_7	!byte $05,$07,$0a,$04,$04,$06,$06
pet_logo_col_8	!byte $05,$07,$0a,$04,$04,$06,$06
pet_logo_col_9	!byte $05,$0e,$0e,$04,$04,$06,$06
