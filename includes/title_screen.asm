;
; BLOK COPY RX TITLE SCREEN DATA
;

ttl_screen	!scr "         cosine systems present         "

		!scr "design and code         jason kelk      "
		!scr "graphics                jason kelk      "
		!scr "music composed       sean connolly      "
		!scr "developed by         cosine.org.uk      "

		!scr "        stick x move cursor horizontally"
		!scr "          stick y move cursor vertically"
		!scr "              fire button shuffles tiles"
		!scr "                                        "
		!scr "        hold fire   directions move rows"
		!scr "                    and columns of tiles"

		!scr "        press fire to start play        "

; Layout data for the title logo
ttl_logo_l1	!byte $81,$00,$00,$00,$81,$00,$00,$00
		!byte $00,$00,$81,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00

ttl_logo_l2	!byte $82,$83,$84,$85,$86,$87,$88,$89
		!byte $8a,$8b,$86,$00,$00,$00,$00,$00
		!byte $8c,$8d,$8e,$8f,$88,$89,$8a,$8b
		!byte $90,$83,$84,$85,$91,$00,$00,$00

ttl_logo_l3	!byte $92,$93,$94,$95,$86,$96,$97,$98
		!byte $97,$99,$86,$00,$9a,$9b,$00,$00
		!byte $9c,$9d,$93,$9e,$97,$98,$97,$99
		!byte $9f,$93,$94,$95,$9f,$00,$00,$a0

ttl_logo_l4	!byte $a1,$00,$00,$a2,$a3,$a4,$97,$98
		!byte $a5,$a6,$a7,$a8,$a9,$aa,$00,$00
		!byte $ab,$00,$00,$a4,$97,$98,$a5,$a6
		!byte $86,$00,$00,$a2,$ac,$00,$00,$86

ttl_logo_l5	!byte $ad,$83,$ae,$af,$b0,$b1,$97,$b2
		!byte $b3,$b4,$b5,$00,$b6,$b7,$00,$00
		!byte $b8,$b9,$8e,$ba,$97,$b2,$b3,$b4
		!byte $bb,$83,$ae,$af,$b8,$b9,$8d,$bc

ttl_logo_l6	!byte $bd,$93,$93,$be,$bf,$c0,$c1,$c2
		!byte $c3,$c4,$c5,$00,$00,$c6,$00,$00
		!byte $c7,$c8,$93,$93,$c1,$c2,$c3,$c4
		!byte $ca,$93,$93,$be,$c7,$c8,$cb,$cc

ttl_logo_l7	!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $00,$00,$00,$00,$00,$00,$00,$00
		!byte $cd,$00,$00,$00,$00,$ce,$cf,$d0

; Layout data for the title logo colour
ttl_logo_l1c	!byte $0f,$01,$01,$01,$0f,$01,$01,$01
		!byte $01,$01,$0f,$01,$01,$01,$01,$01
		!byte $01,$01,$01,$01,$01,$01,$01,$01
		!byte $01,$01,$01,$01,$01,$01,$01,$01

ttl_logo_l2c	!byte $0f,$0f,$0f,$0f,$0f,$0d,$0b,$0f
		!byte $0a,$0a,$0f,$01,$01,$01,$01,$01
		!byte $0f,$0f,$0f,$0f,$0b,$0f,$0a,$0a
		!byte $0f,$0f,$0f,$0f,$0f,$01,$01,$01

ttl_logo_l3c	!byte $0b,$0b,$0b,$0b,$0b,$0d,$0b,$0f
		!byte $0a,$0a,$0b,$01,$0b,$0b,$01,$01
		!byte $0b,$0b,$0b,$0d,$0b,$0f,$0a,$0a
		!byte $0b,$0b,$0b,$0b,$0b,$01,$01,$0b

ttl_logo_l4c	!byte $0b,$01,$01,$0b,$0b,$0d,$0b,$0f
		!byte $0a,$0a,$0b,$0b,$0b,$0b,$01,$01
		!byte $0b,$01,$01,$0d,$0b,$0f,$0a,$0a
		!byte $0b,$01,$01,$0b,$0b,$01,$01,$0b

ttl_logo_l5c	!byte $0d,$0d,$0d,$0d,$0d,$0d,$0b,$0f
		!byte $0a,$0a,$0d,$01,$0d,$0d,$01,$01
		!byte $0d,$0d,$0d,$0d,$0b,$0f,$0a,$0a
		!byte $0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d

ttl_logo_l6c	!byte $0d,$0d,$0d,$0d,$0d,$0d,$0b,$0f
		!byte $0a,$0a,$0d,$01,$01,$0d,$01,$01
		!byte $0d,$0d,$0d,$0d,$0b,$0f,$0a,$0a
		!byte $0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d

ttl_logo_l7c	!byte $01,$01,$01,$01,$01,$01,$01,$01
		!byte $01,$01,$01,$01,$01,$01,$01,$01
		!byte $01,$01,$01,$01,$01,$01,$01,$01
		!byte $0d,$01,$01,$01,$01,$0d,$0d,$0d

; Titles screen data
ttl_scrl_ctab	!byte $0a,$0c,$0d,$0b,$0f,$0b,$0d,$0c

ttl_spr_pos	!byte $18,$a3,$30,$a3,$18,$b8,$30,$b8
		!byte $18,$cd,$30,$cd,$38,$82,$38,$92
		!byte $c0

ttl_joy_col	!byte $0d,$0a,$0d,$0a,$0d
		!byte $0a,$0a,$0a,$0a,$0a
		!byte $0d,$0d,$0d,$0d,$0d
		!byte $0d,$0b,$0b,$0d,$0d
		!byte $0d,$0d,$0d,$0d,$0d
		!byte $0d,$0d,$0d,$0d,$0d

; Titles screen scrolling message
ttl_scroll	!scr "last score "
ttl_last_score	!byte $00,$00,$00,$00,$00
		!scr "      high score "
ttl_high_score	!byte $00,$00,$00,$00,$00

		!scr ".:.    * cosine present in 2018    .:."
		!scr " . : .    b l o k    c o p y    . : . "
		!scr ".:.   commodore 64 remix edition   .:."

		!scr " design and code by        jason kelk "
		!scr " graphics by               jason kelk "
		!scr " music composed by      sean connolly "

		!scr " .:.             .::.             .:. "

		!scr "   cosines greetings go out towards   "
		!scr "     absence     abyss connection     "
		!scr "      arkanix labs      artstate      "
		!scr " ate bit     atlantis    booze design "
		!scr "  camelot    censor design    chorus  "
		!scr "  chrome    cncd     cpu    crescent  "
		!scr "crest   covert  bitops  defence  force"
		!scr " dekadence    desire    dac    dmagic "
		!scr "      dual crew     exclusive on      "
		!scr "     fairlight     f4cg      fire     "
		!scr "   flat 3     focus    french touch   "
		!scr "      funkscientist  productions      "
		!scr "   genesis  project    gheymaid inc   "
		!scr "       hitmen      hokuto force       "
		!scr "     legion of doom      level 64     "
		!scr "    maniacs of noise        mayday    "
		!scr "   meanteam    metalvotze    noname   "
		!scr "    nostalgia    nuance    offence    "
		!scr "     onslaught     orb     oxyron     "
		!scr " padua    performers    plush    ppcs "
		!scr "       psytronik       reptilia       "
		!scr "resource     rgcd     secure     shape"
		!scr "side b   singular   slash   slipstream"
		!scr "      success and trc      style      "
		!scr "    suicyco industries     taquart    "
		!scr "       tempest     tek    triad       "
		!scr "   tristar and red sector     viruz   "
		!scr " vision   wow   wrath designs   xenon "

		!scr " and to anyone else out there who are "
		!scr "   still making and enjoying decent   "
		!scr " homebrew for consoles and computers! "

		!scr " .:.             .::.             .:. "

		!scr "blok copy is dedicated to the crews of"
		!scr "doctor who,torchwood and sj adventures"
		!scr "    rest in peace  verity lambert,    "
		!scr "nicholas courtney and elisabeth sladen"

		!scr " .:.             .::.             .:. "

		!scr " visit our website for more 8-bit fun "
		!scr "          at   cosine.org.uk          "

		!scr " .:.             .::.             .:. "

		!byte $00