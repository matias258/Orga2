
section .text

global checksum_asm

; uint8_t checksum_asm(void* array, uint32_t n)
; rdi = [array] , rsi = n
; los valores de a y b son de 16 bits = 2 bytes
; los valores de c son de 32 bits = 4 bytes
checksum_asm:
    ;prologo
    push rbp
    mov rbp, rsp

    ; Completar
    ; 2 bytes * 8 valores = 16 bytes = 16 * 8 = 128 bits

    mov ecx, [rsi]
    loopear:
        ; necesito mover y extender los valores de a
        ; para eso tengo que usar dos xmm que tengan 4 valores cada uno
        movq xmm0, [rdi]            ; muevo los primeros 4 en xmm0
        mov rdi, [rdi + 16 * 4]     ; salto 4 valores
        movq xmm1, [rdi]            ; muevo los siguientes 4 en xmm1

        ; ahora necesito agrandar los valores a 32 bits (4 bytes)
        punpcklwd xmm0, xmm0        ; agrando a_low
        punpcklwd xmm1, xmm1        ; agrando a_high

        ; salto el rdi y hago lo mismo con b
        mov rdi, [rdi + 16 * 4]
        movq xmm2, [rdi]
        mov rdi, [rdi + 16 * 4]
        movq xmm3, [rdi]

        punpcklwd xmm2, xmm2        ; agrando b_low
        punpcklwd xmm3, xmm3        ; agrando b_high

        ; sumo a + b para el low y el high
        paddd xmm0, xmm2
        paddd xmm1, xmm3

        ; ahora necesito multiplicar por 8, que es shiftear izq 3 veces (pues 2**3)
        pslld xmm0, 3               ; shifteo 3 y guardo en xmm0
        pslld xmm1, 3               ; shifteo 3 y guardo en xmm1

        mov rdi, [rdi + 16 * 4]     ; salto al comienzo de C
        movq xmm4, [rdi]            ; muevo c_low a xmm4
        mov rdi, [rdi + 16 * 4]     ; salto 4 valores de c
        movq xmm5, [rdi]            ; muevo c_high a xmm5

        pcmpeqd xmm0, xmm4           ; comparo (a+b)*8_low con c_low
        pcmpeqd xmm1, xmm5           ; comparo (a+b)*8_high con c_high

        mov rdx, 0
        haddps xmm3, xmm0
        haddps xmm3, xmm1
        movq r8, xmm3
        mov rdx, 8

        cmp r8, rdx
        jne falso

        mov rdi, [rdi + 128]
        sub ecx, 1

        jz verdadero
        jmp loopear

    verdadero:
    mov rax, 1
    jmp end

    falso:
    mov rax, 0

    end:
    ;epilogo
    add rbp, rsp
    pop rbp

	ret

