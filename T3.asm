;autor_Israel Hernandez Alvarez
;inicio de secion con nip y con numero de intentos

	.org 0000h;inicio
	ld a,89h
	out (cw),a
inicio:
	ld hl,text1
	call muestra
	call clave
	call compara

muestra:

	ld a,(hl)
	cp "&"
	jp z, listo
	out (lcd),a
	inc hl
	jp muestra

listo:
	ret


clave:
	ld hl,passw
	ld b,4

	call leer
	ret

leer:
	in a,(nip)
	cp 30h;comparacion para checar si es numero
	jp c, letra
	cp 3Ah
	jp nc,letra
	ld (hl),a
	ld a, 2ah;cambia el valor ingresado por un * y lo muestra
	out (LCD), a
	inc hl
	djnz leer
	ret
letra:
	ld hl, text4
le:
	ld a,(hl)
	cp "&"
	jp z, clave
	out (lcd),a
	inc hl
	jp le

compara:
	ld hl, passw
	ld de, contra
	ld b,4
	call com
	call bien
com:
	ld a,(de)
	ld c,(hl)
	cp c
	jp nz, mal
	inc hl
	inc de
	djnz com
	ret


bien:
	ld hl, text3
nipb:
	ld a,(hl)
	cp "&"
	jp z, fin
	out (lcd),a
	inc hl
	jp nipb
mal:
	ld hl, text2
	ld de, conta
	ld a, (de)
	dec a
	ld (de),a
	cp 0
	jp z, fallo

nipm:
	ld a,(hl)
	cp "&"
	jp z, inicio
	out (lcd),a
	inc hl
	jp nipm

fallo:
	ld hl, text5

fa:
	ld a,(hl)
	cp "&"
	jp z, fin
	out (lcd),a
	inc hl
	jp fa



;--------------------------------
	.org 2000h
;puertos
lcd:	.equ 00h
nip:	.equ 01h
cw:	.equ 03h
;variables
conta	.db 03h
text1	.db "ingrese nip: &"
text2	.db "intente nuevamente&"
text3	.db "bienvenido&"
text4:	.db "ingrese solamente numeros&"
text5:	.db "demasiados intentos fallidos&"

passw	.db 00h, 00h, 00h, 00h
contra	.db "1234"
int	.db "4"


fin:
	.end