	.cpu cortex-m4              // Indica el procesador de destino  
	.syntax unified             // Habilita las instrucciones Thumb-2
	.thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           // Define la sección de variables (RAM) 
	vector:
		.hword 4             //Base
		.space 8, 0x11       //Base + 2 en adelante
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          // Define la sección de código (FLASH)
	.global reset           // Define el punto de entrada del código
	.func main              // Inidica al depurador el inicio de una funcion

reset:
	LDR		R0,=vector       // Apunta R0 al bloque de origen
	LDRH	R1,=0
	LDRH	R2,=0x55		// Agrego el valor que quiero cargar
lazo:
	ADD		R1, R1, #2
	STRH 	R2,[R0, R1]        // Carga en R0 el elemento a convertir
	CMP  	R1,0x8            // Determina si es el fin de conversión
	BEQ  	stop              // Terminar si es fin de conversión
	B 		lazo

stop:
	B    	stop               // Lazo infinito para terminar la ejecución
	.pool                   // Almacenar las constantes de código
