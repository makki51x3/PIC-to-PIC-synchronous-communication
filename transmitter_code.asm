#INCLUDE "P16F877A.INC"  ;

__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_OFF & _BODEN_OFF & _LVP_OFF & _HS_OSC ; 
	
REG1	    EQU 0X20 ;
REG2	    EQU 0X21 ;
REG3	    EQU 0X22 ;
TEMP	    EQU 0X23 ;
	
ORG 0x00
 
CONFI	BSF STATUS,RP0
	MOVLW H'FF'
	MOVWF TRISB	;PORT B INPUT
	MOVLW H'FF'
	MOVWF TRISC	;PORT C USART MODE
	MOVLW D'12'
	MOVWF SPBRG
	MOVLW H'B0'	; Synchronous Master,8-bit transmit
	MOVWF TXSTA
	BCF STATUS,RP0
	MOVLW H'80'	; Synchronous Master,8-bit transmit
	MOVWF RCSTA
	
MAIN	BSF STATUS,RP0
	BTFSS TXSTA,TRMT ; TEST IF TRMT IS EMPTY
	GOTO MAIN	 ; KEEP ON TESTING IF FULL
	BCF STATUS,RP0
	MOVF PORTB,W	 ; ELSE START SENDING DATA
	MOVWF TXREG
DELAY 	MOVLW D'1'	; DELAY 100 MS
	MOVWF REG3
REFILL2 MOVLW D'98'
	MOVWF REG2
REFILL1 MOVLW D'255'
	MOVWF REG1
CORE	DECFSZ REG1,F
	GOTO CORE
	DECFSZ REG2,F
	GOTO REFILL1
	DECFSZ REG3,F
	GOTO REFILL2
	GOTO MAIN
	
END
