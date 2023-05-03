section     .text
    global _start
_start:
    ;inicializamos las variables
    mov al, 25
    mov bl, 11 
    ;al y bl son registros de proposito general low bytes (osea de 8 bits)
    add al, bl
    ;sumo el valor
    push eax
    ;guardo el valor en la pila
    mov eax, resultado
    ;mensaje a imprimir

section     .data
    resultado db "La suma es:"
sys_exit
