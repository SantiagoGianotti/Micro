	.cpu cortex-m4              // Indica el procesador de destino  
	.syntax unified             // Habilita las instrucciones Thumb-2
	.thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		// Define la sección de variables (RAM) 
cadena:
	.asciz 		"SISTEMAS CON MICROPROCESADORES"
	.byte 		0x00 				//fin de cadena con 00 ya que ningun caracter ascii lo usa.


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		// Define la sección de código (FLASH)
	.global reset           		// Define el punto de entrada del código
	.func main              		// Inidica al depurador el inicio de una funcion

reset:
	LDR			R0,=cadena      	// Puntero con la posicion actual de la cadena.
	
lazo:								// Recorro la cadena
	LDRB		R1, [R0, #1]!		// En R1 cargo el byte de la cadena
	MOV			R2, #0x0			// Contador de 1's
	MOV			R3, #0x1			// Mascara a ser desplazada
	MOV			R4, #0x0			// 
	CMP  		R1, 0x00        	// Checkeo la condicion de fin de cadena
	BEQ  		stop

lazo_bit_a_bit:						// Reviso la paridad de un bit individualmente.
	AND			R4, R1, R3			// Guardo en R4 el resultado de la mascara
	LSL			R3, #1				// Hago un shift a la mascara
	CMP			R4, #0				// Checkeo si el resultado es mayor a 0
	IT			HI					
	ADDHI		R2, #1				// entonces significa que le tengo que sumar 1
	CMP			R3, #0x80				
	BLS			lazo_bit_a_bit

	LSRS		R2, #1				// El lsb de R2 me indica la paridad. lo saco x el carry
	IT 			HS
	ADDHS			R1, 0x80			// 0x80 es un msb en 1  
	STRB		R1, [R0]
	B 			lazo

stop:
	B    		stop               	// Lazo infinito para terminar la ejecución
	.pool                   		// Almacenar las constantes de código
