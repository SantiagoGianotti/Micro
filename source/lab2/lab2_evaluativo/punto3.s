	.cpu cortex-m4
	.syntax unified
	.thumb

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data           		        // Define la sección de variables (RAM)
        numero:
            .byte 0x01, 0x01

		resultado:
			.byte 0x00


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

	.section .text          		        // Define la sección de código (FLASH)
	.global reset           		        // Define el punto de entrada del código
	.func main              		        // Inidica al depurador el inicio de una funcion

reset:
    MOV         R4, #1                      // Contador
    MOV         R5, #1                      // Numero con mas divisores
    MOV         R6, #1                      // Cantidad de divisores

lazo:

	MOV         R0, R4                      // Cargo el numero a dividir
	LDR         R1, =resultado              // Cargo el puntero
	BL          subrutina_divisores
    CMP         R6, R0                      // si cant div R6 menor R0, guardo R0
    ITT         HS 
    MOVHS       R0, R6                      // Guardo la cant de divisores
    MOVHS       R0, R5                      // Guardo el numero de divisor
    CMP         R4, #255                    // El maximo valor a analizar
    ADD         R4, #1
    BNE         lazo    
    LDR         R0, =numero                    
    STRB        R5, [R0], #1
    STRB        R6, [R0]


stop:
	B    		stop               	        // Lazo infinito para terminar la ejecución
	.pool                   		        // Almacenar las constantes de código


/* Subrutina_divisores
 * Calcula los divisores de un numero de 1 byte. Devuelve el resultado en 16 bits.
 * Parametro - R0 - dividendo, unsigned 1 byte
 * Parametro - R1 - Puntero a memoria.
 * Retorno - Carga en [R0] el resultado del divisores.
 */

subrutina_divisores:
	PUSH        {LR}                        //Es anidada, guardo el return
	PUSH 		{R4}
	MOV         R2, R0                      //Guardo el numero original en r2
	MOV         R0, #1                      //Inicializo el contador en r0
	MOV 		R4, #0

lazo_divisores:
	CMP         R2, R0                      //Reviso la condicion de salida
	ITTT          LO
	MOVLO 		R0, R4						//Paso a R0 la cantidad de divisores
	POPLO 		{R4}						
	POPLO       {PC}                        //Termine, salgo
 
	@ UDIV		R3,R2, R0					//La division me dice si es divisor o
	PUSH		{R0-R1}
	MOV			R1, R0						//Seteo el modulo
	MOV			R0, R2						//Seteo el divisor
	BL			subrutina_modulo			//La division me dice si es divisor o no.
	MOV			R3, R0						//Guardo el moudlo
	POP			{R0-R1}
	CMP 		R3, #0						//El modulo 0 me indica que es divisor				
	ITT 		EQ
	STRBEQ      R0, [R1], #1                //Guardo el divisor en memoria y avanzo el puntero
	ADDEQ		R4, #1
	ADD 		R0, #1						//Aumento la cuenta
	B 		    lazo_divisores  			//Sigo en el lazo hasta el final



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
