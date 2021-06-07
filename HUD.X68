; ===========================================================================================
; TITLE    : HUD MANAGEMENT
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================

;--------------------------------------------------------------------------------------------
PLOTHUD
; DISPLAYS HP,MP AND SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------

			JSR		HEALTH      
			JSR		MANA
			JSR		SCORE
			RTS

;--------------------------------------------------------------------------------------------
HEALTH
; DISPLAYS HP
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			MOVEM.L	D0-D4,-(A7)
			
			MOVE.L	#$0000FF00,D1	; SET BACKGROUND COLOR
			MOVE.B	#81,D0
			TRAP	#15
			
			MOVE.L	#$00000000,D1	; SET PEN COLOR
			MOVE.B	#80,D0
			TRAP	#15
			
			MOVE.W	#4,D1			; X1
			MOVE.W	#4,D2			; Y1
			
			MOVE.W	(MPCHP),D3		; X2
			MOVE.W	#16,D4			; Y2
			
			MOVE.B	#87,D0
			TRAP	#15
			
			MOVEM.L	(A7)+,D0-D4
			RTS
			
;--------------------------------------------------------------------------------------------
MANA
; DISPLAYS MANA
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			MOVEM.L	D0-D4,-(A7)
			
			MOVE.L	#$00FF0000,D1	; SET BACKGROUND COLOR
			MOVE.B	#81,D0
			TRAP	#15
			
			MOVE.L	#$00000000,D1	; SET PEN COLOR
			MOVE.B	#80,D0
			TRAP	#15
			
			MOVE.W	#4,D1			; X1
			MOVE.W	#16+4,D2		; Y1
			
			MOVE.W	(MPCMANA),D3	; X2
			MOVE.W	#16+12+4,D4		; Y2
			
			MOVE.B	#87,D0
			TRAP	#15
			
			MOVEM.L	(A7)+,D0-D4
			RTS
	
;--------------------------------------------------------------------------------------------
SCORE
; DISPLAY SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)
            
            UTLSPEN #MPCTXTCL               ; PLOT THE SCORE TEXT
            UTLSFIL #$00000000
            UTLLOCT MPCTXTX,MPCTXTY
            LEA     .SCORESTR,A1
            CLR.L   D1
            MOVE.W  (MPCSCORE),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D4/A1
            RTS
.SCORESTR   DC.B    'SCORE: ',0
			
			RTS




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
