
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global complex_sum_z
global packed_complex_sum_z
global product_9_f

;########### DEFINICION DE FUNCIONES
;extern uint32_t complex_sum_z(complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
complex_sum_z:
    ; rdi = *arr, rsi = len
    ;prologo
    push rbp
    mov rbp, rsp

    xor eax, eax                ; resultado final = 0
    add rdi, 24                 ; le sumamos 24 a rdi, lo que hace que nuestro puntero apunte al primer valor z

    .loop:
        cmp rsi, 0              ; comprobar si hemos llegado al final del array
        je .done                ; si llegamos al final saltamos a 'done'

        add eax, dword [rdi]    ; agregamos a el resultado final el valor de z
        add rdi, 0x20           ; sumamos 32(tamaño de estructura) al puntero rdi

        dec rsi                 ; decrementamos el contador de iteracion
        jmp .loop               ; volvemos a iniciar

    .done:
        ;epilogo
        pop rbp
        ret

;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:
    ; rdi = *arr, rsi = len
    ;prologo
    push rbp
    mov rbp, rsp
	xor eax, eax                ; resultado final = 0
    add rdi, 20                 ; le sumamos 20 a rdi, lo que hace que nuestro puntero apunte al primer valor z

    .loop:
        cmp rsi, 0              ; comprobar si hemos llegado al final del array
        je .done                ; si llegamos al final saltamos a 'done'

        add eax, dword [rdi]    ; agregamos a el resultado final el valor de z
        add rdi, 0x18           ; sumamos 24(tamaño de estructura) al puntero rdi

        dec rsi                 ; decrementamos el contador de iteracion
        jmp .loop               ; volvemos a iniciar

    .done:
        ;epilogo
        pop rbp
        ret

;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;	, x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;	, x9[?], f9[?]
product_9_f:
    ; rdi = *destination
    ; rsi = x1, rdx = x2, rcx = x3, r8 = x4, r9 = x5
    ; xmm0 = f1, xmm1 = f2, xmm2 = f3, xmm3 = f4, xmm4 = f5, xmm5 = f6, xmm6 = f7, xmm7 = f8
    ; stack = x6, x7, x8, x9, f9
	;prologo
    push rbp
    mov rbp, rsp

    ; convertimos a double y multiplicamos todos los valores flotantes
	cvtss2sd xmm0, xmm0         ; convertimos f1 en double
	cvtss2sd xmm1, xmm1         ; convertimos f2 en double
	mulsd xmm0, xmm1            ; xmm0 = f1 * f2
	cvtss2sd xmm1, xmm2         ; convertimos f3 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f3
	cvtss2sd xmm1, xmm3         ; convertimos f4 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f4
	cvtss2sd xmm1, xmm4         ; convertimos f5 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f5
	cvtss2sd xmm1, xmm5         ; convertimos f6 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f6
	cvtss2sd xmm1, xmm6         ; convertimos f7 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f7
	cvtss2sd xmm1, xmm7         ; convertimos f8 en double
	mulsd xmm0, xmm1            ; xmm0 = xmm0 * f8
	movss xmm1, [rbp + 0x30]    ; cargamos f9 en xmm1
    cvtss2sd xmm1, xmm1         ; convertimos f9 en double
    mulsd xmm0, xmm1            ; xmm0 = xmm0 * f9

    ; convertimos y multiplicamos xmm0 con todos los enteros que tenemos en registros
    cvtsi2sd xmm1, rsi  ; cargamos x1 en xmm1
    mulsd xmm0, xmm1    ; xmm0 = xmm0 * x1
    cvtsi2sd xmm1, rdx  ; cargamos x2 en xmm1
    mulsd xmm0, xmm1    ; xmm0 = xmm0 * x2
    cvtsi2sd xmm1, rcx  ; cargamos x3 en xmm1
    mulsd xmm0, xmm1    ; xmm0 = xmm0 * x3
    cvtsi2sd xmm1, r8   ; cargamos x4 en xmm1
    mulsd xmm0, xmm1    ; xmm0 = xmm0 * x4
    cvtsi2sd xmm1, r9   ; cargamos x5 en xmm1
    mulsd xmm0, xmm1    ; xmm0 = xmm0 * x5

	; convertimos y multiplicamos xmm0 con los todos los enteros que esten en el stack
    cvtsi2sd xmm1, [rbp + 0x10]     ; cargamos x6 en xmm1
    mulsd xmm0, xmm1                ; xmm0 = xmm0 * x6
    cvtsi2sd xmm1, [rbp + 0x18]     ; cargamos x7 en xmm1
    mulsd xmm0, xmm1                ; xmm0 = xmm0 * x7
    cvtsi2sd xmm1, [rbp + 0x20]     ; cargamos x8 en xmm1
    mulsd xmm0, xmm1                ; xmm0 = xmm0 * x8
    cvtsi2sd xmm1, [rbp + 0x28]     ; cargamos x9 en xmm1
    mulsd xmm0, xmm1                ; xmm0 = xmm0 * x9

    movsd [rdi], xmm0

	;epilogo
    pop rbp
    ret
