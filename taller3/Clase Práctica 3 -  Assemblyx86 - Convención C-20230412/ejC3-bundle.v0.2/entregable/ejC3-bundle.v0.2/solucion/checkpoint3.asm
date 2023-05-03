
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
;registros: arr[rdi], arr_length[rsi]
complex_sum_z:
	;prologo
    push rbp
    mov rbp, rsp
    ; ahora tenemos que hacer que arr apunte a z
    ; como tenemos 4 valores de 64 bits, y necesitamos el ultimo de ellos, entonces tenemos que saltar el rdi
    ; ahora el rdi apunta a la "w", si saltamos 3 veces apuntara a la "z" que es lo que buscamos
    ; entonces tenemos que saltar 8 * 3 veces
    add rdi, 24
    mov rax, 0      ; iniciamos en 0 el rax

	mov ecx, 99     ; carga la cantidad de iteraciones a hacer al contador de vueltas
	.cycle:         ; etiqueta a donde retorna el ciclo que itera sobre arr
	add rax, [rdi]  ; sumo el valor en el puntero del arr
	loop .cycle     ; decrementa ecx y si es distinto de 0 salta a .cycle

	;epilogo
	add rbp, rsp
    pop rbp
	ret

;extern uint32_t packed_complex_sum_z(packed_complex_item *arr, uint32_t arr_length);
;registros: arr[?], arr_length[?]
packed_complex_sum_z:
    ;prologo
    push rbp
    mov rbp, rsp
    ; ahora tenemos que hacer que arr apunte a z
    ; como tenemos 4 valores de 64 bits, y necesitamos el ultimo de ellos, entonces tenemos que saltar el rdi
    ; ahora el rdi apunta a la "w", si saltamos 3 veces apuntara a la "z" que es lo que buscamos
    ; entonces tenemos que saltar 8 * 3 veces
    add rdi, 20     ; todavia no entendi xq 20, pero bueno nico...
    mov rax, 0      ; iniciamos en 0 el rax

    mov ecx, 99     ; carga la cantidad de iteraciones a hacer al contador de vueltas
    .cycle:         ; etiqueta a donde retorna el ciclo que itera sobre arr
    add rax, [rdi]  ; sumo el valor en el puntero del arr
    loop .cycle     ; decrementa ecx y si es distinto de 0 salta a .cycle

    ;epilogo
    add rbp, rsp
    pop rbp
    ret


;extern void product_9_f(uint32_t * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[r8], f3[xmm2], x4[r9], f4[xmm3]
;	, x5[rbp - 0], f5[xmm4], x6[rbp - 8], f6[xmm5], x7[rbp - 2 * 8], f7[xmm6], x8[rbp - 3 * 8], f8[xmm7],
;	, x9[rbp - 4 * 8], f9[xmm8]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	; COMPLETAR
    cvtss2sd xmm0, xmm0
    cvtss2sd xmm1, xmm1
    cvtss2sd xmm2, xmm2
    cvtss2sd xmm3, xmm3
    cvtss2sd xmm4, xmm4
    cvtss2sd xmm5, xmm5
    cvtss2sd xmm6, xmm6
    cvtss2sd xmm7, xmm7

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	; COMPLETAR
	mulsd xmm0, xmm1
	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	;registros y pila: destination[rdi], x1[rsi], f1[xmm0], x2[rdx], f2[xmm1], x3[r8], f3[xmm2], x4[r9], f4[xmm3]
    ;	, x5[rbp - 0], f5[xmm4], x6[rbp - 8], f6[xmm5], x7[rbp - 2 * 8], f7[xmm6], x8[rbp - 3 * 8], f8[xmm7],
    ;	, x9[rbp - 4 * 8], f9[xmm8]
	; COMPLETAR
	cvtsi2sd xmm2,rdi
	cvtsi2sd xmm3,rdx
	cvtsi2sd xmm4,r8
	cvtsi2sd xmm5,r9
	cvtsi2sd xmm6,[rbp - 0]
	cvtsi2sd xmm7,[rbp - 8]
	cvtsi2sd xmm8,[rbp - 16]

	mulsd xmm0, xmm2
	mulsd xmm0, xmm3
	mulsd xmm0, xmm4
	mulsd xmm0, xmm5
	mulsd xmm0, xmm6
	mulsd xmm0, xmm7
	mulsd xmm0, xmm8

    mov [rdi], xmm0
	; epilogo
	pop rbp
	ret

