extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4:
	;Busco hacer x1 - x2 + x3 - x4
    ;prologo
    push rbp ; alineado a 16
    mov rbp,rsp

    ; COMPLETAR
    sub rdi, rsi        ; rdi: x1 <- x1 - x2
    sub rdx, rcx        ; rdx: x3 <- x3 - x4
    add rdi, rdx        ; rdi: (x1 + x2) <- (x1 - x2) + (x3 - x4)
    mov rax, rdi        ; muevo la respuesta a rax


    ;epilogo
    add rbp, rsp
    pop rbp

    ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;prologo
    push rbp ; alineado a 16
    mov rbp,rsp

    call restar_c
    mov rax, rdi
    mov rdi, rdx
    mov rsi, rcx
    call restar_c
    mov rsi, rdi
    mov rdi, rax
    call sumar_c
    mov rax, rdi

    ;epilogo
    add rbp, rsp
    pop rbp
    ret


; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4_simplified:
    sub rdi, rsi        ; rdi: x1 <- x1 - x2
    sub rdx, rcx        ; rdx: x3 <- x3 - x4
    add rdi, rdx        ; rdi: (x1 + x2) <- (x1 - x2) + (x3 - x4)
    mov rax, rdi        ; muevo la respuesta a rax


	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[rdi], x2[rsi], x3[rdx], x4[rcx], x5[r8], x6[r9], x7[rsp + 2 * 8], x8[rsp + 2 * 16]
alternate_sum_8:
    ;x1 - x2 + x3 - x4 + x5 - x6 + x7 - x8
	;prologo
    push rbp ; alineado a 16
    mov rbp,rsp

	; COMPLETAR
    call alternate_sum_4        ;rdi: x1 <- (x1 - x2) + (x3 - x4)
    mov rax, rdi

    mov rdi, r8
    mov rsi, r9
    mov rdx, [rsp + 2 * 8]
    mov rcx, [rsp + 3 * 8]

    call alternate_sum_4
    add rax, rdi

	;epilogo
	pop rbp
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
    ;prologo
    push rbp ; alineado a 16
    mov rbp,rsp

    ;COMPLETAR
    cvtsi2ss xmm1, rsi              ; convierto el int de x1 en float y lo guardo en xmm1
                                    ; recordar que los xmm estan diseñados para guardar floats
    mulss xmm1, xmm0                 ; multiplico x1 * x2 y lo guardo en xmm1
    cvttss2si [rdi], xmm1

	ret

    ;epilogo
    pop rbp
    ret
