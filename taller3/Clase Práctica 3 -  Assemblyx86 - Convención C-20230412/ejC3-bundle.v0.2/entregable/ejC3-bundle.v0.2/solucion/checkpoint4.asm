extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; rdi = *a, rsi = *b
strCmp:
    ;prologo
    push rbp
    mov rbp, rsp

    ;Primero tenemos que calcular la longitud de uno de los chars
    call length_c

    .ciclo:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, 0
    je a_zero
    cmp bl, 0
    je b_zero
    cmp al, bl
    ja b_zero
    jb a_zero
    inc rdi
    inc rsi
    loop .ciclo

    .mayor:


    ;epilogo
    add rbp, rsp
    pop rbp

	ret

; char* strClone(char* a)
; rdi = [a]
strClone:
    ;prologo
    push rbp
    mov rbp, rsp

    mov rsi, rdi        ; rsi: [a]
    call length_c       ; rdi: long([a]), calculamos el largo del string, queda en rax
    mov ecx, rsi        ; ecx: long([a])
    jz .fin             ; si long([a]) es 0, vamos directo al final
    call malloc         ; rax: long([a]), reservamos espacio para allocar

    .copiar:
    mov al, [rsi]       ; al: char de la cadena
    mov [rax], al       ; copiamos el char en la memoria reservada
    inc rsi             ; vamos al siguiente char de a
    inc rax             ; vamos al siguiente espacio vacio del malloc
    sub ecx, 1          ; iterador
    jz .fin             ; saltamos si termina
    jmp .copiar

    .fin:
    ;epilogo
    add rbp, rsp
    pop rbp
    push rax
    call free

	ret

; void strDelete(char* a)
strDelete:
	; Esto no funciona porque copia el puntero al string
	; pero no el string en sí mismo
	mov rax, rdi
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	ret


