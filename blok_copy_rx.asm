;
; BLOK COPY :: C64 REMIX EDITION
;

; Code and graphics by Jason Kelk
; PETSCII graphics by Doug Roberts and Jason Kelk
; Music by Sean Connolly


; This source code is formatted for the ACME cross assembler from
; http://sourceforge.net/projects/acme-crossass/
; Compression is handled with Exomizer which can be downloaded at
; http://csdb.dk/release/?id=141402

; build.bat will call both to create an assembled file and then the
; crunched release version.


; MEMORY MAP
; $0812 - $2dff		code and data
; $4000 - $47ff		titles characters
; $4800 - $4fff		in-game characters
; $5000 - $53ff		screen RAM
; $5000 - $51ff		sprites
; $6000 - $765b		music


; Select an output filename
		!to "blok_copy_rx.prg",cbm


; Constants: raster split positions
rstr1p		= $00
rstr2p		= $e1

; Constants: game shuffle values
shuffle_init	= $03
shuffle_num	= $0a		; $01 will give one level, $0a for ten

; General purpose labels
rn		= $0340
sync		= $0341
d011_mirror	= $0342
rnd_seed	= $0343
rnd_seed_2	= $0344

rt_store_1	= $0345
rt_store_2	= $0346
rt_store_3	= $0347
rt_store_4	= $0348

; Titles screen labels
ttl_scrl_cnt	= $0349
ttl_scrl_col	= $034a
ttl_col_cnt	= $034b

; In-game labels
diff_level	= $034c
game_over_flag	= $034d
petscii_flag	= $034e

cursor_x	= $0350
cursor_y	= $0351
joy_reg		= $0352
joy_delay	= $0353

; Player status labels
score		= $0354		; $05 bytes used
highscore	= $0359		; $05 bytes used
time		= $035e		; $04 bytes used
level		= $0362		; $02 bytes used

; End screen labels
gd_wipe_cnt	= $0363

; End screen effect buffer
gd_buffer	= $0364		; $28 bytes used

; Where to find the screen and colour RAM in memory
screen_ram 	= $5000
colour_ram	= $d800


; Load the binary data
		* = $4000
		!binary "data/titles.chr"

		* = $4800
		!binary "data/ingame.chr"

		* = $5400
		!binary "data/sprites.spr"

		* = $6000
music		!binary "data/sporting_chance.prg",,2


; Add a BASIC startline
		* = $0801
		!word main_entry-2
		!byte $00,$00,$9e
		!text "2066"
		!byte $00,$00,$00

; Code entry point at $0812
		* = $0812

; Stop interrupts and blank the screen
main_entry	sei

		lda #$0b
		sta $d011

		lda #$00
		sta $d020
		sta $d021

; One shot ROM font copy (for PETSCII mode)
		lda #$33
		sta $01

font_copy	lda $d000,x
		sta $5800,x
		lda $d100,x
		sta $5900,x
		lda $d200,x
		sta $5a00,x
		lda $d300,x
		sta $5b00,x
		lda $d400,x
		sta $5c00,x
		lda $d500,x
		sta $5d00,x
		lda $d600,x
		sta $5e00,x
		lda $d700,x
		sta $5f00,x
		inx
		bne font_copy

		lda #$36
		sta $01

		cli

; A small "fudge" to clear the @ out of the copied PETSCII font so that
; the text output doesn't need patching!
		ldx #$00
		txa
font_at_clear	sta $5800,x
		inx
		cpx #$08
		bne font_at_clear

; Another "fudge" that copies the numeral characters around, again to
; avoid altering the status bar code
		ldx #$00
font_num_copy	lda $5980,x
		sta $5900,x
		inx
		cpx #$50
		bne font_num_copy

; Select the video bank
		lda #$c6
		sta $dd00

; Stop interrupts, disable the ROMS and set up NMI and IRQ interrupt pointers
		sei

		lda #$35
		sta $01

		lda #<int
		sta $fffe
		lda #>int
		sta $ffff

		lda #<nmi
		sta $fffa
		lda #>nmi
		sta $fffb

; Set the VIC-II up for a raster IRQ interrupt
		lda #$7f
		sta $dc0d
		sta $dd0d

		lda #rstr1p
		sta $d012

		lda #$0b
		sta $d011
		sta d011_mirror

		lda #$01
		sta $d019
		sta $d01a

; Set up the music driver
		lda #$00
		jsr music+$00

; Reset the label space
		ldx #$01
		lda #$00
nuke_labels	sta rn,x
		inx
		cpx #$bf
		bne nuke_labels

; Set a couple of labels to specific values
		lda #$01
		sta game_over_flag
		sta highscore+$01

		sta rn

; Turn the interrupts back on
		cli

; Clear the screen RAM
		ldx #$00
		txa
clear_screen	sta screen_ram+$000,x
		sta screen_ram+$100,x
		sta screen_ram+$200,x
		sta screen_ram+$2e8,x
		inx
		bne clear_screen


; Entry point for the titles

; Draw in the title page
ttl_init	ldx #$00
		ldy ttl_screen+$000,x
		lda char_decode,y
		sta screen_ram+$000,x
		lda #$0b
		sta colour_ram+$000,x

		ldy ttl_screen+$028,x
		lda char_decode,y
		sta screen_ram+$190,x
		lda #$0d
		sta colour_ram+$190,x

		ldy ttl_screen+$050,x
		lda char_decode,y
		sta screen_ram+$1b8,x
		lda #$0d
		sta colour_ram+$1b8,x

		ldy ttl_screen+$078,x
		lda char_decode,y
		sta screen_ram+$1e0,x
		lda #$0d
		sta colour_ram+$1e0,x

		ldy ttl_screen+$0a0,x
		lda char_decode,y
		sta screen_ram+$208,x
		lda #$0d
		sta colour_ram+$208,x


		ldy ttl_screen+$0c8,x
		lda char_decode,y
		sta screen_ram+$258,x
		lda #$0b
		sta colour_ram+$258,x

		ldy ttl_screen+$0f0,x
		lda char_decode,y
		sta screen_ram+$280,x
		lda #$0b
		sta colour_ram+$280,x

		ldy ttl_screen+$118,x
		lda char_decode,y
		sta screen_ram+$2a8,x
		lda #$0b
		sta colour_ram+$2a8,x

		ldy ttl_screen+$168,x
		lda char_decode,y
		sta screen_ram+$2f8,x
		lda #$0d
		sta colour_ram+$2f8,x

		ldy ttl_screen+$190,x
		lda char_decode,y
		sta screen_ram+$320,x
		lda #$0d
		sta colour_ram+$320,x

		ldy ttl_screen+$1b8,x
		lda char_decode,y
		sta screen_ram+$3c0,x
		lda #$0b
		sta colour_ram+$3c0,x
		inx
		cpx #$28
		beq *+$05
		jmp ttl_init+$02

; Draw in the title logo
		ldx #$00
ttl_logo_init	lda ttl_logo_l1,x
		sta screen_ram+$054,x
		lda ttl_logo_l1c,x
		sta colour_ram+$054,x

		lda ttl_logo_l2,x
		sta screen_ram+$07c,x
		lda ttl_logo_l2c,x
		sta colour_ram+$07c,x

		lda ttl_logo_l3,x
		sta screen_ram+$0a4,x
		lda ttl_logo_l3c,x
		sta colour_ram+$0a4,x

		lda ttl_logo_l4,x
		sta screen_ram+$0cc,x
		lda ttl_logo_l4c,x
		sta colour_ram+$0cc,x

		lda ttl_logo_l5,x
		sta screen_ram+$0f4,x
		lda ttl_logo_l5c,x
		sta colour_ram+$0f4,x

		lda ttl_logo_l6,x
		sta screen_ram+$11c,x
		lda ttl_logo_l6c,x
		sta colour_ram+$11c,x

		lda ttl_logo_l7,x
		sta screen_ram+$144,x
		lda ttl_logo_l7c,x
		sta colour_ram+$144,x
		inx
		cpx #$20
		bne ttl_logo_init

; Draw in the Cosine "logo"
		ldx #$00
		ldy #$52
		clc
ttl_cos_draw	tya
		sta screen_ram+$1b4,x
		adc #$04
		sta screen_ram+$1dc,x
		adc #$04
		sta screen_ram+$204,x
		adc #$04
		sta screen_ram+$22c,x

		lda #$0c
		sta colour_ram+$1b4,x
		lda #$0b
		sta colour_ram+$1dc,x
		lda #$0f
		sta colour_ram+$204,x
		sta colour_ram+$22c,x
		iny
		inx
		cpx #$04
		bne ttl_cos_draw

; Draw in the joystick image
		ldx #$00
		ldy #$62
		clc
ttl_joy_draw	tya
		sta screen_ram+$258,x
		adc #$05
		sta screen_ram+$280,x
		adc #$05
		sta screen_ram+$2a8,x
		adc #$05
		sta screen_ram+$2d0,x
		adc #$05
		sta screen_ram+$2f8,x
		adc #$05
		sta screen_ram+$320,x

		lda ttl_joy_col+$00,x
		sta colour_ram+$258,x
		lda ttl_joy_col+$05,x
		sta colour_ram+$280,x
		lda ttl_joy_col+$0a,x
		sta colour_ram+$2a8,x
		lda ttl_joy_col+$0f,x
		sta colour_ram+$2d0,x
		lda ttl_joy_col+$14,x
		sta colour_ram+$2f8,x
		lda ttl_joy_col+$19,x
		sta colour_ram+$320,x
		iny
		inx
		cpx #$05
		bne ttl_joy_draw

; Set up the sprite overlays
		lda #$ff
		sta $d015
		lda #$c0
		sta $d01d
		lda #$3f
		sta $d01c

		ldx #$00
ttl_spr_init_1	lda ttl_spr_pos,x
		sta $d000,x
		inx
		cpx #$11
		bne ttl_spr_init_1

		ldx #$00
		ldy #$50
ttl_spr_init_2	tya
		sta screen_ram+$3f8,x
		lda #$0c
		sta $d027,x
		iny
		inx
		cpx #$08
		bne ttl_spr_init_2

		lda #$09
		sta $d025
		lda #$0f
		sta $d026

		lda #$0e
		sta $d02d
		lda #$08
		sta $d02e

; Set the last and high scores up in the scroller, then reset the scroll
		ldx #$00
ttl_score_mv	lda score,x
		ora #$30
		sta ttl_last_score,x
		lda highscore,x
		ora #$30
		sta ttl_high_score,x
		inx
		cpx #$05
		bne ttl_score_mv

		jsr ttl_reset
		lda #$00
		sta ttl_scrl_cnt

; Set up titles-specific video registers
		lda #$18
		sta $d016
		lda #$40
		sta $d018
		lda #$0b
		sta $d022
		lda #$01
		sta $d023

; Set some labels
		lda #$01
		sta game_over_flag
		lda #$0d
		sta ttl_scrl_col

; Wait for a second before turning on the screen
		ldy #$32
		jsr sync_wait_long
		lda #$1b
		sta d011_mirror

; Main title loop
ttl_loop	jsr sync_wait
		sty rt_store_1
		jsr ttl_move_scrl
		ldy rt_store_1

		jsr random

		jsr sync_wait
		jsr ttl_move_scrl

		jsr random

; Check the fire button
		lda $dc00
		and #$10
		beq ttl_exit

		jmp ttl_loop

; Exit the title page, turning off the sprites along the way
ttl_exit	lda #$00
		sta $d015

; Check for Commodore key and enable PETSCII mode if held down
		ldy #$00
		lda $dc01
		cmp #$df
		bne petscii_chk_out
		ldy #$01
petscii_chk_out	sty petscii_flag

		lda #$ff
		sta $dc00

; Clear the screen and get the game ready to go
		jsr wipe_screen
		jmp main_first_init

; Scroller management subs
ttl_move_scrl	lda ttl_scrl_cnt
		cmp #$28
		bcs ttl_no_scrl

		ldx #$00
ttl_ms_loop	lda screen_ram+$0371,x
		sta screen_ram+$0370,x

		lda colour_ram+$0371,x
		sta colour_ram+$0370,x
		inx
		cpx #$27
		bne ttl_ms_loop

		lda #$20
		ldy ttl_scrl_cnt
		cpy #$01
		bcc ttl_okay_2
		cpy #$27
		bcs ttl_okay_2

ttl_mread	lda ttl_scroll
		bne ttl_okay
		jsr ttl_reset
		jmp ttl_mread

ttl_okay	inc ttl_mread+$01
		bne *+$05
		inc ttl_mread+$02

ttl_okay_2	tay
		lda char_decode,y
		sta screen_ram+$0397

		lda ttl_scrl_col
		sta colour_ram+$0397

ttl_no_scrl	inc ttl_scrl_cnt

		ldx ttl_scrl_cnt
		cpx #$2c
		bne ttl_no_colchng

		ldx ttl_col_cnt
		inx
		cpx #$08
		bne *+$04
		ldx #$00
		stx ttl_col_cnt
		lda ttl_scrl_ctab,x

		sta ttl_scrl_col

ttl_no_colchng	rts

; Self mod reset for the title page scroller
ttl_reset	lda #<ttl_scroll
		sta ttl_mread+$01
		lda #>ttl_scroll
		sta ttl_mread+$02
		rts


; Initial entry point for main game

; Set how many shuffles for the first level
main_first_init	lda #shuffle_init
		sta diff_level

; Set up game-specific video register set-ups
		lda #$42
		sta $d018
		lda #$09
		sta $d022
		lda #$01
		sta $d023

; Reset the status bar
		ldx #$00
		txa
clear_score	sta score,x
		inx
		cpx #$05
		bne clear_score

		lda #$00
		sta level+$00
		lda #$01
		sta level+$01

; Reset the hardware sprites
		ldx #$00
		txa
mi_clr_sprs	sta $d000,x
		inx
		cpx #$11
		bne mi_clr_sprs

		jsr screen_init

; Entry point for main game
main_init

; Reset the playfield
		ldx #$00
rp_loop		txa
		and #$07
		sta play_area,x
		inx
		cpx #$28
		bne rp_loop

; Turn the screen on
		jsr sync_wait
		lda #$1b
		sta d011_mirror

; Pause for a second
		ldy #$32
ss_loop		jsr sync_wait
		jsr house_keep
		dey
		bne ss_loop

; Set the cursor X and Y positions
		lda #$03
		sta cursor_x
		lda #$02
		sta cursor_y

; Scramble the play area depending on difficulty level
		ldx #$00
		stx rt_store_2
scramble	stx rt_store_3
		jsr sync_wait

		jsr random

		lda rnd_seed
		and #$0f
		tax
		ldy cursor_x
scram_x_move	iny
		cpy #$07
		bne *+$04
		ldy #$00
		dex
		bne scram_x_move
		sty cursor_x

		jsr random
		lda rnd_seed
		and #$0f
		tax
		ldy cursor_y
scram_y_move	iny
		cpy #$05
		bne *+$04
		ldy #$00
		dex
		bne scram_y_move
		sty cursor_y

		lda rt_store_2
		and #$03
		tax
		lda scram_joy,x
		sta joy_reg
		jsr joy_fire_up
		inc rt_store_2

; Pause after each move
		ldy #$20
		jsr sync_wait_long

		ldx rt_store_3
		inx
		cpx diff_level
		bne scramble

; Set the level timer
		lda #$01
		sta time+$00
		lda #$05
		sta time+$01
		lda #$00
		sta time+$02
		lda #$32
		sta time+$03

		jsr sync_wait
		jsr house_keep

; Reset the player cursor
		lda #$00
		sta cursor_x
		sta cursor_y

; Display the Get Ready message
		lda level+$00
		ora #$30
		sta levnum_text+$07
		lda level+$01
		ora #$30
		sta levnum_text+$08

		ldy #$0f
		lda petscii_flag
		beq *+$04
		ldy #$01
		sty rt_store_4

; Type out the Get Ready message
		ldx #$00
		ldy #$08
gr_message	stx rt_store_2
		sty rt_store_3

		ldy #$04
		jsr sync_wait_long

		ldx rt_store_2
		ldy getrdy_text,x
		lda char_decode,y
		sta screen_ram+$19c,x
		lda #$0b
		and rt_store_4
		sta colour_ram+$19c,x

		ldx rt_store_3
		ldy levnum_text,x
		lda char_decode,y
		sta screen_ram+$23c,x
		lda #$0d
		and rt_store_4
		sta colour_ram+$23c,x

		ldx rt_store_2
		ldy rt_store_3
		dey
		inx
		cpx #$09
		bne gr_message

; Pause for a second
		ldy #$32
		jsr sync_wait_long

		ldx #$00
		ldy #$08
gr_clear	stx rt_store_2
		sty rt_store_3

; Clear the Get Ready message
		ldy #$04
		jsr sync_wait_long

		ldx rt_store_2
		ldy rt_store_3

		lda #$00
		sta screen_ram+$19c,x
		sta screen_ram+$23c,y
		dey
		inx
		cpx #$09
		bne gr_clear

; Set some final labels
		lda #$00
		sta game_over_flag
		jsr sync_wait
		jsr house_keep

		jsr cursor_draw
		lda #$03
		sta $d015

; Main game loop
main_loop	jsr sync_wait
		jsr house_keep

		jsr joy_scan
		jsr cursor_draw

; Check to see if the level is done and react accordingly
		ldx #$00
scan_loop	txa
		and #$07
		cmp play_area,x
		bne scan_out
		inx
		cpx #$28
		bne scan_loop

		jmp level_done

; Check to see if the game over flag is set
scan_out	lda game_over_flag
		bne game_over

		jmp main_loop

; Game Over sequence
game_over	lda #$00
		sta $d015

		ldy #$0f
		lda petscii_flag
		beq *+$04
		ldy #$01
		sty rt_store_4

; Type out the Game Over message
		ldx #$00
		ldy #$08
go_message	stx rt_store_2
		sty rt_store_3

		ldy #$04
		jsr sync_wait_long

		ldx rt_store_2
		ldy gamovr_text,x
		lda char_decode,y
		sta screen_ram+$19c,x
		lda #$0b
		and rt_store_4
		sta colour_ram+$19c,x

		ldx rt_store_3
		ldy levnum_text,x
		lda char_decode,y
		sta screen_ram+$23c,x
		lda #$0d
		and rt_store_4
		sta colour_ram+$23c,x

		ldx rt_store_2
		ldy rt_store_3
		dey
		inx
		cpx #$09
		bne go_message

; Pause for a second
		ldy #$96
		jsr sync_wait_long

; Clear the screen and jump to the titles page
		jsr wipe_screen

		jmp ttl_init

; Level Complete sequence - no text, just adds a time bonus
level_done	lda #$00
		sta $d015

; Wait for half a second
		ldy #$19
		jsr sync_wait_long

; Add the remaining time as a score bonus
ld_bonus_loop	jsr sync_wait
		jsr house_keep

		jsr score_bump_10

		ldx #$02
ld_bonus_count	lda time,x
		sec
		sbc #$01
		sta time,x
		cmp #$ff
		bne ld_bonus_out
		lda #$09
		sta time,x
		dex
		cpx #$ff
		bne ld_bonus_count

ld_bonus_out	ldx #$00
		lda time,x
		bne ld_bonus_loop
		inx
		cpx #$02
		bne ld_bonus_out+$02

; Zero the time counter
		lda #$00
		sta time+$00
		sta time+$01
		sta time+$02
		lda #$fc
		sta time+$03

; Bump the level counter and, if that wasn't the last stage, move on
ld_bonus_done	jsr sync_wait
		jsr house_keep

		inc diff_level

		lda diff_level
		cmp #shuffle_init+shuffle_num
		beq game_done

		ldx level+$01
		inx
		cpx #$0a
		bne lc_bump_xb
		ldx #$00
		inc level+$00
lc_bump_xb	stx level+$01

		jmp main_init


; Game completion sequence
game_done	ldx #$02
		ldy #$1e

; Wipe the playfield area
gd_clear	jsr sync_wait

		lda #$00
		sta screen_ram+$078,x
		sta screen_ram+$0a0,y
		sta screen_ram+$0c8,x
		sta screen_ram+$0f0,y
		sta screen_ram+$118,x

		sta screen_ram+$140,y
		sta screen_ram+$168,x
		sta screen_ram+$190,y
		sta screen_ram+$1b8,x
		sta screen_ram+$1e0,y

		sta screen_ram+$208,x
		sta screen_ram+$230,y
		sta screen_ram+$258,x
		sta screen_ram+$280,y
		sta screen_ram+$2a8,x

		sta screen_ram+$2d0,y
		sta screen_ram+$2f8,x
		sta screen_ram+$320,y
		sta screen_ram+$348,x

		dey
		inx
		cpx #$1f
		bne gd_clear

; Pause for a second
		ldy #$32
		jsr sync_wait_long

; At this point, we have to split off depending on if PETSCII mode
; is enabled or not
		lda petscii_flag
		beq gd_standard

		jmp gd_petscii

; Completion effect - standard version
gd_standard	lda #$ad
		jsr gd_buffer_clr

; Display the completion message
		ldx #$00
gd_message	ldy gd_text,x
		lda char_decode,y
		sta screen_ram+$1e2,x
		lda #$0f
		sta colour_ram+$1e2,x
		inx
		cpx #$1d
		bne gd_message

		lda #$1c
		sta rt_store_1
		lda #$00
		sta gd_wipe_cnt

; Set up the end logo's colour
		ldx #$00
gd_col_set	lda gd_logo+$00,x
		sta colour_ram+$0cf,x
		lda gd_logo+$28,x
		sta colour_ram+$0f7,x
		lda gd_logo+$50,x
		sta colour_ram+$11f,x
		lda gd_logo+$78,x
		sta colour_ram+$147,x
		lda gd_logo+$a0,x
		sta colour_ram+$16f,x
		lda gd_logo+$c8,x
		sta colour_ram+$197,x

		lda gd_logo+$14,x
		sta colour_ram+$237,x
		lda gd_logo+$3c,x
		sta colour_ram+$25f,x
		lda gd_logo+$64,x
		sta colour_ram+$287,x
		lda gd_logo+$8c,x
		sta colour_ram+$2af,x
		lda gd_logo+$b4,x
		sta colour_ram+$2d7,x
		lda gd_logo+$dc,x
		sta colour_ram+$2ff,x
		inx
		cpx #$13
		bne gd_col_set

; Completion effect loop
gd_loop		jsr sync_wait
		jsr sync_wait

; Update the logo
		ldx #$00
gd_logo_1	lda gd_buffer+$06,x
		ldy gd_logo+$00,x
		beq *+$05
		sta screen_ram+$0cf,x
		ldy gd_logo+$28,x
		beq *+$05
		sta screen_ram+$0f7,x
		ldy gd_logo+$50,x
		beq *+$05
		sta screen_ram+$11f,x
		ldy gd_logo+$78,x
		beq *+$05
		sta screen_ram+$147,x
		ldy gd_logo+$a0,x
		beq *+$05
		sta screen_ram+$16f,x
		ldy gd_logo+$c8,x
		beq *+$05
		sta screen_ram+$197,x
		inx
		cpx #$13
		bne gd_logo_1

		ldx #$00
gd_logo_2	lda gd_buffer,x
		ldy gd_logo+$14,x
		beq *+$05
		sta screen_ram+$237,x
		ldy gd_logo+$3c,x
		beq *+$05
		sta screen_ram+$25f,x
		ldy gd_logo+$64,x
		beq *+$05
		sta screen_ram+$287,x
		ldy gd_logo+$8c,x
		beq *+$05
		sta screen_ram+$2af,x
		ldy gd_logo+$b4,x
		beq *+$05
		sta screen_ram+$2d7,x
		ldy gd_logo+$dc,x
		beq *+$05
		sta screen_ram+$2ff,x
		inx
		cpx #$13
		bne gd_logo_2

		jsr gd_buffer_move

; Check for the fire button and exit
		lda $dc00
		and #$10
		bne gd_no_fire
		jmp gd_out

gd_no_fire	jmp gd_loop

; Clear the screen and head back to the titles page
gd_out		jsr wipe_screen
		jmp ttl_init

; Completion effect - PETSCII version
gd_petscii	lda #$00
		jsr gd_buffer_clr

; Display the end message
		ldx #$00
gdp_message	lda gd_text,x
		ora #$80
		sta screen_ram+$1e2,x
		lda #$0f
		sta colour_ram+$1e2,x
		inx
		cpx #$1d
		bne gdp_message

		lda #$1c
		sta rt_store_1

		lda #$00
		sta gd_wipe_cnt

; Set up the logo's colour
		ldx #$00
gdp_col_set	lda gd_pet_logo+$00,x
		sta colour_ram+$0cf,x
		lda gd_pet_logo+$28,x
		sta colour_ram+$0f7,x
		lda gd_pet_logo+$50,x
		sta colour_ram+$11f,x
		lda gd_pet_logo+$78,x
		sta colour_ram+$147,x
		lda gd_pet_logo+$a0,x
		sta colour_ram+$16f,x
		lda gd_pet_logo+$c8,x
		sta colour_ram+$197,x

		lda gd_pet_logo+$14,x
		sta colour_ram+$237,x
		lda gd_pet_logo+$3c,x
		sta colour_ram+$25f,x
		lda gd_pet_logo+$64,x
		sta colour_ram+$287,x
		lda gd_pet_logo+$8c,x
		sta colour_ram+$2af,x
		lda gd_pet_logo+$b4,x
		sta colour_ram+$2d7,x
		lda gd_pet_logo+$dc,x
		sta colour_ram+$2ff,x

		inx
		cpx #$13
		bne gdp_col_set

; Completion loop - PETSCII version
gdp_loop	jsr sync_wait
		jsr sync_wait

		ldx #$00
gdp_logo_1	lda gd_buffer+$06,x
		ldy gd_logo+$00,x
		beq *+$05
		sta screen_ram+$0cf,x
		ldy gd_logo+$28,x
		beq *+$05
		sta screen_ram+$0f7,x
		ldy gd_logo+$50,x
		beq *+$05
		sta screen_ram+$11f,x
		ldy gd_logo+$78,x
		beq *+$05
		sta screen_ram+$147,x
		ldy gd_logo+$a0,x
		beq *+$05
		sta screen_ram+$16f,x
		ldy gd_logo+$c8,x
		beq *+$05
		sta screen_ram+$197,x
		inx
		cpx #$13
		bne gdp_logo_1

		ldx #$00
gdp_logo_2	lda gd_buffer,x
		ldy gd_logo+$14,x
		beq *+$05
		sta screen_ram+$237,x
		ldy gd_logo+$3c,x
		beq *+$05
		sta screen_ram+$25f,x
		ldy gd_logo+$64,x
		beq *+$05
		sta screen_ram+$287,x
		ldy gd_logo+$8c,x
		beq *+$05
		sta screen_ram+$2af,x
		ldy gd_logo+$b4,x
		beq *+$05
		sta screen_ram+$2d7,x
		ldy gd_logo+$dc,x
		beq *+$05
		sta screen_ram+$2ff,x
		inx
		cpx #$13
		bne gdp_logo_2

		jsr gd_buffer_move

; Check for the fire button and exit
		lda $dc00
		and #$10
		bne gdp_no_fire
		jmp gdp_out

gdp_no_fire	jmp gdp_loop

; Clear the screen and head back to the titles page
gdp_out		jsr wipe_screen
		jmp ttl_init


; Check the current mode and set up the playfield
screen_init	lda petscii_flag
		beq set_screen_std
		jmp set_screen_pet

; Draw the top and bottom two lines
set_screen_std	ldx #$00
sss_loop_1	lda scr_top_edge+$000,x
		sta screen_ram+$000,x
		sta screen_ram+$398,x

		lda scr_top_edge_cl+$000,x
		sta colour_ram+$000,x
		sta colour_ram+$398,x
		inx
		cpx #$50
		bne sss_loop_1

; Draw the seperators between tile rows
		ldx #$00
sss_loop_2	lda scr_sep,x
		sta screen_ram+$050,x
		sta screen_ram+$0f0,x
		sta screen_ram+$190,x
		sta screen_ram+$230,x
		sta screen_ram+$2d0,x
		sta screen_ram+$370,x

		lda scr_sep_cl,x
		sta colour_ram+$050,x
		sta colour_ram+$0f0,x
		sta colour_ram+$190,x
		sta colour_ram+$230,x
		sta colour_ram+$2d0,x
		sta colour_ram+$370,x
		inx
		cpx #$28
		bne sss_loop_2

; Draw the tile rows
		ldx #$00
sss_loop_3	lda scr_tiles,x
		sta screen_ram+$078,x
		sta screen_ram+$118,x
		sta screen_ram+$1b8,x
		sta screen_ram+$258,x
		sta screen_ram+$2f8,x

		lda scr_tiles_col,x
		sta colour_ram+$078,x
		sta colour_ram+$118,x
		sta colour_ram+$1b8,x
		sta colour_ram+$258,x
		sta colour_ram+$2f8,x
		inx
		cpx #$78
		bne sss_loop_3

; Set the score bar and colour
		ldx #$00
sss_loop_4	lda scr_score_text,x
		sta screen_ram+$09a,x
		lda #$0d
		sta colour_ram+$09a,x
		lda #$0b
		sta colour_ram+$0c2,x

		lda scr_high_text,x
		sta screen_ram+$112,x
		lda #$0d
		sta colour_ram+$112,x
		lda #$0b
		sta colour_ram+$13a,x

		lda scr_timer_text,x
		sta screen_ram+$18a,x
		lda #$0d
		sta colour_ram+$18a,x
		lda #$0b
		sta colour_ram+$1b2,x
		inx
		cpx #$05
		bne sss_loop_4

; Set the Blok Copy logo up
		ldx #$00
sss_loop_5	lda scr_logo_1,x
		sta screen_ram+$279,x
		lda scr_logo_2,x
		sta screen_ram+$2a1,x
		lda scr_logo_3,x
		sta screen_ram+$2c9,x
		lda scr_logo_4,x
		sta screen_ram+$2f1,x
		lda scr_logo_5,x
		sta screen_ram+$319,x
		lda scr_logo_6,x
		sta screen_ram+$341,x
		lda scr_logo_7,x
		sta screen_ram+$369,x

		lda scr_logo_col_1,x
		sta colour_ram+$279,x
		lda scr_logo_col_2,x
		sta colour_ram+$2a1,x
		lda scr_logo_col_3,x
		sta colour_ram+$2c9,x
		lda scr_logo_col_4,x
		sta colour_ram+$2f1,x
		lda scr_logo_col_5,x
		sta colour_ram+$319,x
		lda scr_logo_col_6,x
		sta colour_ram+$341,x
		lda scr_logo_col_7,x
		sta colour_ram+$369,x

		inx
		cpx #$07
		bne sss_loop_5

; Video register set-up
		lda #$18
		sta $d016
		lda #$42
		sta $d018

		lda #$58
		sta screen_ram+$3f8
		sta screen_ram+$3f9

		lda #$03
		sta $d01c

		lda #$09
		sta $d025
		lda #$01
		sta $d026
		lda #$0e
		sta $d027
		sta $d028

		rts

; Playfield initialisation - PETSCII version

; Draw the top and bottom two lines
set_screen_pet	ldx #$00
ssp_loop_1	lda pet_top_edge+$000,x
		sta screen_ram+$000,x
		sta screen_ram+$398,x

		lda pet_top_edge_cl+$000,x
		sta colour_ram+$000,x
		sta colour_ram+$398,x
		inx
		cpx #$50
		bne ssp_loop_1

; Draw the seperators between tile rows
		ldx #$00
ssp_loop_2	lda pet_sep,x
		sta screen_ram+$050,x
		sta screen_ram+$0f0,x
		sta screen_ram+$190,x
		sta screen_ram+$230,x
		sta screen_ram+$2d0,x
		sta screen_ram+$370,x

		lda pet_sep_cl,x
		sta colour_ram+$050,x
		sta colour_ram+$0f0,x
		sta colour_ram+$190,x
		sta colour_ram+$230,x
		sta colour_ram+$2d0,x
		sta colour_ram+$370,x
		inx
		cpx #$28
		bne ssp_loop_2

; Draw the tile rows
		ldx #$00
ssp_loop_3	lda pet_tiles,x
		sta screen_ram+$078,x
		sta screen_ram+$118,x
		sta screen_ram+$1b8,x
		sta screen_ram+$258,x
		sta screen_ram+$2f8,x

		lda pet_tiles_col,x
		sta colour_ram+$078,x
		sta colour_ram+$118,x
		sta colour_ram+$1b8,x
		sta colour_ram+$258,x
		sta colour_ram+$2f8,x
		inx
		cpx #$78
		bne ssp_loop_3

; Set the score bar and colour
		ldx #$00
ssp_loop_4	lda scr_score_text,x
		sta screen_ram+$09a,x
		lda #$02
		sta colour_ram+$09a,x
		lda #$0a
		sta colour_ram+$0c2,x

		lda scr_high_text,x
		sta screen_ram+$112,x
		lda #$05
		sta colour_ram+$112,x
		lda #$0d
		sta colour_ram+$13a,x

		lda scr_timer_text,x
		sta screen_ram+$18a,x
		lda #$06
		sta colour_ram+$18a,x
		lda #$0e
		sta colour_ram+$1b2,x
		inx
		cpx #$05
		bne ssp_loop_4

; Set the Blok Copy logo up
		ldx #$00
ssp_loop_5	lda pet_logo_1,x
		sta screen_ram+$229,x
		lda pet_logo_2,x
		sta screen_ram+$251,x
		lda pet_logo_3,x
		sta screen_ram+$279,x
		lda pet_logo_4,x
		sta screen_ram+$2a1,x
		lda pet_logo_5,x
		sta screen_ram+$2c9,x
		lda pet_logo_6,x
		sta screen_ram+$2f1,x
		lda pet_logo_7,x
		sta screen_ram+$319,x
		lda pet_logo_8,x
		sta screen_ram+$341,x
		lda pet_logo_9,x
		sta screen_ram+$369,x

		lda pet_logo_col_1,x
		sta colour_ram+$229,x
		lda pet_logo_col_2,x
		sta colour_ram+$251,x
		lda pet_logo_col_3,x
		sta colour_ram+$279,x
		lda pet_logo_col_4,x
		sta colour_ram+$2a1,x
		lda pet_logo_col_5,x
		sta colour_ram+$2c9,x
		lda pet_logo_col_6,x
		sta colour_ram+$2f1,x
		lda pet_logo_col_7,x
		sta colour_ram+$319,x
		lda pet_logo_col_8,x
		sta colour_ram+$341,x
		lda pet_logo_col_9,x
		sta colour_ram+$369,x

		inx
		cpx #$07
		bne ssp_loop_5

; Video register set-up
ssp_nogreen	lda #$08
		sta $d016
		lda #$46
		sta $d018

		lda #$59
		sta screen_ram+$3f8
		sta screen_ram+$3f9

		lda #$00
		sta $d01c

		lda #$0a
		sta $d027
		sta $d028

		rts

; Read and interpret the joystick values
joy_scan	lda $dc00
		sta joy_reg

; Check to see if the fire button is down
		lda joy_reg
		and #$10
		bne *+$05
		jmp joy_fire_up

; Decrease the joystick delay
		ldx joy_delay
		dex
		stx joy_delay
		cpx #$ff
		beq joy_go
		rts

; Joystick controls
joy_go		inc joy_delay

; Joystick up - without fire button
joy_up		lsr joy_reg
		bcs joy_down

		ldx cursor_y
		dex
		cpx #$ff
		bne *+$04
		ldx #$04
		stx cursor_y

		jsr cursor_draw

		ldy #$06
		sty joy_delay

; Joystick down - without fire button
joy_down	lsr joy_reg
		bcs joy_left

		ldx cursor_y
		inx
		cpx #$05
		bne *+$04
		ldx #$00
		stx cursor_y

		jsr cursor_draw

		ldy #$06
		sty joy_delay

; Joystick left - without fire button
joy_left	lsr joy_reg
		bcs joy_right

		ldx cursor_x
		dex
		cpx #$ff
		bne *+$04
		ldx #$06
		stx cursor_x

		jsr cursor_draw

		ldy #$06
		sty joy_delay

; Joystick right - without fire button
joy_right	lsr joy_reg
		bcs joy_out

		ldx cursor_x
		inx
		cpx #$07
		bne *+$04
		ldx #$00
		stx cursor_x

		jsr cursor_draw

		ldy #$06
		sty joy_delay


joy_out		rts

; Joystick up - with fire button
joy_fire_up	lsr joy_reg
		bcs joy_fire_down

		jsr move_up
		ldy #$10
		sty joy_delay

; Joystick down - with fire button
joy_fire_down	lsr joy_reg
		bcs joy_fire_left

		jsr move_down
		ldy #$10
		sty joy_delay

; Joystick left - with fire button
joy_fire_left	lsr joy_reg
		bcs joy_fire_right

		jsr move_left
		ldy #$10
		sty joy_delay

; Joystick right - with fire button
joy_fire_right	lsr joy_reg
		bcs joy_fire_out

		jsr move_right
		ldy #$10
		sty joy_delay

joy_fire_out	rts

; Display the player's cursors
cursor_draw	lda cursor_x
		asl
		asl
		asl
		asl
		asl
		clc
		adc #$30
		sta $d000
		sta $d002

		lda cursor_y
		asl
		asl
		asl
		asl
		asl
		clc
		adc #$43
		sta $d001
		clc
		adc #$20
		sta $d003

		rts

; Playfield shuffle - current column upwards
move_up		ldx #$00
mu_loop		stx rt_store_1

		jsr sync_wait
		jsr house_keep

		jsr shunt_up
		ldx rt_store_1
		inx
		cpx #$04
		bne mu_loop

		ldx cursor_x
		ldy play_area+$00,x
		lda play_area+$08,x
		sta play_area+$00,x
		lda play_area+$10,x
		sta play_area+$08,x
		lda play_area+$18,x
		sta play_area+$10,x
		lda play_area+$20,x
		sta play_area+$18,x
		tya
		sta play_area+$20,x

		rts

; Playfield shuffle - current column downwards
move_down	ldx #$00
md_loop		stx rt_store_1

		jsr sync_wait
		jsr house_keep

		jsr shunt_down
		ldx rt_store_1
		inx
		cpx #$04
		bne md_loop

		ldx cursor_x
		ldy play_area+$20,x
		lda play_area+$18,x
		sta play_area+$20,x
		lda play_area+$10,x
		sta play_area+$18,x
		lda play_area+$08,x
		sta play_area+$10,x
		lda play_area+$00,x
		sta play_area+$08,x
		tya
		sta play_area+$00,x

		rts

; Playfield shuffle - current row left
move_left	ldx #$00
ml_loop		stx rt_store_1

		jsr sync_wait
		jsr house_keep

		jsr shunt_left
		ldx rt_store_1
		inx
		cpx #$04
		bne ml_loop

		lda cursor_y
		asl
		asl
		asl
		tay
		lda play_area,y
		pha
		sty rt_store_2
		ldx #$00
pa_left_loop	lda play_area+$01,y
		sta play_area+$00,y
		iny
		inx
		cpx #$06
		bne pa_left_loop
		pla
		ldy rt_store_2
		sta play_area+$06,y

		rts

; Playfield shuffle - current row right
move_right	ldx #$00
mr_loop		stx rt_store_1

		jsr sync_wait
		jsr house_keep

		jsr shunt_right
		ldx rt_store_1
		inx
		cpx #$04
		bne mr_loop

		lda cursor_y
		asl
		asl
		asl
		tay
		lda play_area+$06,y
		pha
		sty rt_store_2
		tya
		clc
		adc #$05
		tay
		ldx #$05
pa_right_loop	lda play_area+$00,y
		sta play_area+$01,y
		dey
		dex
		cpx #$ff
		bne pa_right_loop
		pla
		ldy rt_store_2
		sta play_area,y

		rts

; Screen RAM update - move column of tiles upwards
shunt_up	ldx cursor_x
		ldy cur_x_off,x

; Screen RAM shunt
		ldx #$00
shup_loop	lda screen_ram+$078,y
		sta screen_ram+$050,y
		lda screen_ram+$0a0,y
		sta screen_ram+$078,y
		lda screen_ram+$0c8,y
		sta screen_ram+$0a0,y
		lda screen_ram+$0f0,y
		sta screen_ram+$0c8,y
		lda screen_ram+$118,y
		sta screen_ram+$0f0,y

		lda screen_ram+$140,y
		sta screen_ram+$118,y
		lda screen_ram+$168,y
		sta screen_ram+$140,y
		lda screen_ram+$190,y
		sta screen_ram+$168,y
		lda screen_ram+$1b8,y
		sta screen_ram+$190,y
		lda screen_ram+$1e0,y
		sta screen_ram+$1b8,y

		lda screen_ram+$208,y
		sta screen_ram+$1e0,y
		lda screen_ram+$230,y
		sta screen_ram+$208,y
		lda screen_ram+$258,y
		sta screen_ram+$230,y
		lda screen_ram+$280,y
		sta screen_ram+$258,y
		lda screen_ram+$2a8,y
		sta screen_ram+$280,y

		lda screen_ram+$2d0,y
		sta screen_ram+$2a8,y
		lda screen_ram+$2f8,y
		sta screen_ram+$2d0,y
		lda screen_ram+$320,y
		sta screen_ram+$2f8,y
		lda screen_ram+$348,y
		sta screen_ram+$320,y
		lda screen_ram+$370,y
		sta screen_ram+$348,y

		lda screen_ram+$050,y
		sta screen_ram+$370,y

; Colour RAM shunt
		lda colour_ram+$078,y
		sta colour_ram+$050,y
		lda colour_ram+$0a0,y
		sta colour_ram+$078,y
		lda colour_ram+$0c8,y
		sta colour_ram+$0a0,y
		lda colour_ram+$0f0,y
		sta colour_ram+$0c8,y
		lda colour_ram+$118,y
		sta colour_ram+$0f0,y

		lda colour_ram+$140,y
		sta colour_ram+$118,y
		lda colour_ram+$168,y
		sta colour_ram+$140,y
		lda colour_ram+$190,y
		sta colour_ram+$168,y
		lda colour_ram+$1b8,y
		sta colour_ram+$190,y
		lda colour_ram+$1e0,y
		sta colour_ram+$1b8,y

		lda colour_ram+$208,y
		sta colour_ram+$1e0,y
		lda colour_ram+$230,y
		sta colour_ram+$208,y
		lda colour_ram+$258,y
		sta colour_ram+$230,y
		lda colour_ram+$280,y
		sta colour_ram+$258,y
		lda colour_ram+$2a8,y
		sta colour_ram+$280,y

		lda colour_ram+$2d0,y
		sta colour_ram+$2a8,y
		lda colour_ram+$2f8,y
		sta colour_ram+$2d0,y
		lda colour_ram+$320,y
		sta colour_ram+$2f8,y
		lda colour_ram+$348,y
		sta colour_ram+$320,y
		lda colour_ram+$370,y
		sta colour_ram+$348,y

		lda colour_ram+$050,y
		sta colour_ram+$370,y

		iny
		inx
		cpx #$03
		beq *+$05
		jmp shup_loop

		rts

; Screen RAM update - move column of tiles downwards
shunt_down	ldx cursor_x
		ldy cur_x_off,x

; Screen RAM shunt
		ldx #$00
shdown_loop	lda screen_ram+$348,y
		sta screen_ram+$370,y
		lda screen_ram+$320,y
		sta screen_ram+$348,y
		lda screen_ram+$2f8,y
		sta screen_ram+$320,y
		lda screen_ram+$2d0,y
		sta screen_ram+$2f8,y
		lda screen_ram+$2a8,y
		sta screen_ram+$2d0,y

		lda screen_ram+$280,y
		sta screen_ram+$2a8,y
		lda screen_ram+$258,y
		sta screen_ram+$280,y
		lda screen_ram+$230,y
		sta screen_ram+$258,y
		lda screen_ram+$208,y
		sta screen_ram+$230,y
		lda screen_ram+$1e0,y
		sta screen_ram+$208,y

		lda screen_ram+$1b8,y
		sta screen_ram+$1e0,y
		lda screen_ram+$190,y
		sta screen_ram+$1b8,y
		lda screen_ram+$168,y
		sta screen_ram+$190,y
		lda screen_ram+$140,y
		sta screen_ram+$168,y
		lda screen_ram+$118,y
		sta screen_ram+$140,y

		lda screen_ram+$0f0,y
		sta screen_ram+$118,y
		lda screen_ram+$0c8,y
		sta screen_ram+$0f0,y
		lda screen_ram+$0a0,y
		sta screen_ram+$0c8,y
		lda screen_ram+$078,y
		sta screen_ram+$0a0,y
		lda screen_ram+$050,y
		sta screen_ram+$078,y

		lda screen_ram+$370,y
		sta screen_ram+$050,y

; Colour RAM shunt
		lda colour_ram+$348,y
		sta colour_ram+$370,y
		lda colour_ram+$320,y
		sta colour_ram+$348,y
		lda colour_ram+$2f8,y
		sta colour_ram+$320,y
		lda colour_ram+$2d0,y
		sta colour_ram+$2f8,y
		lda colour_ram+$2a8,y
		sta colour_ram+$2d0,y

		lda colour_ram+$280,y
		sta colour_ram+$2a8,y
		lda colour_ram+$258,y
		sta colour_ram+$280,y
		lda colour_ram+$230,y
		sta colour_ram+$258,y
		lda colour_ram+$208,y
		sta colour_ram+$230,y
		lda colour_ram+$1e0,y
		sta colour_ram+$208,y

		lda colour_ram+$1b8,y
		sta colour_ram+$1e0,y
		lda colour_ram+$190,y
		sta colour_ram+$1b8,y
		lda colour_ram+$168,y
		sta colour_ram+$190,y
		lda colour_ram+$140,y
		sta colour_ram+$168,y
		lda colour_ram+$118,y
		sta colour_ram+$140,y

		lda colour_ram+$0f0,y
		sta colour_ram+$118,y
		lda colour_ram+$0c8,y
		sta colour_ram+$0f0,y
		lda colour_ram+$0a0,y
		sta colour_ram+$0c8,y
		lda colour_ram+$078,y
		sta colour_ram+$0a0,y
		lda colour_ram+$050,y
		sta colour_ram+$078,y

		lda colour_ram+$370,y
		sta colour_ram+$050,y

		iny
		inx
		cpx #$03
		beq *+$05
		jmp shdown_loop

		rts

; Screen RAM update - move row of tiles left
shunt_left	lda cursor_y
		asl
		clc
		adc cursor_y
		tax

		lda cur_y_off_low+$00,x
		sta sl_loop+$01
		sta sl_loop+$04
		sta sl_write+$01
		sta sl_write+$04

		sta slc_loop+$01
		sta slc_loop+$04
		sta slc_write+$01
		sta slc_write+$04

		lda cur_y_off_high+$00,x
		sta sl_loop+$02
		sta sl_loop+$05
		sta sl_write+$02
		sta sl_write+$05

		clc
		adc #$88
		sta slc_loop+$02
		sta slc_loop+$05
		sta slc_write+$02
		sta slc_write+$05


		lda cur_y_off_low+$01,x
		sta sl_loop+$07
		sta sl_loop+$0a
		sta sl_write+$07
		sta sl_write+$0a

		sta slc_loop+$07
		sta slc_loop+$0a
		sta slc_write+$07
		sta slc_write+$0a

		lda cur_y_off_high+$01,x
		sta sl_loop+$08
		sta sl_loop+$0b
		sta sl_write+$08
		sta sl_write+$0b

		clc
		adc #$88
		sta slc_loop+$08
		sta slc_loop+$0b
		sta slc_write+$08
		sta slc_write+$0b

		lda cur_y_off_low+$02,x
		sta sl_loop+$0d
		sta sl_loop+$10
		sta sl_write+$0d
		sta sl_write+$10

		sta slc_loop+$0d
		sta slc_loop+$10
		sta slc_write+$0d
		sta slc_write+$10

		lda cur_y_off_high+$02,x
		sta sl_loop+$0e
		sta sl_loop+$11
		sta sl_write+$0e
		sta sl_write+$11

		clc
		adc #$88
		sta slc_loop+$0e
		sta slc_loop+$11
		sta slc_write+$0e
		sta slc_write+$11

; Screen and colour RAM copy
		ldx #$02
		ldy #$03
sl_loop		lda screen_ram+$78,y
		sta screen_ram+$78,x
		lda screen_ram+$a0,y
		sta screen_ram+$a0,x
		lda screen_ram+$c8,y
		sta screen_ram+$c8,x

slc_loop	lda colour_ram+$78,y
		sta colour_ram+$78,x
		lda colour_ram+$a0,y
		sta colour_ram+$a0,x
		lda colour_ram+$c8,y
		sta colour_ram+$c8,x

		iny
		inx
		cpx #$1f
		bne sl_loop

; Copy the left edge over to the right
		ldx #$02
		ldy #$1e
sl_write	lda screen_ram+$78,x
		sta screen_ram+$78,y
		lda screen_ram+$a0,x
		sta screen_ram+$a0,y
		lda screen_ram+$c8,x
		sta screen_ram+$c8,y

slc_write	lda colour_ram+$78,x
		sta colour_ram+$78,y
		lda colour_ram+$a0,x
		sta colour_ram+$a0,y
		lda colour_ram+$c8,x
		sta colour_ram+$c8,y

		rts

; Screen RAM update - move row of tiles right
shunt_right	lda cursor_y
		asl
		clc
		adc cursor_y
		tax

		lda cur_y_off_low+$00,x
		sta sr_loop+$01
		sta sr_loop+$04
		sta sr_write+$01
		sta sr_write+$04

		sta src_loop+$01
		sta src_loop+$04
		sta src_write+$01
		sta src_write+$04

		lda cur_y_off_high+$00,x
		sta sr_loop+$02
		sta sr_loop+$05
		sta sr_write+$02
		sta sr_write+$05

		clc
		adc #$88
		sta src_loop+$02
		sta src_loop+$05
		sta src_write+$02
		sta src_write+$05

		lda cur_y_off_low+$01,x
		sta sr_loop+$07
		sta sr_loop+$0a
		sta sr_write+$07
		sta sr_write+$0a

		sta src_loop+$07
		sta src_loop+$0a
		sta src_write+$07
		sta src_write+$0a

		lda cur_y_off_high+$01,x
		sta sr_loop+$08
		sta sr_loop+$0b
		sta sr_write+$08
		sta sr_write+$0b

		clc
		adc #$88
		sta src_loop+$08
		sta src_loop+$0b
		sta src_write+$08
		sta src_write+$0b

		lda cur_y_off_low+$02,x
		sta sr_loop+$0d
		sta sr_loop+$10
		sta sr_write+$0d
		sta sr_write+$10

		sta src_loop+$0d
		sta src_loop+$10
		sta src_write+$0d
		sta src_write+$10

		lda cur_y_off_high+$02,x
		sta sr_loop+$0e
		sta sr_loop+$11
		sta sr_write+$0e
		sta sr_write+$11

		clc
		adc #$88
		sta src_loop+$0e
		sta src_loop+$11
		sta src_write+$0e
		sta src_write+$11

; Screen and colour RAM copy
		ldx #$1d
		ldy #$1e
sr_loop		lda screen_ram+$78,x
		sta screen_ram+$78,y
		lda screen_ram+$a0,x
		sta screen_ram+$a0,y
		lda screen_ram+$c8,x
		sta screen_ram+$c8,y

src_loop	lda colour_ram+$78,x
		sta colour_ram+$78,y
		lda colour_ram+$a0,x
		sta colour_ram+$a0,y
		lda colour_ram+$c8,x
		sta colour_ram+$c8,y

		dey
		dex
		cpx #$01
		bne sr_loop

; Copy the right edge over to the left
		ldx #$1e
		ldy #$02
sr_write	lda screen_ram+$78,x
		sta screen_ram+$78,y
		lda screen_ram+$a0,x
		sta screen_ram+$a0,y
		lda screen_ram+$c8,x
		sta screen_ram+$c8,y

src_write	lda colour_ram+$78,x
		sta colour_ram+$78,y
		lda colour_ram+$a0,x
		sta colour_ram+$a0,y
		lda colour_ram+$c8,x
		sta colour_ram+$c8,y

		rts

; Raster synchronisation wait
sync_wait	lda #$00
		sta sync
sw_loop		cmp sync
		beq sw_loop

		rts

; Wait for Y frames
sync_wait_long	jsr sync_wait
		dey
		bne sync_wait_long

		rts

; Decrease the timer
house_keep	jsr down_time
		sty rt_store_4

; Update the on-screen score and high score
		ldx #$00
score_copy	lda score,x
		ora #$30
		tay
		lda char_decode,y
		sta screen_ram+$0c2,x
		lda highscore,x
		ora #$30
		tay
		lda char_decode,y
		sta screen_ram+$13a,x
		inx
		cpx #$05
		bne score_copy

		lda time+$00
		ora #$30
		tay
		lda char_decode,y
		sta screen_ram+$1b3

		lda time+$01
		ora #$30
		tay
		lda char_decode,y
		sta screen_ram+$1b4

		lda time+$02
		ora #$30
		tay
		lda char_decode,y
		sta screen_ram+$1b5

		ldy rt_store_4

		rts

; Time updater
down_time	lda game_over_flag
		beq *+$03
		rts

		ldx time+$03
		dex
		cpx #$ff
		bne t3_xb

		jsr score_bump
		jsr score_bump

		ldx #$02
dt_loop		lda time,x
		sec
		sbc #$01
		sta time,x
		cmp #$ff
		bne dtl_out
		lda #$09
		sta time,x
		dex
		cpx #$ff
		bne dt_loop

dtl_out		ldx #$00

		ldx #$31
t3_xb		stx time+$03

		ldx #$00
dt_scan		lda time,x
		bne dts_out
		inx
		cpx #$04
		bne dt_scan

		lda #$01
		sta game_over_flag

dts_out		rts

; Score handling - add 10 points
score_bump_10	ldx #$03
		jmp bs_loop

; Score handling - add 1 point
score_bump	ldx #$04
bs_loop		lda score,x
		clc
		adc #$01
		sta score,x
		cmp #$0a
		bne bsl_out
		lda #$00
		sta score,x
		dex
		cpx #$ff
		bne bs_loop

; Compare the score and high score
bsl_out		ldx #$00
score_scan	lda score,x
		cmp highscore,x
		bcc xx_cs
		beq no_cs
		bcs copy_score
no_cs		inx
		cpx #$05
		bne score_scan
xx_cs		rts

; The score is greater, so overwrite the high score
copy_score	ldx #$00
cs_loop		lda score,x
		sta highscore,x
		inx
		cpx #$05
		bne cs_loop

		rts

; Pseudo random number generator
random		lda rnd_seed
		clc
		adc #$69
		eor rnd_seed_2
		sta rnd_seed

		tax
		lda rnd_seed_2
		adc $0900,x
		sta rnd_seed_2

		rts

; Wipe the playfield between titles and game
wipe_screen	ldx #$00
		ldy #$27
ws_loop		jsr sync_wait

		lda #$00
		sta screen_ram+$000,x
		sta screen_ram+$028,y
		sta screen_ram+$050,x
		sta screen_ram+$078,y
		sta screen_ram+$0a0,x

		sta screen_ram+$0c8,y
		sta screen_ram+$0f0,x
		sta screen_ram+$118,y
		sta screen_ram+$140,x
		sta screen_ram+$168,y

		sta screen_ram+$190,x
		sta screen_ram+$1b8,y
		sta screen_ram+$1e0,x
		sta screen_ram+$208,y
		sta screen_ram+$230,x

		sta screen_ram+$258,y
		sta screen_ram+$280,x
		sta screen_ram+$2a8,y
		sta screen_ram+$2d0,x
		sta screen_ram+$2f8,y

		sta screen_ram+$320,x
		sta screen_ram+$348,y
		sta screen_ram+$370,x
		sta screen_ram+$398,y
		sta screen_ram+$3c0,x
		dey
		inx
		cpx #$28
		bne ws_loop

; Turn the screen off
		jsr sync_wait
		lda #$0b
		sta d011_mirror

; Wait for a couple of seconds
		ldy #$64
		jsr sync_wait_long

; Debounce the fire button
ws_fire_db	jsr sync_wait

		lda $dc00
		and #$10
		beq ws_fire_db

		rts

; Completion screen effect handling
gd_buffer_move	ldx #$26
gd_bm_loop	lda gd_buffer+$00,x
		sta gd_buffer+$01,x
		dex
		cpx #$ff
		bne gd_bm_loop

; Two versions depending on if we're in PETSCII mode or not...
		lda petscii_flag
		bne gd_upd_petscii

; Standard mode
gd_upd_standard	ldx gd_wipe_cnt
		lda gd_wipe,x
		sta gd_buffer
		inx
		cpx #$0a
		bne *+$04
		ldx #$00
		stx gd_wipe_cnt

		rts

; PETSCII mode
gd_upd_petscii	ldx gd_wipe_cnt
		lda gd_pet_wipe,x
		sta gd_buffer
		inx
		cpx #$20
		bne *+$04
		ldx #$00
		stx gd_wipe_cnt

		rts

; Clear the completion screen buffer
gd_buffer_clr	ldx #$00
gd_bc_loop	sta gd_buffer,x
		inx
		cpx #$28
		bne gd_bc_loop

		lda #$00
		sta gd_wipe_cnt
		rts


; IRQ interrupt
int		pha
		txa
		pha
		tya
		pha

		lda $d019
		and #$01
		sta $d019
		bne ya
		jmp ea31

ya		lda rn
		cmp #$02
		beq rout2

; Raster split 1
rout1		lda #$00
		sta $d020
		sta $d021

		lda d011_mirror
		sta $d011

; Play the music
		jsr music+$03

; Set up for the second raster split
		lda #$02
		sta rn
		lda #rstr2p
		sta $d012

; Exit the interrupt
		jmp ea31

; Raster split 2
rout2		lda #$01
		sta sync

; Set up for the first raster split
		lda #$01
		sta rn
		lda #rstr1p
		sta $d012

; Exit interrupt
ea31		pla
		tay
		pla
		tax
		pla
nmi		rti


; Character decoding table (for text and numbers)
char_decode	!byte $00,$01,$02,$03,$04,$05,$06,$07	; @ to G
		!byte $08,$09,$0a,$0b,$0c,$0d,$0e,$0f	; H to O
		!byte $10,$11,$12,$13,$14,$15,$16,$17	; P to W
		!byte $18,$19,$1a,$00,$00,$00,$00,$00	; X to back arrow

		!byte $00,$1b,$00,$00,$00,$00,$00,$00	; space to '
		!byte $00,$00,$2c,$00,$1d,$1e,$1c,$00	; ( to /
		!byte $20,$21,$22,$23,$24,$25,$26,$27	; 0 to 7
		!byte $28,$29,$2a,$2b,$00,$00,$00,$00	; 8 to ?

; In-game message text
gamovr_text	!scr "game over"
levnum_text	!scr "level  00"
getrdy_text	!scr "get ready"

; In-game status area text
scr_score_text	!scr "score"
scr_high_text	!scr "@top@"
scr_timer_text	!scr "timer"

; In-game cursor offsets
cur_x_off	!byte $03,$07,$0b,$0f,$13,$17,$1b

cur_y_off_low	!byte <screen_ram+$078
		!byte <screen_ram+$0a0
		!byte <screen_ram+$0c8

		!byte <screen_ram+$118
		!byte <screen_ram+$140
		!byte <screen_ram+$168

		!byte <screen_ram+$1b8
		!byte <screen_ram+$1e0
		!byte <screen_ram+$208

		!byte <screen_ram+$258
		!byte <screen_ram+$280
		!byte <screen_ram+$2a8

		!byte <screen_ram+$2f8
		!byte <screen_ram+$320
		!byte <screen_ram+$348

cur_y_off_high	!byte >screen_ram+$078
		!byte >screen_ram+$0a0
		!byte >screen_ram+$0c8

		!byte >screen_ram+$118
		!byte >screen_ram+$140
		!byte >screen_ram+$168

		!byte >screen_ram+$1b8
		!byte >screen_ram+$1e0
		!byte >screen_ram+$208

		!byte >screen_ram+$258
		!byte >screen_ram+$280
		!byte >screen_ram+$2a8

		!byte >screen_ram+$2f8
		!byte >screen_ram+$320
		!byte >screen_ram+$348

; In-game "joystick" commands used by the playfield scrambling routine
scram_joy	!byte $f7,$fe,$fb,$fd

; In-game playfield RAM
play_area	!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00

; Source files for data used to build the various screens
		!src "includes/title_screen.asm"
		!src "includes/ingame_screen.asm"
		!src "includes/petscii_screen.asm"
		!src "includes/end_screen.asm"

