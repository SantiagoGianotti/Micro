	.cpu cortex-m4
	.syntax unified
	.thumb

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		        // Define la sección de variables (RAM)

	vector:
		.hword 0x000A
		.hword 0x0000, 0x0015, 0x00A0, 0x0F00, 0x0F02, 0x0F03, 0x0F04, 0x0F05, 0x0F06, 0xFF04, 


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


/* subrutina_busqueda_binaria
 * Encuentra la direccion de memoria donde se encuentra el numero que deseamos encontrar.
 * Parametro - R0 - Numero a encontrar, unsigned 16 bits
 * Parametro - R1 - Direccion del vector
 * Parametro - R2 - Tamaño del vector
 * Retorno - R0 - Booleano. Encontro el numero, devuelve #1, sino #0
 */

subrutina_busqueda_binaria:

	SUBS        R0, R1          			//Resto sucesivamente el divisor
	CMP			R0, R1					
	BHS			subrutina_modulo			//Si el divisor es mayor al dividendo sigo restando
	BX			LR							//Si no, tengo mi modulo en R0, salgo.
/* 
 * @Parametro - R2 - minimo
 * @Parametro - R3 - maximo
 */
recursion_subrutina:


