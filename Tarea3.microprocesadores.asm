;Author: Israel Hernandez Alvarez
;comparador de nip

;inicio de codigo ensamblador

	.org 0000h
	ld a,89h
	out (CW), a
	ld SP,27ffh

	ld hl, text1
	call disp_text
	call read_password
	call com_nip


	halt
;llamado a subrutinas
subr:
	call read_password
	call repeat2
	call mintent

read_password:
	ld hl,passw
	ld b,4

read_other:

        in a,(KEYB)
        cp 29
        jp P, M1
        halt
M1:
	cp 39h
	jp p, M2
	;jr error
;	ret
	halt
M2:
	cp 30h
	jp C, read_other

	ld (hl),a
	inc hl
	ld a, "*"
	out (LCD), a

        djnz read_other
        ret


;subrutinas

disp_text:
repeat1:
	ld a,(hl)
	cp "&"
	jp z,end_sub1
	out (LCD),a
	inc hl
	jp repeat1

end_sub1:
	ret





repeat2:
	ld a, (hl)
 	cp "&"
	jp z, read_password
	out (LCD), a
	inc hl
	jp repeat2


;comparacion de nip
com_nip:
	ld hl, passw
	ld de, pattern
	ld b, 4 ;por que son 4 digitos

com_cicl:
	ld c, (hl)
	ld a, (de)
	cp c
	jp nz, nip_err
	inc de
	inc hl
	djnz  com_cicl

	ld hl, corr_nip

repeat3:
	ld a, (hl)
 	cp "&"
	jp z, fin
	out (LCD), a
	inc hl
	jp repeat3



;nip_corr: (probar)
	;ld hl,corr_nip
	;ld a,(hl)

	;call disp_text
	;jp fin

nip_err:
	ld hl, err_nip
	;ld de, CW
	ld a,(de)
	dec a
	ld (de),a
	cp 0
	jp nz, error
	ret

error:
	ld a,(hl)
	cp "&"
	jp z, subr
	out (LCD), a
	inc hl
	jp error

	halt


mintent:
	ld hl, err_nip

repeat4:
	ld a, (hl)
 	cp "&"
	jp z, fin
	out (LCD), a
	inc hl
	jp repeat4



fin:
	halt

;fin de comparacion de nip(quitar)

;memoria
	.org 2000h
text1:	.db "NIP: &"


text_equivocado: .db "demaciados intentos&"
corr_nip: .db "el nip es correcto &"
err_nip: .db "el nip ingresado es erroneo, intente nuevamente&"

pattern: .db "1234"
passw:	.db 00h,00h,00h,00h


;constantes
LCD:	.equ 00h
KEYB:	.equ 01h
CW	.equ 03h


	.end