/****************************************************************************/
/* Rutina de incremtento de segundos
 */
/* Recibe en R0 el valor a incrementar
 */
/* Recibe en R1 la direccion de los datos
 */
/****************************************************************************/
.func incrementar
incrementar:
    PUSH {R4-R5}
    LDRB R4, [R1]
    ADD R4, R0
    MOV R0, #0

    CMP R4, #9
    BLS final_incrementar

    SUB R4, #9
    LDRB R5, [R1, #1]
    ADD R5, R4
    MOV R4, #0

    CMP R5, #5
    BLS salto_incrementar

    MOV R5, #0
    MOV R0, #1

salto_incrementar:
    STRB R5, [R1, #1]

final_incrementar:
    STRB R4, [R1]
    POP {R4-R5}
    BX LR
.pool
.endfunc

