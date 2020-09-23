	.cpu cortex-m4              // Indica el procesador de destino  
	.syntax unified             // Habilita las instrucciones Thumb-2
	.thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		// Define la sección de variables (RAM) 
vector:
    .byte 0x00, 30
	.asciz 		"Sistemas con microprocesadores"


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		// Define la sección de código (FLASH)
	.global reset           		// Define el punto de entrada del código
	.func main              		// Inidica al depurador el inicio de una funcion

reset:
	LDR		    R0,=vector      	// Puntero con la posicion actual de la cadena.
    MOV         R1, 2               // Contador, inicializado en 2
    MOV         R3, 0               // Mantiene el numero mas grande
    
lazo:								// Recorro la cadena
    LDRB        R2, [R0, R1]    // Guardo la n-esima posicion
    ADD         R1, R1, #1          // Aumento el contador
    CMP         R2, R3              // Es r2 mayor al mayor valor actual?
    BHI         store               //Si es mayor, lo guardo
lazo_break:
    CMP         R1, #32             // A la 30va iteracion termino
    BEQ         stop                // Si es la 30va salgo
    B           lazo         

store:
    STRB      R2, [R0]              // Guardo en la pos 0
    LDRB      R3, [R0]              // Guardo p/ comparar
    B           lazo_break

stop:
	B    		stop               	// Lazo infinito para terminar la ejecución
	.pool                   		// Almacenar las constantes de código
