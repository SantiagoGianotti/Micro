	.cpu cortex-m4
	.syntax unified
	.thumb

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		        // Define la sección de variables (RAM)


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		        // Define la sección de código (FLASH)
	.global reset           		        // Define el punto de entrada del código
	.func main              		        // Inidica al depurador el inicio de una funcion

reset:
	MOV         R0, 0x49                    // Cargo el dividendo
	MOV         R1, 0x04                    // Cargo el modulo
	BL          subrutina_modulo

stop:
	B    		stop               	        // Lazo infinito para terminar la ejecución
	.pool                   		        // Almacenar las constantes de código


/* Subrutina_modulo
 * Calcula el modulo de dos numeros de 16 bits. Devuelve el resultado en 16 bits.
 * Parametro - R0 - dividendo, unsigned 16 bits
 * Parametro - R1 - modulo,  unsigned 16 bits
 * Retorno - Carga en [R0] el resultado del modulo.
 */

subrutina_modulo:

	SUBS        R0, R1          			//Resto sucesivamente el divisor
	CMP			R0, R1					
	BHS			subrutina_modulo			//Si el divisor es mayor al dividendo sigo restando
	BX			LR							//Si no, tengo mi modulo en R0, salgo.

