/* Copyright 2016-2020, Laboratorio de Microprocesadores 
 * Facultad de Ciencias Exactas y Tecnología 
 * Universidad Nacional de Tucuman
 * http://www.microprocesadores.unt.edu.ar/
 * Copyright 2016-2020, Esteban Volentini <evolentini@herrera.unt.edu.ar>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos de los 7seg display
// Digito 1
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)

// Digito 2
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)

// Digito 3
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)

// Digito 4
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

// Recursos utilizados por los 7 segmentos
    // Numero de puerto GPIO utilizado por los todos leds
    .equ DIG_GPIO,      0
    // Desplazamiento para acceder a los registros GPIO de los leds
    .equ DIG_OFFSET,    ( DIG_GPIO << 2)
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada led
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )

// -------------------------------------------------------------------------

// Recursos utilizados por el segmento A
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

// Recursos utilizados por el segmento B
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

// Recursos utilizados por el segmento C
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

// Recursos utilizados por el segmento D
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

// Recursos utilizados por el segmento E
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)

// Recursos utilizados por el segmento F
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

// Recursos utilizados por el segmento G
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

// Recursos utilizados por el segmento DP
    .equ SEG_DP_PORT,    6
    .equ SEG_DP_PIN,     8
    .equ SEG_DP_BIT,     16
    .equ SEG_DP_MASK,    (1 << SEG_DP_BIT)
    .equ SEG_DP_GPIO,    5
    .equ SEG_DP_OFFSET,  ( SEG_DP_GPIO << 2)

// Recursos utilizados por los leds del 7 segmentos
    .equ SEG_N_GPIO,    2
    .equ SEG_N_OFFSET,  ( SEG_N_GPIO << 2)
    .equ SEG_N_MASK,    ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)

// -------------------------------------------------------------------------    
// Recursos utilizados por la primera tecla
    .equ BOT_1_PORT,    4
    .equ BOT_1_PIN,     8
    .equ BOT_1_BIT,     12
    .equ BOT_1_MASK,    (1 << BOT_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ BOT_2_PORT,    4
    .equ BOT_2_PIN,     9
    .equ BOT_2_BIT,     13
    .equ BOT_2_MASK,    (1 << BOT_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ BOT_3_PORT,    4
    .equ BOT_3_PIN,     10
    .equ BOT_3_BIT,     14
    .equ BOT_3_MASK,    (1 << BOT_3_BIT)

// Recursos utilizados por la cuarta tecla
    .equ BOT_4_PORT,    6
    .equ BOT_4_PIN,     7
    .equ BOT_4_BIT,     15
    .equ BOT_4_MASK,    (1 << BOT_4_BIT)

// Recursos utilizados por el teclado
    .equ BOT_GPIO,      5
    .equ BOT_OFFSET,    ( BOT_GPIO << 2)
    .equ BOT_MASK,      ( BOT_1_MASK | BOT_2_MASK | BOT_3_MASK | BOT_4_MASK)

/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

	//Me gusto la implementacion del profesor para señalar desde un principio
	//como van los leds.
conversor:
	.word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK // 0
	.word SEG_B_MASK + SEG_C_MASK 											// 1
	.word SEG_A_MASK + SEG_B_MASK + SEG_G_MASK + SEG_D_MASK + SEG_E_MASK 	// 2
	.word SEG_A_MASK + SEG_G_MASK + SEG_C_MASK + SEG_B_MASK + SEG_D_MASK 	// 3
	.word SEG_B_MASK + SEG_C_MASK + SEG_F_MASK + SEG_G_MASK 				// 4
	.word SEG_A_MASK + SEG_F_MASK + SEG_G_MASK + SEG_D_MASK + SEG_C_MASK 	// 5
	.word SEG_A_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK 	// 6
	.word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK 				 				// 7
	.word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK +  SEG_F_MASK + SEG_G_MASK // 8
	.word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK +  SEG_F_MASK + SEG_G_MASK // 9

data_segundos:
	.byte 0x0
	.byte 0x0

data_minutos:
	.byte 0x0
	.byte 0x0

data_hora:
	.byte 0x0
	.byte 0x0

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

    // Configura los pines de los digitos
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#((DIG_1_PORT << 5 | DIG_1_PIN) << 2)]
    STR R0,[R1,#((DIG_2_PORT << 5 | DIG_2_PIN) << 2)]
    STR R0,[R1,#((DIG_3_PORT << 5 | DIG_3_PIN) << 2)]
    STR R0,[R1,#((DIG_4_PORT << 5 | DIG_4_PIN) << 2)]

    // Configura los pines de los digitos
    STR R0,[R1,#((SEG_A_PORT << 5 | SEG_A_PIN) << 2)]
    STR R0,[R1,#((SEG_B_PORT << 5 | SEG_B_PIN) << 2)]
    STR R0,[R1,#((SEG_C_PORT << 5 | SEG_C_PIN) << 2)]
    STR R0,[R1,#((SEG_D_PORT << 5 | SEG_D_PIN) << 2)]
    STR R0,[R1,#((SEG_E_PORT << 5 | SEG_E_PIN) << 2)]
    STR R0,[R1,#((SEG_F_PORT << 5 | SEG_F_PIN) << 2)]
    STR R0,[R1,#((SEG_G_PORT << 5 | SEG_G_PIN) << 2)]

    // Apaga todos los bits gpio de los 7 segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    // Se apagan los bits gpio correspondientes a los digitos.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Configura los bits gpio de los 7 segmentos
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    // Se configuran los digitos de los 7 segmentos como salida.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
	puntero			.req R0
    valor 			.req R2
    display_activo 	.req R3
	io_pines		.req R4
	not_pines		.req R5

    MOV R0,#0x100000

    demora:
    SUBS R0,#1
    BNE demora

    // Define el estado actual de los 7seg y los digitos como todos apagados
    MOV   valor, #0x00
    STR   valor, [io_pines, #DIG_OFFSET]
    STR   valor, [io_pines, #SEG_N_OFFSET]

	//Defino con cual display vamos a molestar (display + 1 modulo 4)
	ADD display_activo, #1
	AND display_activo, #3

	//Actualizo el segmento con los datos
	LDR		puntero, =data_segundos
	LDRB	valor, [puntero, display_activo]		//traigo el minuto u hora. 
	LDR		puntero, =conversor
	LDR		valor, [puntero, valor, LSL #2]			//convierto asi le hago el display
    
	STR     valor, [io_pines, #SEG_N_OFFSET]
    
    // Prende el digito n
	LDR		puntero, =mostrar_display
	LDR		valor, [puntero, display_activo, LSL #2]	//traigo la mascara de mi digito
    STR     valor, [io_pines, #DIG_OFFSET]		//escribo mi digito
    
    // Repite el lazo de refresco indefinidamente
    B     refrescar

stop:
    B stop
    .pool                   // Almacenar las constantes de código
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina de inicialización del SysTick                                             */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48000000 - 1)
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de código
.endfunc

/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDRB R1,[R0]                // Se carga el valor de la variable espera
    SUBS R1,#1                  // Se decrementa el valor de espera
    BHI  systick_exit           // Si Espera > 0 entonces NO pasaron 10 veces

	PUSH {R0, LR}
	BL	actualiza_reloj
	POP {R0, LR}

    MOV  R1,#10                 // Se recarga la espera con 10 iteraciones

	//Hago que el sistick actualize las estructuras de datos.

systick_exit:
    STRB R1,[R0]                // Se actualiza la variable espera
    BX   LR                     // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
    .endfunc


actualiza_reloj:
        PUSH {LR} // Conservar la dirección de retorno
        MOV R0, #1                  //Setea R0 en 1
        LDR R1, =data_segundos        //Guardo direccion del LSB es decir del seg0
        BL incrementar                // Llamo a la incrementar
        CMP R0, #1                   // Comparo R0 con 1
        ITT EQ
        ADDEQ R1, #2                //Salto si R0 = 1 (si hay desbordamiento de seg)
        BLEQ incrementar            //Salto si R0 = 1 (si hay desbordamiento de seg)
        POP {PC} // Retornar recuperando PC de la pila


incrementar:
        PUSH {R4-R5}
        LDRB R4, [R1]       // Busca el valor menos significativo
        ADD R4, R0          // Se incrementa en R0 cantidad
        MOV R0, #0              // Setea el valor de retorno por defecto
        CMP R4, #9
        BLS final_incrementar       // Salta si es menor o igual que 9
        SUB R4, #9              // Calcula la cantidad que se desbordo
        LDRB R5, [R1, #1]        // Busca el valor mas significativo
        ADD R5, R4              // Se incrementa en la cantidad de desborde
        MOV R4, #0              // Resetea el menos significatico
        CMP R5, #5
        BLS salto_incrementar       // Salta si es menor o igual que 5
        MOV R5, #0                  // Resetea el mas significatico
        MOV R0, #1                  // Setea el valor de retorno por desborde

salto_incrementar:
        STRB R5, [R1, #1]           // Almacena el nuevo valor menos significativo

final_incrementar:
        STRB R4, [R1]           // Almacena el nuevo valor mas significativo
        POP {R4-R5}
        BX LR                    // Retorna al programa principal


mostrar_display:
	.word DIG_1_MASK
	.word DIG_2_MASK
	.word DIG_3_MASK
	.word DIG_4_MASK
