extern fprintf
extern free
extern malloc

section .data
null: db 'null'

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **
; int32_t strCmp(char* a, char* b)
strCmp:
    ; rdi = *a, rsi = *b
    ;prologo
    push rbp
    mov rbp,rsp

    loop:
        mov al, [rdi]   ; guardamos en 'al' el valor que indica 'rdi'
        mov bl, [rsi]   ; guardamos en 'bl' el valor que indica 'rsi'
        cmp al, 0       ; comparamos 'a' con 0
        je a_zero       ; saltamos a a_zero si 'a' es 0
        cmp bl, 0       ; comparamos 'b' con 0
        je b_zero       ; saltamos a b_zero si 'b' es 0
        cmp al, bl      ; comparamos 'a' con 'b'
        ja b_zero       ; saltamos a b_zero si 'a' es mayor
        jb a_zero       ; saltamos a a_zero si 'a' es menor
        inc rdi         ; incrementamos el puntero de 'a'
        inc rsi         ; incrementamos el puntero de 'b'
        jmp loop        ; volvemos a comenzar el loop

    a_zero:
        cmp bl, 0       ; checkeamos si 'b' es 0
        je equal        ; si 'b' tambien es 0 saltamos a que son iguales
        mov eax, 1      ; la respuesta es '1' porque 'b' sigue teniendo valores o fue mayor que 'a'
        jmp end         ; saltamos al final

    b_zero:
        cmp al, 0       ; checkeamos si 'a' es 0
        je equal        ; si 'a' tambien es 0 saltamos a que son iguales
        mov eax, -1     ; la respuesta es '-1' porque 'a' sigue teniendo valores o fue mayor que 'b'
        jmp end         ; saltamos al final

    equal:
        mov eax, 0      ; la respuesta es 0 pq son iguales
        jmp end         ; saltamos al final

    end:
        ;epilogo
        pop rbp
        ret

; char* strClone(char* a)
strClone:
    ; rdi = *a
    ;prologo
    push rbp
    mov rbp,rsp

    mov rsi, rdi                    ; movemos 'a' a rsi porque rdi lo usaremos como parametro de malloc
    mov rdi, 0                      ; colocamos el contador en 0
    ; rdi = contador, rsi = *a
    ; calculamos el tamaño de 'a' y lo guardamos en rdi
    .loop_len:
        mov bl, byte [rsi + rdi]    ; guardamos en al el valor de a[*a + i]
        inc rdi                     ; incrementamos en 1 el rdi
        cmp bl, 0                   ; checkeamos si llegamos al final
        jne .loop_len               ; si no llegamos a 0 avanzamos a la sig instruccion

    ; reservamos la memoria y realizamos el copiado
    call malloc WRT ..plt
    xor r8, r8                      ; asigno 0 al valor de r8

    ; rdi = tamaño final, rsi = *a, r8 = contador, rax = *new_a
    .loop_copy:
        mov bl, byte [rsi + r8]
        mov byte [rax + r8], bl
        inc r8
        cmp r8, rdi
        jne .loop_copy

    ;epilogo
    pop rbp
    ret

; void strDelete(char* a)
strDelete:
    ; rdi = *a
	;prologo
    push rbp
    mov rbp,rsp

    call free WRT ..plt

	;epilogo
    pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
    ; rdi = *a, rsi = *pFILE
    ;prologo
    push rbp
    mov rbp, rsp

    mov rdx, rdi
    mov rdi, rsi
    mov rsi, rdx
    ; rdi = *pFILE, rsi = *a
    ; xchg rdi, rsi

    mov bl, byte [rsi]
    cmp bl, 0
    je .nulo

    call fprintf WRT ..plt
    jmp .end

    .nulo:
        mov rsi, null
        call fprintf WRT ..plt

    .end:
        ;epilogo
        pop rbp
        ret

; uint32_t strLen(char* a)
strLen:
    ; rdi = *a
    ;prologo
    push rbp
    mov rbp,rsp

    mov rax, -1                      ; colocamos el contador en -1 para ignorar el char vacio en el retorno
    ; rdi = *a, rax = contador
    ; calculamos el tamaño de 'a' y lo guardamos en rax
    .loop_len:
        inc rax                     ; incrementamos en 1 el contador
        mov bl, byte [rdi + rax]    ; guardamos en al el valor de a[*a + i]
        cmp bl, 0                   ; checkeamos si llegamos al final
        jne .loop_len               ; si no llegamos a 0 avanzamos a la sig instruccion

    ;epilogo
    pop rbp
    ret
