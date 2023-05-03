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
    ;x1 = rdi, x2 = rsi, x3 = rdx, x4 = rcx
	;prologo
	push rbp
    mov rbp, rsp

	sub rdi, rsi    ; x1 - x2
    sub rdx, rcx    ; x3 - x4
    add rdi, rdx    ; (x1 - x2) + (x3 - x4)

    mov rax, rdi    ; Movemos el valor de rdi(respuesta) al registro de salida

	;epilogo
    pop rbp
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;prologo
	push rbp
	mov rbp,rsp

    ; rdi = x1, rsi = x2, rdx = x3, rcx = x4
    ; restamos 'x1' y 'x2'. ya que estan en los registros que necesita la funcion
	call restar_c       ; rax <- restar_c(rdi:x1 - rsi:x2)
	; movemos a los registros que usa restar_c 'x3' y 'x4' para su resta
    mov rdi, rdx        ; rdi <- rdx:x3
    mov rsi, rcx        ; rsi <- rcx:x4
    ; movemos la respuesta de la anterior resta a 'rdx' asi cuando volvamos a restar no se pisa el valor
    mov rdx, rax        ; rdx <- rax:x1-x2
    ; restamos 'x3' y 'x4'
    call restar_c       ; rax <- restar_c(rdi:x3 - rsi:x4)
    ; movemos a rdi la respuesta de la anterior resta y a rsi el valor que teniamos guardado en rdx(x1-x2)
    mov rdi, rax        ; rdi <- rax:x3-x4
    mov rsi, rdx        ; rsi <- rdx:x1-x2
    ; hacemos la suma
    call sumar_c        ; rax <- sumar_c(rdi:x3-x4,rsi:x1-x2)

	;epilogo
	pop rbp
	ret

; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[?], x2[?], x3[?], x4[?]
alternate_sum_4_simplified:
    sub rdi, rsi    ; x1 - x2
    sub rdx, rcx    ; x3 - x4
    add rdi, rdx    ; (x1 - x2) + (x3 - x4)

    mov rax, rdi    ; Movemos el valor de rdi(respuesta) al registro de salida (rax)
	ret

; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
; (x1 - x2) + (x3 - x4) + (x5 - x6) + x7 - x8
alternate_sum_8:
    ; rdi = x1, rsi = x2, rdx = x3, rcx = x4, r8 = x5, r9 = x6, stack = x7, x8
	;prologo
	push rbp
    mov rbp,rsp

    ; llamamos a la funcion que se encarga de sumar 4, puesto que ya estan en el orden que queremos
	call alternate_sum_4
	; re-acomodamos los valores de x5 a x8 para poder volver a llamar a alternate_sum_4
	mov rdi, r8
	mov rsi, r9
	mov rdx, [rbp + 0x10]
	mov rcx, [rbp + 0x18]
	; movemos la anterior respuesta a r8 para no perderla
	mov r8, rax
	; llamamos a alternate_sum_4
	call alternate_sum_4
	; sumamos la ultima respuesta y la primera
	add rax, r8

	;epilogo
    pop rbp
    ret

; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
product_2_f:
    ; rdi = *destination, rsi = x1, xmm0 = f1
    ;prologo
    push rbp
    mov rbp, rsp

    cvtsi2ss xmm1, rsi      ; copiamos rsi en xmm1 (lo cual ademas lo convierte en "flotante")
    mulss xmm1, xmm0        ; multiplicamos xmm1 por xmm0, el valor se guarda en xmm1

    cvttss2si eax, xmm1     ; truncamos el resultado y lo guardamos en eax

    mov [rdi], eax          ; movemos el valor de eax a [rdi]

    ;epilogo
    pop rbp
    ret
