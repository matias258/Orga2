
global strArrayNew
global strArrayGetSize
global strArrayGet
global strArrayRemove
global strArrayDelete

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; str_array_t* strArrayNew(uint8_t capacity)
strArrayNew:
; rdi = capacity
    ;prologo
    push rbp
    mov rbp, rsp

    ; malloc usa rdi para saber cuanto reservar, ahora reservamos un malloc de tamaño "capacity"
    ;call malloc
    mov rax, rdi


    ;epilogo
    add rbp, rsp
    pop rbp

; uint8_t  strArrayGetSize(str_array_t* a)
strArrayGetSize:


; char* strArrayGet(str_array_t* a, uint8_t i)
strArrayGet:


; char* strArrayRemove(str_array_t* a, uint8_t i)
strArrayRemove:


; void  strArrayDelete(str_array_t* a)
strArrayDelete:


