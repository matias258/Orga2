section .text

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)
checksum_asm:
    ; rdi = *array, esi = n
    ;prologo
    push rbp
    mov rbp, rsp
    xor edx, edx                ; colocamos edx en 0

    loop:
        ; la idea es que nos quede en xmm0 los primeros cuatro valores de a y en xmm1 los siguientes 4
        movdqa xmm0, [rdi]      ; tomamos los 8 valores de a en 16bits
        add rdi, 16             ; avanzamos el *p (para la proxima lectura). 16 = 8(valores de a) * 2(tamaño de cada a)
        movdqa xmm1, xmm0       ; copiamos los valores de xmm0 en xmm1
        ; las siguientes dos lineas no son necesarias
        pslldq xmm0, 8          ; movemos los 4 mas significativos a los menos significativos = {0,0,0,0,a0,a1,a2,a3}
        psrldq xmm0, 8          ; movemos los 4 menos significativos a los mas significativos = {a0,a1,a2,a3,0,0,0,0}
        pmovzxwd xmm0, xmm0     ; convertimos los 4 valores mas significativos a 32bits osea = {a0,a1,a2,a3}
        ; hacemos que en xmm1 queden en 32 los menos significativos
        psrldq xmm1, 8          ; movemos los 4 menos significativos a los mas significativos = {a4,a5,a6,a7,0,0,0,0}
        pmovzxwd xmm1, xmm1     ; convertimos los 4 valores mas significativos a 32bits osea = {a4,a5,a6,a7}

        ; hacemos lo mismo para tomar los valores de b y que queden en xmm2 y xmm3
        movdqa xmm2, [rdi]
        add rdi, 16             ; 16 = 8(lista de b) * 2 bytes(tamaño de cada b)
        movdqa xmm3, xmm2
        ; las siguientes dos lineas no son necesarias
        pslldq xmm2, 8
        psrldq xmm2, 8
        pmovzxwd xmm2, xmm2
        psrldq xmm3, 8
        pmovzxwd xmm3, xmm3

        paddd xmm0, xmm2        ; sumamos [a0,...,a3] + [b0,...,b3] 1 a 1
        paddd xmm1, xmm3        ; sumamos [a4,...,a7] + [b4,...,b7] 1 a 1

        pslld xmm0, 3           ; multiplicamos por 2^3 = [(a0+b0)*2^3,...,(a3+b3)*2^3]
        pslld xmm1, 3           ; multiplicamos por 2^3 = [(a4+b4)*2^3,...,(a7+b7)*2^3]

        movaps xmm2, [rdi]      ; cargamos [c0...c3] en xmm2
        add rdi, 16             ; 4 valores(los 4 primeros c) de 4 bytes(cada c) = 16
        movaps xmm3, [rdi]      ; cargamos [c4...c7] en xmm3
        add rdi, 16

        pcmpeqd xmm0, xmm2      ; comparamos [(a0+b0)*8...(a3+b3)*8] con [c0...c3]
        pcmpeqd xmm1, xmm3      ; comparamos [(a4+b4)*8...(a7+b7)*8] con [c4...c7]

        phaddd xmm0, xmm0       ; [x0+x1, x2+x3, x0+x1, x2+x3]
        phaddd xmm0, xmm0       ; [(x0+x1)+(x2+x3), ", ", "] queda lo mismo en todos los terminos
        movd ecx, xmm0          ; guardamos el valor en ecx

        cmp ecx, -4             ; comparamos si el valor que tenemos en ecx es -4 (osea la suma (aX + bX) * 8 = cX)
        jne different           ; si son iguales saltamos a equal

        inc edx                 ; incrementamos el iterador del loop
        cmp edx, esi            ; comparamos el iterador del loop con el tamaño del array
        jne loop                ; volvemos arriba

    ; si llegamos hasta aca es que iteramos por toda la lista y se cumple la condicion solicitada
    mov al, 1
    jmp end                     ; saltamos a end porque sino la etiqueta de abajo nos caga la respuesta de al

    different:
        mov al, 0               ; guardamos 0 como respuesta (son distintos)

    end:
        ;epilogo
        pop rbp
	    ret
