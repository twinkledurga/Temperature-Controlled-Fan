ORG 0000H

;--------------------------------
; PORT AND BIT DEFINITIONS
;--------------------------------
FAN_OUT     BIT P2.0
SIM_TEMP    EQU 30H     ; simulated temperature storage in RAM

MAIN:
    MOV P1, #00H        ; initialize Port 1 (temperature display)
    MOV P2, #00H        ; initialize Port 2 (fan)
    MOV SIM_TEMP, #24   ; start temperature below threshold

AGAIN:
    ; simulate ADC read
    MOV A, SIM_TEMP
    MOV R1, A           ; store temp in R1

    ; display temperature gradually
    MOV P1, R1          ; update Port 1
    ACALL SHORT_DELAY   ; short incremental delay

    ; FAN CONTROL LOGIC
    MOV A, R1
    CJNE A, #25, CHK_LOW
    SJMP FAN_OFF
CHK_LOW:
    JC FAN_OFF
    CJNE A, #30, CHK_MED
    SJMP FAN_LOW
CHK_MED:
    JC FAN_LOW
    CJNE A, #35, FAN_HIGH
    JC FAN_MED
    SJMP FAN_HIGH

;-----------------------------
; FAN STATES
;-----------------------------
FAN_OFF:
    CLR FAN_OUT
    ACALL SHORT_DELAY   ; shorter delay for visual effect
    INC SIM_TEMP        ; simulate temp rise
    SJMP AGAIN

FAN_LOW:
    CPL FAN_OUT         ; toggle fan
    ACALL SHORT_DELAY
    INC SIM_TEMP
    SJMP AGAIN

FAN_MED:
    CPL FAN_OUT         ; toggle fan
    ACALL SHORT_DELAY
    INC SIM_TEMP
    SJMP AGAIN

FAN_HIGH:
    SETB FAN_OUT
    ACALL SHORT_DELAY
    DEC SIM_TEMP        ; simulate temp decrease
    SJMP AGAIN

;-----------------------------
; SHORT DELAY SUBROUTINE
;-----------------------------
SHORT_DELAY:
    MOV R3, #50
SD1: MOV R4, #255
SD2: DJNZ R4, SD2
    DJNZ R3, SD1
    RET

END
