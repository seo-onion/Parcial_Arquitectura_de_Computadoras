    .section .data, "aw"
    .org    0x10000         @ Inicio de A
array:
        .word   1, 2, 3          @   A[0][0]=1, A[0][1]=2, A[0][2]=3
        .word   4, 5, 6          @   A[1][0]=4, A[1][1]=5, A[1][2]=6
        .word   7, 8, 9          @   A[2][0]=7, A[2][1]=8, A[2][2]=9


    .section .text
    .code   32
    .global _start
_start:
        @ R0 = dirección base de A
        LDR     R0, =array

        @ R1 = número de comparaciones en la primera pasada = 8
        MOV     R1, #8

pass:   MOV     R2, #0      @ k = 0
        MOV     R3, R1      @ límite (N–pass–1)

inner:  CMP     R2, R3
        BGE     next_pass

        MOV     R4, R2, LSL #2
        ADD     R5, R0, R4
        LDR     R6, [R5]
        LDR     R7, [R5, #4]
        CMP     R6, R7
        STRLT   R7, [R5]
        STRLT   R6, [R5, #4]
        ADD     R2, R2, #1
        B       inner

next_pass:
        SUBS    R1, R1, #1
        BGE     pass

done:   B       done

    .ltorg
