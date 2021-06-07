; ===========================================================================================
; TITLE   : MOUSE MANAGEMENT
; AUTHOR  : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS:
; HISTORY :
; ===========================================================================================

;--------------------------------------------------------------------------------------------
MOUSEREAD
; GET ACTUAL MOUSE STATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            
            MOVEM.L D0-D1, -(A7)
            
            MOVE.B  #61,D0              ; WE CALL TASK 61 -> READ THE MOUSE
            MOVE.B  #0,D1               ; READ THE ACTUAL MOUSE STATE
            TRAP    #15
            
            MOVE.B  D0,(MSTATE)         ; RETURN MOUSE STATE
            MOVE.L  D1,(MPOS)           ; RETURN MOUSE POSITION
            
            MOVEM.L (A7)+,D0-D1
            
            RTS




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
