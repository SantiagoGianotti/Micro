	.cpu cortex-m4          
	.syntax unified         
	.thumb                      

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		        // Define la sección de variables (RAM)

palabra_larga:                              //Constante 64-bits
	.word 0x81000304, 0x00200605			//Nota - la parte baja esta en el primer espacio del vector


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		        // Define la sección de código (FLASH)
	.global reset           		        // Define el punto de entrada del código
	.func main              		        // Inidica al depurador el inicio de una funcion

reset:
	LDR			R0, =palabra_larga			// Almaceno la direccion a base
	MOV			R1, #0x0102					// Almaceno parte de 32 bits
	MOVT		R1, #0xA056					// Almaceno la otra parte.
	BL          subrutina_suma

stop:
	B    		stop               	        // Lazo infinito para terminar la ejecución
	.pool                   		        // Almacenar las constantes de código


/* Subrutina_suma
 * Suma dos numeros de 64 y 32 bits. Devuelve el resultado en 64 bits.
 * Parametro - M[R0] Puntero a palabra de 64 bits de memoria
 * Parametro - R1 32 bits
 * Retorno - Carga en [R0] el resultado de la suma.
 */
subrutina_suma:
	LDR         R2, [R0]					// Cargo la parte "baja" del numero de 64bits
	ADDS		R2, R1						// Sumo los primeros 32 bits de las 2 palabras
	LDR         R1, [R0, #4]				// Cargo la parte "alta" del numero de 64bits
	ADC			R1, #0						// Sumo (result con carry a la parte alta)
	STR 		R2, [R0]					// Guardo la parte baja
	STR 		R1, [R0, #4]				// Guardo la parte alta
	BX			LR
