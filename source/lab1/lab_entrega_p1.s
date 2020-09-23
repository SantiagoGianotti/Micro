	.cpu cortex-m4              // Indica el procesador de destino  
	.syntax unified             // Habilita las instrucciones Thumb-2
	.thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		// Define la sección de variables (RAM) 
base:
	.asciz "Esta es una prueba"		//El vector es de bytes, y esta en ascii por que es mas facil
	.byte 0x00						

resultado:
	.byte 0x00
	.byte 0x00

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		// Define la sección de código (FLASH)
	.global reset           		// Define el punto de entrada del código
	.func main              		// Inidica al depurador el inicio de una funcion

reset:
	LDR			R0, =base			//Almaceno la direccion a base
	LDR			R1, =resultado		//Almaceno la direccion del vector
	MOV			R2, #0				//Abro un contador para numeros pares
	MOV			R3, #0				//Contador impares

lazo:
	LDRB		R5, [R0], #1		//Traigo el N lugar de memoria con postincrementado
	CMP			R5, #0x00			//Si es igual a 0x00 termine, guardo.
	BEQ			store			
	LSRS		R5, #1				//Saco al carry el <LSB> para determinar paridad.
	ITE 		LO
	ADDLO		R2, #1 				//Si el carry es 0, aumento par
	ADDHS		R3,	#1				//Si el carry es 1, aumento impar
	B			lazo

store:
	STRB		R2, [R1]			//Guardo la cantidad de pares
	STRB		R3, [R1, #1]		//Idem impares, un registro mas adelante.

stop:
	B    		stop               	// Lazo infinito para terminar la ejecución
	.pool                   		// Almacenar las constantes de código
