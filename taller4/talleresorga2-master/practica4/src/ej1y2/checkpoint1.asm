section .data
	mask: db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

section .text

global invertirBytes_asm

; void invertirBytes_asm(uint8_t* p, uint8_t n, uint8_t m)
invertirBytes_asm:
	; rdi = *p, rsi(sil) = n, rdx(dl) = m
	;prologo
    push rbp
    mov rbp, rsp

	; guardemos la mascara para restaurarla luego de finalizar
	movdqu xmm2, [mask]

	; guardamos en xmm0 los valores del puntero
	movdqu xmm0, [rdi]

    ; rellenamos con 0 los bits mas bajos, porque no podemos estar seguros de que los mismos venia con 0 previamente
    movzx rsi, sil
    movzx rdx, dl

	; hacemos la alternacion de n y m en la mascara
	mov byte [mask + rsi], dl
	mov byte [mask + rdx], sil

	; guardamos la mascara en xmm1
	movdqu xmm1, [mask]

	; hacemos el shuffle
	pshufb xmm0, xmm1

	; volvemos a guardar el resultado que esta en xmm0 en el puntero de salida
	movdqu [rdi], xmm0

	; restauramos la mascara
	movdqu [mask], xmm2
	;epilogo
    pop rbp
	ret