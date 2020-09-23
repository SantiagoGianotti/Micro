    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
destino:    
    .byte 0xFF              // Variable de 20 bytes en blanco

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text              // Define la sección de código (FLASH)
    .global reset               // Define el punto de entrada del código
    .func main                  // Inidica al depurador el inicio de una funcion

reset:
    MOV     R0, #5              // BERRE QUERIA UN 5
    ADR     R3,tabla            // Apunta R3 al bloque con la tabla
lazo:
    LDRB    R0,[R3,R0]          // Cargar en R2 el elemento convertido
    @ STRB    R2,[R0],#1          // Guardar el elemento convertido 
stop:   
    B       stop                // Lazo infinito para terminar la ejecución
    .pool                       // Almacenar las constantes de código

tabla:                          // Define la tabla de conversión 
    .byte 0x3F,0x6,0x5b,0x4F,0x66
    .byte 0x6D,0x7D,0x7,0x7F,0x6F      
    .endfunc
