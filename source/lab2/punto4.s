

	.cpu cortex-m4          
	.syntax unified         
	.thumb                      

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

	.section .data

segundos:                              //Constante 64-bits
	.hword 0x0000             			    //Inicio el contador de segundos en 00

horas_minutos:
	.word 0x00000000                        //Inicio el contador de hora-minutos en 00:00

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

/**
 * Asumo que esta funcion se llama cada un milisegundo, es decir que debo
 * incrementar el reloj cada 1000ms.
 */

	.section .text          		        
	.global reset           		        
	.func main      

reset:
	MOV       	R4, #0                      // Contador de ms, inicializo en 0

segundero:
	ADD         R4, #1                      // Incremento R4 en 1
	CMP         R4, #1000					// Reviso si llegamos a la #1000 iteracion.
	ITT         HS
	MOVHS       R4, #0                      // Contador de ms, inicializo en 0
	BLHS        disparar_incremento			// Son 1000 milisegundos? Aumentame un segundo.
	B         	segundero					// Vuelvo a seguir contando milisegundos

disparar_incremento:						// Deseo aumentar los segundos y minutos.
	PUSH		{LR}						// Es funcion anidada asi que debo guardar LR.
	MOV 		R0, #1						// Quiero hacer incrementos de a 1 segundo.
	LDR			R1, =segundos				// Deseo aumentar el par de numeros bajo la direccion de segundos.
	BL 			incrementar					// Llamo a la funcion
	CMP			R0,#1						// Si veo un 1 en R0 se si corresponde aumentar minutos.
	ITTT	    EQ							
	LDREQ		R1, =horas_minutos			// Puntero a horas_minutos
	ADDEQ		R1, #2						// Selecciono los minutos
	BLEQ		incrementar					// Llamo a la funcion solo si debo incrementar
	POP			{PC}						// Vuelvo al segundero.


stop:
	B    		stop               	        // Lazo infinito para terminar la ejecución

/****************************************************************************/
/* Rutina de incremento de segundos de la guia
/* Param - R0 - incremento ( deberia ser uno para subir segundo a segundo).
/* Param - R1 - puntero a datos. (2 bytes consecutivos).
/* Retrn - R0 - Devuelve 1 si desbordo, 0 en otro caso. 
/****************************************************************************/

	incrementar:
		PUSH {R4-R5}
		LDRB R4, [R1]
		ADD R4, R0
		MOV R0, #0

		CMP R4, #9
		BLS final_incrementar

		SUB R4, #9
		LDRB R5, [R1, #1]
		ADD R5, R4
		MOV R4, #0

		CMP R5, #5
		BLS salto_incrementar

		MOV R5, #0
		MOV R0, #1

	salto_incrementar:
		STRB R5, [R1, #1]

	final_incrementar:
		STRB R4, [R1]
		POP {R4-R5}
		BX LR
	.pool

