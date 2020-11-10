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
    .equ LED_A_PORT,    4
    .equ LED_A_PIN,     0
    .equ LED_A_BIT,     0
    .equ LED_A_MASK,    (1 << LED_A_BIT)

// Recursos utilizados por el segmento B
    .equ LED_B_PORT,    4
    .equ LED_B_PIN,     1
    .equ LED_B_BIT,     1
    .equ LED_B_MASK,    (1 << LED_B_BIT)

// Recursos utilizados por el segmento C
    .equ LED_C_PORT,    4
    .equ LED_C_PIN,     2
    .equ LED_C_BIT,     2
    .equ LED_C_MASK,    (1 << LED_C_BIT)

// Recursos utilizados por el segmento D
    .equ LED_D_PORT,    4
    .equ LED_D_PIN,     3
    .equ LED_D_BIT,     3
    .equ LED_D_MASK,    (1 << LED_D_BIT)

// Recursos utilizados por el segmento E
    .equ LED_E_PORT,    4
    .equ LED_E_PIN,     4
    .equ LED_E_BIT,     4
    .equ LED_E_MASK,    (1 << LED_E_BIT)

// Recursos utilizados por el segmento F
    .equ LED_F_PORT,    4
    .equ LED_F_PIN,     5
    .equ LED_F_BIT,     5
    .equ LED_F_MASK,    (1 << LED_F_BIT)

// Recursos utilizados por el segmento G
    .equ LED_G_PORT,    4
    .equ LED_G_PIN,     6
    .equ LED_G_BIT,     6
    .equ LED_G_MASK,    (1 << LED_G_BIT)

// Recursos utilizados por el segmento DP
    .equ LED_DP_PORT,    6
    .equ LED_DP_PIN,     8
    .equ LED_DP_BIT,     16
    .equ LED_DP_MASK,    (1 << LED_DP_BIT)
    .equ LED_DP_GPIO,    5
    .equ LED_DP_OFFSET,  ( LED_DP_GPIO << 2)

// Recursos utilizados por los leds del 7 segmentos
    .equ LED_N_GPIO,    2
    .equ LED_N_OFFSET,  ( LED_N_GPIO << 2)
    .equ LED_N_MASK,    ( LED_A_MASK | LED_B_MASK | LED_C_MASK | LED_D_MASK | LED_E_MASK | LED_F_MASK | LED_G_MASK)

// -------------------------------------------------------------------------    
// Recursos utilizados por la primera tecla
    .equ TEC_1_PORT,    4
    .equ TEC_1_PIN,     8
    .equ TEC_1_BIT,     12
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ TEC_2_PORT,    4
    .equ TEC_2_PIN,     9
    .equ TEC_2_BIT,     13
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    4
    .equ TEC_3_PIN,     10
    .equ TEC_3_BIT,     14
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por la cuarta tecla
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO,      5
    .equ TEC_OFFSET,    ( TEC_GPIO << 2)
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK)

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
    @ .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
espera:
    .zero 1                 // Variable compartida con el tiempo de espera

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
    @ BL systick_init

    // Configura los pines de los digitos
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#((DIG_1_PORT << 5 | DIG_1_PIN) << 2)]
    STR R0,[R1,#((DIG_2_PORT << 5 | DIG_2_PIN) << 2)]
    STR R0,[R1,#((DIG_3_PORT << 5 | DIG_3_PIN) << 2)]
    STR R0,[R1,#((DIG_4_PORT << 5 | DIG_4_PIN) << 2)]

    // Configura los pines de los digitos
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#((LED_A_PORT << 5 | LED_A_PIN) << 2)]
    STR R0,[R1,#((LED_B_PORT << 5 | LED_B_PIN) << 2)]
    STR R0,[R1,#((LED_C_PORT << 5 | LED_C_PIN) << 2)]
    STR R0,[R1,#((LED_D_PORT << 5 | LED_D_PIN) << 2)]
    STR R0,[R1,#((LED_E_PORT << 5 | LED_E_PIN) << 2)]
    STR R0,[R1,#((LED_F_PORT << 5 | LED_F_PIN) << 2)]
    STR R0,[R1,#((LED_G_PORT << 5 | LED_G_PIN) << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#((TEC_1_PORT << 5 | TEC_1_PIN) << 2)]
    STR R0,[R1,#((TEC_2_PORT << 5 | TEC_2_PIN) << 2)]
    STR R0,[R1,#((TEC_3_PORT << 5 | TEC_3_PIN) << 2)]
    STR R0,[R1,#((TEC_4_PORT << 5 | TEC_4_PIN) << 2)]

    // Apaga todos los bits gpio de los 7 segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Se apagan los bits gpio correspondientes a los digitos.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Configura los bits gpio de los 7 segmentos
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#LED_N_OFFSET]
    ORR R0,#LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Se configuran los digitos de los 7 segmentos como salida.
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK        //Complementa tec_mask y le hace un and con r0
    STR R0,[R1,#TEC_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
    
    // Define el estado actual de los 7seg y los digitos como todos apagados
    MOV   R3,#0x00
    @ STR   R0, [R4, #DIG_OFFSET]    //Posiblemente seria bueno usar la mascara aca
    @ STR   R0, [R4, #LED_N_OFFSET]    //Posiblemente seria bueno usar la mascara aca

    // Carga el estado actual de las teclas
    LDR     R0,[R4,#TEC_OFFSET]

    // Verifica el estado del bit correspondiente a las 4 teclas
    TEQ     R0,#TEC_MASK

    // Si la tecla esta apretada
    ITE      EQ

    // Escribe en GPIO los 7segmentos que queremos prendidos
    MOVEQ     R3, #(LED_B_MASK | LED_C_MASK | LED_E_MASK | LED_F_MASK)
    MOVNE     R3, #0
    STR     R3,[R4,#LED_N_OFFSET]
    
    // Prende el digito 1
    MOV     R3, #DIG_1_MASK
    STR     R3, [R4, #DIG_OFFSET]
    
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
    @ LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    @ MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    @ STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc
