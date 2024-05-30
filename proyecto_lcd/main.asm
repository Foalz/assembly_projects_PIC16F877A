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

    CBLOCK 0x20
         COUNT
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
    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01000101'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101100'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101001'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100111'    
    CALL    E_PULSE 

    BSF	    PORTB, RS     
    CLRW    
    MOVLW   B'01100101'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'00000000'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01110101'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101110'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100001'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'00000000'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100011'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100001'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101110'    
    CALL    E_PULSE

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01100011'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101001'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101111'    
    CALL    E_PULSE 

    BSF	    PORTB, RS         
    CLRW    
    MOVLW   B'01101110'    
    CALL    E_PULSE 

    BSF	    PORTB, RS
    CLRW
    MOVLW   B'00000000'
    CALL    E_PULSE
    
    BSF	    PORTB, RS
    CLRW
    MOVLW   B'00111010'
    CALL    E_PULSE
    
    BSF	    PORTB, RS
    CLRW
    MOVLW   B'01000100'
    CALL    E_PULSE
    
    ;SILENCING THE BUZZER
    BCF     STATUS, RP0
    BCF     STATUS, RP1
    MOVLW   D'0'
    MOVWF   PR2
    MOVLW   D'0'
    MOVWF   CCPR1L
    GOTO    SELECT_SONG

;FCY = 4MHz
;TCY = 4MHz/4 = 1MHz
;CY  = 1/TCY  = 100ns 
;DELAY CODE
DELAY; 1C  + 2C + 1C + 1C + 200C + 2C
    MOVLW   D'200'
    GOTO    DELAY_1
DELAY_1
    MOVWF   COUNT
LOOP
    DECFSZ  COUNT,1
    GOTO    LOOP
    RETURN
    
;CODE TO PRINT A LETTER IN LCD
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
;CODE TO TRIGGER A PULSE TO E PIN IN LCD
E_PULSE
    MOVWF   PORTD     
    BSF	    PORTB, E
    NOP
    BCF	    PORTB, E     
    CALL    DELAY
    CALL    DELAY
    CALL    DELAY
    CALL    DELAY
    CALL    DELAY
    NOP
    RETURN
END
