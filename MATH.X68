; ===========================================================================================
; TITLE    : MATH SUBROUTINES
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================

;--------------------------------------------------------------------------------------------
GETDISVM
; OBTAINING THE VECTOR OF THE POSITION X(D0.W),Y(D1.W) TO THE MPC'S POSITION
; INPUT    - D0.W:= X
;          - D1.W:= Y
;
; OUTPUT   - D0:= DELTA_X
;		   - D1:= DELTA_Y
;		   - D2:= DISTANCIA
;
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------

            MOVE.L     D3,-(A7)					; SAVING D3 IN THE PILE
            
            MOVE.W      (MPCX),D2				; D2:= X2
            MOVE.W      (MPCY),D3				; D3:= Y2
            ADDQ.W		#8,D2
            ADDQ.W		#8,D3
            
            SUB.W		D0,D2					; D2:= DELTA_X
            SUB.W		D1,D3					; D3:= DELTA_Y
            
			MOVE.W		D2,D0					; COPY DELTA_X AND DELTA_Y IN D0 AND D1 IN THE ORTHER GIVEN
            MOVE.W		D3,D1
            
            MULS.W		D2,D2					; D2:= DELTA_X^2
            MULS.W		D3,D3					; D3:= DELTA_Y^2
            
            ADD.L		D3,D2					; D2:= DELTA_X^2+DELTA_Y^2
            BSR			SQRTD2
            
            MOVE.L     (A7)+,D3					; WE GET BACK D3
            RTS
;--------------------------------------------------------------------------------------------
GETDIST
; OBTAINING THE VECTOR OF THE POSITION THE OBJECT1 TO THE POSITION OF OBJETO2
; INPUT    - D0.W:= X2
;          - D1.W:= Y2
;		   - D2.W:= X1
;		   - D3.W:= Y1
;
; OUTPUT   - D0:= DELTA_X
;		   - D1:= DELTA_Y
;		   - D2:= DISTANCIA
;
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------

            MOVE.L     D3,-(A7)					; SAVING D3 IN THE PILE
            
            SUB.W		D0,D2					; D2:= DELTA_X
            SUB.W		D1,D3					; D3:= DELTA_Y
            
			MOVE.W		D2,D0					; COPY DELTA_X AND DELTA_Y IN D0 AND D1 ONE AFTER THE OTHER
            MOVE.W		D3,D1
            
            MULS.W		D2,D2					; D2:= DELTA_X^2
            MULS.W		D3,D3					; D3:= DELTA_Y^2
            
            ADD.L		D3,D2					; D2:= DELTA_X^2+DELTA_Y^2
            BSR			SQRTD2
            
            MOVE.L     (A7)+,D3					; WE GET D3
            RTS            
;--------------------------------------------------------------------------------------------
SQRTD2
; OBTAINING SQUARE ROOT OF D0.L
; INPUT    - D2:= NÚMERO
; OUTPUT   - D2:= SQRT(NÚMERO)
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------

			MOVEM.L		D0/D3-D5,-(A7)
			MOVE.L		D2,D0
			CLR.L		D5
			CLR.L		D2
			
			MOVEQ.L		#$1F,D3
			
.SQRTLOOP	LSL.L		#1,D0					; D0:= 2*D0
			ADDX.L		D2,D2						
			LSL.L		#1,D5					; D5:= 2*D5
			LSL.L		#1,D0					; D0:= 2*D0
			ADDX.L		D2,D2					
			
			MOVE.L		D5,D4					; D4:= N (D5=N)
			LSL.L		#1,D4					; D4:= 2*N
			ADDQ.L		#1,D4					; D4:= 2*N+1
			
			CMP.L		D4,D2					; COMPARING D4 WITH D2 (THE REST)
			BCS			.SQRTNS					; BRANCH IF CARRY
			
			SUB.L		D4,D2					; D2:= RESTO-2N+1
			ADDQ.L		#1,D5

.SQRTNS		DBRA		D3,.SQRTLOOP			
			
			SWAP		D5						; SWAP FOR PUTTING THE CORRECT RESULT
			MOVE.L		D5,D2					; D2 := N
			
			MOVEM.L		(A7)+,D0/D3-D5
			RTS











*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
