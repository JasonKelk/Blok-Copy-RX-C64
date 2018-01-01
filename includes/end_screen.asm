;
; BLOK COPY RX COMPLETION SCREEN DATA
;

; Completion text
gd_text		!scr " all levels re-synchronised! "

; Completion screen logo - standard version
gd_logo		!scr "@@@@@@@@@@@@@kk@oo@@@@oo@@@@@@@@@@@@@@@@"
		!scr "@ll@@@l@@mm@@kk@oo@@@ooo@@kk@@@mm@@@ll@@"
		!scr "@ll@l@l@mm@m@kk@oo@@o@oo@k@kk@m@mm@ll@l@"
		!scr "@ll@l@l@mmm@@kk@oo@@o@oo@k@kk@m@mm@lll@@"
		!scr "@ll@l@l@mm@@@kk@oo@@o@oo@k@kk@m@mm@ll@@@"
		!scr "@@llll@@@mm@@kk@oo@@@ooo@@kk@@m@mm@@ll@@"

; Completion screen logo - PETSCII version
gd_pet_logo	!scr "@@@@@@@@@@@@@gg@ee@@@@ee@@@@@@@@@@@@@@@@"
		!scr "@bb@@@b@@hh@@gg@ee@@@eee@@nn@@@dd@@@ff@@"
		!scr "@bb@b@b@hh@h@gg@ee@@e@ee@n@nn@d@dd@ff@f@"
		!scr "@bb@b@b@hhh@@gg@ee@@e@ee@n@nn@d@dd@fff@@"
		!scr "@bb@b@b@hh@@@gg@ee@@e@ee@n@nn@d@dd@ff@@@"
		!scr "@@bbbb@@@hh@@gg@ee@@@eee@@nn@@d@dd@@ff@@"

; Completion screen wipe effect (standard)
gd_wipe		!byte $76,$77,$78,$79,$7a,$7b,$7c,$7d
		!byte $7e,$7f

		!byte $2a,$2b,$2c,$2d,$2e,$2f,$30,$31
		!byte $32,$33

; Completion screen wipe effect (PETSCII)
gd_pet_wipe	!byte $00,$65,$74,$75,$61,$f6,$ea,$e7
		!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
		!byte $a0,$a0,$a0,$a0,$a0,$a0,$a0,$a0
		!byte $a0,$e5,$f4,$f5,$e1,$76,$6a,$67