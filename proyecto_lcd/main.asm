; PIC16F877A Configuration Bit Settings
; Assembly source line config statements
#include "p16f877a.inc"
; CONFIG
;__config 0x3F32 
    __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
ORG 0x0000
    
    ;PENDIENTE: REALIZAR LOS CALCULOS PARA EL DELAY, PARA PODER OBTENER TIEMPOS OPTIMOS
    #DEFINE RS RB0     
    #DEFINE E RB1

    CBLOCK  0x20
    COUNT_1
    COUNT_2
    COUNT_3
    ENDC
     ;SELECCIONAMOS EL BANCO 1     
    BSF	    STATUS, RP0
    BCF	    STATUS, RP1     
     ;COLOCAMOS LOS PUERTOS B Y D COMO SALIDAS
    CLRF    TRISD     
    CLRF    TRISB
    CLRW
    MOVLW   B'11000011'
    MOVWF   TRISC
    ;REGRESAMOS AL BANCO 0     
    BCF	    STATUS, RP0
    BCF	    STATUS, RP1
    BCF	    PORTC,  RC3
    BCF	    PORTC,  RC4     
    BCF	    PORTC,  RC5     
    CLRF    PORTD
    CLRF    PORTB     
    ;CONFIGURACION PUERTOS PWM

    MOVLW   B'00000110'
    MOVWF   T2CON
    BSF     CCP1CON, CCP1X
    BCF     CCP1CON, CCP1Y
    BSF     CCP1CON, CCP1M3
    BSF     CCP1CON, CCP1M2

    GOTO    LCD_CONFIG
     
LCD_CONFIG
    BCF	    PORTB, RS
    ;CONFIGURACION INICIAL DEL CURSOR
    CLRW     
    MOVLW   B'00001111'
    CALL    E_PULSE
    
    ;LIMPIAMOS LO QUE ESTE ESCRITO EN LA PANTALLA
    CLRW     
    MOVLW   B'00000001'   
    CALL    E_PULSE

    CLRW     
    MOVLW   B'00000010'
    CALL    E_PULSE
     
    GOTO    TYPE_WORD  
     
TYPE_WORD     
    ;ESCRIBIMOS LO QUE NECESITEMOS
    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01000101'; E    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101100'; l   
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101001'; i    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100111'; g 
    CALL    E_PULSE 

    BSF	    PORTB, RS     
    CLRW    
    MOVLW   B'01100101'; e 
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'00000010'; SPACE  
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01110101'; u    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101110'; n    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'00000010'; SPACE    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01110100'; t 
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101111'; o    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101110'; n    
    CALL    E_PULSE

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101111'; o    
    CALL    E_PULSE 

    BSF	    PORTB, RS
    CLRW
    MOVLW   B'00000010'; SPACE
    CALL    E_PULSE
    
    BSF	    PORTB, RS
    CLRW
    MOVLW   B'00111010'; :
    CALL    E_PULSE
    
    BSF	    PORTB, RS
    CLRW
    MOVLW   B'01000100'; D
    CALL    E_PULSE
    
    ;SILENCING THE BUZZER
    ;BCF     STATUS, RP0
    ;BCF     STATUS, RP1
    ;MOVLW   D'0'
    ;MOVWF   PR2
    ;MOVLW   D'0'
    ;MOVWF   CCPR1L
    GOTO    SELECT_SONG

;FCY = 4MHz
;TCY = 4MHz/4 = 1MHz
;CY  = 1/TCY  = 100ns 
DELAY
    ;MOVLW	0x08
    MOVLW	D'256'
    MOVWF	COUNT_1
    MOVLW	D'10'
    MOVWF	COUNT_2
    MOVLW	D'1'
    MOVWF	COUNT_3
    CALL LOOP
    RETURN
LOOP
    DECFSZ  COUNT_1,1
    GOTO    $ + 2
    DECFSZ  COUNT_2,1
    GOTO    $ + 2
    DECFSZ  COUNT_3,1
    GOTO    $ + 2
    RETURN
    GOTO LOOP    
;MENU PRINCIPAL
SELECT_SONG
    BTFSC   PORTC, RC0
    CALL    SONG_1
    BTFSC   PORTC, RC1
    CALL    SONG_2
    BTFSC   PORTC, RC6	
    CALL    SONG_3
    BTFSC   PORTC, RC7
    CALL    SILENCE
    GOTO    SELECT_SONG
SONG_1
    BSF	    PORTC, RC3
    BCF	    PORTC, RC4
    BCF	    PORTC, RC5
    BCF     STATUS, RP0
    BCF     STATUS, RP1
    MOVLW   D'140'
    MOVWF   PR2
    MOVLW   D'10'
    MOVWF   CCPR1L
    RETURN
SONG_2
    BCF	    PORTC, RC3
    BSF	    PORTC, RC4
    BCF	    PORTC, RC5
    BCF     STATUS, RP0
    BCF     STATUS, RP1
    MOVLW   D'62'
    MOVWF   PR2
    MOVLW   D'31'
    MOVWF   CCPR1L
    RETURN
SONG_3
    BCF	    PORTC, RC3
    BCF	    PORTC, RC4
    BSF	    PORTC, RC5
    BCF     STATUS, RP0
    BCF     STATUS, RP1
    MOVLW   D'6'
    MOVWF   PR2
    MOVLW   D'3'
    MOVWF   CCPR1L
    RETURN
SILENCE
    BCF	    PORTC, RC3
    BCF	    PORTC, RC4
    BCF	    PORTC, RC5
    BCF     STATUS, RP0
    BCF     STATUS, RP1
    MOVLW   D'0'
    MOVWF   PR2
    MOVLW   D'0'
    MOVWF   CCPR1L
    RETURN
;PULSO EN EL PIN E DE LA PANTALLA LCD
E_PULSE
    MOVWF   PORTD     
    BSF	    PORTB, E
    NOP
    BCF	    PORTB, E     
    CALL    DELAY
    CLRW
    CLRF    PORTD
    NOP
    RETURN
END
