
section .text

section .data
mascara: db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
;mascara vale 8 * 16 = 128 bits, es decir que es un double quadword (64 * 2 bits)
global invertirBytes_asm
extern invertirBytes_c
; void invertirBytes_asm(uint8_t* p, uint8_t n, uint8_t m)
;rdi = [p] , rsi(sil) = n , rdx(dh/dl) = m
invertirBytes_asm:
    ;prologo
    push rbp
    mov rbp, rsp

    ;Completar

    ;guardar la mask intacta en xmm2
    movdqu xmm2, [mascara]

    ;guardamos en xmm1 la mascara que vamos a usar
    movdqu xmm1, [mascara]
    ;guardamos en xmm0 el array de rdi
    movdqu xmm0, [rdi]

    mov byte [mascara + rsi], dl            ; cambiamos n por m en la mask
    mov byte [mascara + rdx], sil           ; cambiamos m por n en la mask
    ; Si n = 4 y m = 10 -> mascara: 0, 1, 2, 3, 10, 5, 6, 7, 8, 9, 4, 11, 12, 13, 14, 15

    pshufb xmm0, xmm1                       ; en xmm0 obtenemos los valores reordenados
    movdqu [rdi], xmm0                      ; devolvemos el array al puntero de rdi

    movdqu xmm1, xmm2                       ; cambiamos el viejo mask por el nuevo

    ;epilogo
    add rbp, rsp
    pop rbp

	ret