extern malloc
extern free
extern fprintf

global strArrayNew
global strArrayGetSize
global strArrayAddLast
global strArraySwap
global strArrayDelete

; Funciones creadas por mi ;
global strArraySize
global newArray

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; str_array_t* strArrayNew(uint8_t capacity)
strArrayNew:
    ;prologo
    push rbp
    mov rbp, rsp

    movzx edi, BYTE [rbp+16]             ; Cargar el parámetro capacity desde la pila a RDI
    call newArray                        ; Llamar a la función newArray en C para crear el array de strings

    ;epilogo
    mov rsp, rbp
    pop rbp
    ret


; uint8_t  strArrayGetSize(str_array_t* a)
; rdi = [a], puntero del array a
strArrayGetSize:
    ;prologo
    push rbp
    mov rbp, rsp

    push rax                ; reservo espacio en la pila para almacenar la direccion de retorno
    call strArraySize       ; LLamo a la funcion en C

    ;epilogo
    pop rax
    mov rsp, rbp
    pop rbp

    ret

; void  strArrayAddLast(str_array_t* a, char* data)
strArrayAddLast:
    ret

; void  strArraySwap(str_array_t* a, uint8_t i, uint8_t j)
strArraySwap:
    ret

; void  strArrayDelete(str_array_t* a)
strArrayDelete:
    ret

