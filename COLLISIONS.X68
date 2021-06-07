; ===========================================================================================
; TITLE    : COLLISION MANAGEMENT
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================

; -------------------------------------------------------------------------------------------
CHECKCOL
; CHECK IF SOMETHING IS GONNA COLIDE WITH A WALL ON ITS LEFT OR TOP
; INPUT	   - D0.L:= Y1,X1 -->"MENOR"
;		   - D1.L:= Y2,X2 -->"MAJOR"
;		   - D2.L:= YSPEED,XSPEED
; OUTPUT   - D0.L:= NEW_X1,NEW_Y1
; MODIFIES - NONE
; COMMENT  - IF(X1<X2) MENOR; IF(X1==X2 && Y1<Y2)MENOR; ELSE MAJOR;
; -------------------------------------------------------------------------------------------
			
			MOVEM.L	D1-D6/A0,-(A7)
			
			
			MOVE.L	D2,D4			;D4:= D2
			MOVE.L	D2,D5
			CLR.L	D3
			LEA		MAPS,A0			;GET ACTUAL MAP POINTER
			MOVE.B	(MPCMAP),D3
			LSL.L	#2,D3
			MOVE.L	(A0,D3),A0
			CLR.L	D3

.CHECK1 	; GETS THE NEW POSITION OF (Y1,X1) AND CHECKS IF ITS A WALL
			; MODIFIES: D2,D3,A0
			; SWAPS CONTENT OF (NOT MODIFIED): D0
			
			ADD.W	D0,D2			; D2 = YSPEED,GETNEWX1
			SWAP	D0				; D0 = X1,Y1
			SWAP	D2				; D2 = NEWX1,YSPEED
			ADD.W	D0,D2			; D2 = NEWX1,GETNEWY1
			
			CMP.W	#0,D2			; CHECK IF OUT OF TOP BOUND
			BLE		.END
			
			SWAP	D2
			CMP.W	#0,D2			; CHECK IF OUT OF LEFT BOUND
			BLE		.END
			
			CMP.W	#SCRWIDTH,D2	; CHECK IF OUT OF RIGHT BOUND
			BGE		.END
			
			SWAP	D2
			
			MOVE.W	D2,D3			; D3 = NEWY1
			DIVS.W	#16,D3			; D3 = NEWY1/16
			AND.L	#$FFFF,D3		; APPLY MASK --> D3 = ROW
			ASL.W	#2,D3			; GETARRAYPOSITION -> D3*4
			
			MOVE.L	(A0,D3),A0		; GETROWPOINTER
			
			SWAP	D2				; D2 = NEWY1,NEWX1
			MOVE.W	D2,D3			; D3 = NEWX1
			DIVS.W	#16,D3			; D3 = NEWX1/16
			AND.L	#$FFFF,D3		; APPLY MASK --> D3 = COLUMN
			MOVE.B	(A0,D3),D3		; D3 = GETCOLLISION
			BNE		.ISWALL			; IF D3>0 JUMP TO .ISWALL ELSE CONTINUE4
			
.CHECK2		; GETS THE NEW POSITION OF (Y2,X2) AND CHECKS IF ITS A WALL
			; MODIFIES: D4,D3,A0
			; SWAPS CONTENT OF (NOT MODIFIED): D1
			
			ADD.W	D1,D4			; D4 = Y2,GETNEWX2
			SWAP	D1				; D1 = X2,Y2
			SWAP	D4				; D4 = NEWX2,Y2
			ADD.W	D1,D4			; D4 = NEWX2,GETNEWY2
			
			CMP		#SCRHEIGH,D4	; CHECK IF OUT OF BOTTON BOUND
			BGE		.END
			
			LEA		MAPS,A0			; GET ACTUAL MAP POINTER
			MOVE.B	(MPCMAP),D3
			LSL.L	#2,D3
			MOVE.L	(A0,D3),A0
			CLR.L	D3
			
			MOVE.W	D4,D3			; D3 = NEWY2
			DIVS.W	#16,D3			; D3 = NEWY2/16
			AND.L	#$FFFF,D3		; APPLY MASK --> D3 = ROW
			ASL.W	#2,D3			; GETARRAYPOSITION -> D3*4
			
			MOVE.L	(A0,D3),A0		; GETROWPOINTER
			
			SWAP	D4				; D4 = NEWY2,NEWX2
			MOVE.W	D4,D3			; D3 = NEWX2
			DIVS.W	#16,D3			; D3 = NEWX2/16
			AND.L	#$FFFF,D3		; APPLY MASK --> D3 = COLUMN
			MOVE.B	(A0,D3),D3		; D3 = GETCOLLISION
			BNE		.ISWALL			; IF D3>1 JUMP TO .ISWALL ELSE CONTINUE
			
			SWAP	D5				; D5 = XSPEED,YSPEED
			ADD.W	D5,D0			; D0 = X1,GETNEWY1
			SWAP	D0				; D0 = NEWY1,X1
			SWAP 	D5				; D5 = YSPEED,XSPEED
			ADD.W	D5,D0			; D0 = NEWY1,GETNEWX1
			SWAP	D0				; D0 = NEWX1,NEWY1
			
			BRA		.END

.ISWALL		MOVE.W	D0,D1			; D1 = Y1
			AND.L	#$FFFF,D1		; APPLY MASK SO D1 ONLY HAS Y1
			
			DIVS.W	#16,D1			; D1 = D1/16
			SWAP	D1				; D1 = Q,R
			AND.L	#$FFFF,D1		; APPLY MASK SO D1 = R
			
			SWAP	D0				; D0 = Y1,X1
			MOVE.W	D0,D2			; D2 = X1
			AND.L	#$FFFF,D2		; APPLY MASK SO D2 ONLY HAS X1
			
			DIVS.W	#16,D2			; D2 = D2/16
			SWAP	D2				; D2 = Q,R
			AND.L	#$FFFF,D2		; APPLY MASK SO D2=R

			CMP.W	#0,D5
			BLT		.UPLEFT
			SWAP	D5
			CMP.W	#0,D5
			BLT		.UPLEFT	

			SUB.W	D2,D0			; D0 = Y1,GETNEWX1
			ADD.W	#15,D0
			SWAP	D0				; D0 = NEWX1,Y1
			SUB.W	D1,D0			; D0 = NEWX1,GETNEWY1
			ADD.W	#15,D0
			
			MOVEM.L	(A7)+,D1-D6/A0
			RTS	
			

.UPLEFT		SUB.W	D2,D0			; D0 = Y1,GETNEWX1
			SWAP	D0				; D0 = NEWX1,Y1
			SUB.W	D1,D0			; D0 = NEWX1,GETNEWY1
			
.END		MOVEM.L	(A7)+,D1-D6/A0
			RTS	



*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
