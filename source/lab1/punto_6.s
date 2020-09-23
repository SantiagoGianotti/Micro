	.cpu cortex-m4              // Indica el procesador de destino  
	.syntax unified             // Habilita las instrucciones Thumb-2
	.thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		// Define la sección de variables (RAM) 
vector:
	.asciz "Esta es una prueba"

base:
	.word 0x11111111
	.word 0xffffffff

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		// Define la sección de código (FLASH)
	.global reset           		// Define el punto de entrada del código
	.func main              		// Inidica al depurador el inicio de una funcion

reset:
	MOV			R0, #18				//Almaceno el numero de elementos
	LDR			R1, =base			//Almaceno la direccion a base
	LDR			R2, =vector			//Almaceno la direccion del vector
	STR			R2, [R1]			//Paso a memoria la direccion del vector
	MOV			R4, #0				//Abro un contador

lazo:
	LDRB		R5, [R2, R4]		//Traigo el N lugar de memoria
	ADD			R4, #1				//Aumento el contador
	ADD			R3, R3, R5			//Sumo contra la memoria anterior ( checksum )
	CMP			R0, R4				//Reviso si llegue al ultimo elemento.
	BNE			lazo
	STR			R3, [R1, #4]!		//Guardo el checksum
	B			stop

stop:
	B    		stop               	// Lazo infinito para terminar la ejecución
	.pool                   		// Almacenar las constantes de código
