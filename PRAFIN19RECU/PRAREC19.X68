*-----------------------------------------------------------
* Title      : PRAREC19
* Written by : <nombres completos de los autores>
* Date       : 28/06/2019
* Description: Emulador de la BBMe
*-----------------------------------------------------------
    ORG $1000
EPROG: DC.W $080E,$0020,$500B,$090F,$0029,$500B,$C803
       DC.W $D8C3,$D7F9,$500B,$6007,$001D,$1910,$8000
       DC.W $0004,$0003,$0000
EIR:   DC.W 0 ;eregistro de instruccion
EPC:   DC.W 0 ;econtador de programa
ER0:   DC.W 0 ;eregistro R0
ER1:   DC.W 0 ;eregistro R1
ER2:   DC.W 0 ;eregistro R2
ER3:   DC.W 0 ;eregistro R3
EB4:   DC.W 0 ;eregistro B4
EB5:   DC.W 0 ;eregistro B5
ESR:   DC.W 0 ;eregistro de estado (00000000 00000ZNC)

START:
    CLR.W EPC

FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion

        MOVE.W EPC,A0       
        ADD.W A0,A0             ;multiplicacion x2 del valor para que al ser
        MOVE.W EPROG(A0),EIR    ;sumado coincida con el valor real en 68K
        ADDQ.W #1,EPC

    ;--- FFETCH: FIN FETCH
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1
        
        SUBQ.W #2,SP            ;preparacion de la pila 
        MOVE.W EIR,-(SP)        ;paso de parámetros por pila 
        JSR DECOD
        MOVE.W 2(SP),D1         ;obtencion del resultado
        ADDQ.L #4,SP   ;limpieza de la pila

    ;--- FBRDECOD: FIN SALTO A DECOD
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ETRA
    JMP ELD
    JMP ELDI
    JMP EST
    JMP ESTI
    JMP EJMN
    JMP EJMZ
    JMP EJMI
    JMP EHLT
    JMP ENOR
    JMP ESET
    JMP EADQ
    JMP EADD
    JMP ESUB
    JMP ETST
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
ETRA:

    BRA FETCH
ELD:

    BRA FETCH
ELDI:

    BRA FETCH
EST:

    BRA FETCH
ESTI:

    BRA FETCH
EJMN:

    BRA FETCH
EJMZ:

    BRA FETCH
EJMI:

    BRA FETCH
EHLT:

    SIMHALT
ENOR:

    BRA FETCH
ESET:

    BRA FETCH
EADQ:

    BRA FETCH
EADD:

    BRA FETCH
ESUB:

    BRA FETCH
ETST:

    BRA FETCH
    ;--- FEXEC: FIN EJECUCION

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion
        
    ;--- FSUBR: FIN SUBRUTINAS

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
    BTST.B #7, 4(SP)
    BEQ I0
I1:
    BTST.B #6, 4(SP)
    BEQ I10
I11:
    BTST.B #5, 4(SP)
    BEQ I110
I111:
    BTST.B #3, 4(SP)
    BEQ I11100
I11101:
    MOVE.W #14, 6(SP)   ;TST
    RTS
I11100:
    MOVE.W #13, 6(SP)   ;SUB
    RTS
I110:
    BTST.B #4, 4(SP)
    BEQ I1100
I1101:
    BTST.B #3, 4(SP)
    BEQ I11010
I11011:
    MOVE.W #12, 6(SP)   ;ADD
    RTS
I11010:
    MOVE.W #11, 6(SP)   ;ADQ
    RTS
I1100:
    BTST.B #3, 4(SP)
    BEQ I11000
I11001:
    MOVE.W #10, 6(SP)   ;SET
    RTS
I11000:
    MOVE.W #9, 6(SP)    ;NOR
    RTS
I10:
    MOVE.W #8, 6(SP)    ;HLT
    RTS
I0:
    BTST.B #6, 4(SP)
    BEQ I00 
I01:
    BTST.B #5, 4(SP)
    BEQ I010
I011:
    MOVE.W #7, 6(SP)    ;JMI
    RTS
I010:
    BTST.B #4, 4(SP)
    BEQ I0100
I0101:
    MOVE.W #6, 6(SP)    ;JMZ
    RTS
I0100:
    MOVE.W #5, 6(SP)    ;JMN
    RTS
I00:
    BTST.B #5, 4(SP)
    BEQ I000
I001:
    MOVE.W #4, 6(SP)    ;STI
    RTS
I000:
    BTST.B #4, 4(SP)
    BEQ I0000
I0001:
    BTST.B #3, 4(SP)
    BEQ I00010
I00011:
    MOVE.W #3, 6(SP)    ;ST
    RTS
I00010:
    MOVE.W #2, 6(SP)    ;LDI
    RTS
I0000:
    BTST.B #3, 4(SP)
    BEQ I00000
I00001:
    MOVE.W #1, 6(SP)    ;LD
    RTS
I00000:
    MOVE.W #0, 6(SP)    ;TRA
    RTS
    ;--- FDECOD: FIN DECOD
    END    START