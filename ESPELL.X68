; ===========================================================================================
; TITLE    : SPELL MANAGEMENT (AGENT)
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS : 
; HISTORY  :
; ===========================================================================================

; -------------------------------------------------------------------------------------------
ESPELINI
; INIT THE SPELL
; INPUT    - D1.L = YPOS,XPOS
;		   - D2.W = DIRECTION
;		   - D3.W = DAMAGE
; OUTPUT   - NONE
; MODIFIES - NONE
; -------------------------------------------------------------------------------------------
			MOVE.L	D1,SPELLYPOS(A0)			; SAVE POS
			MOVE.W	D2,SPELLDIR(A0)				; SAVE DIRECTION
			MOVE.W	D3,ESPELDMG(A0)				; SAVE DAMAGE
			RTS

; -------------------------------------------------------------------------------------------
ESPELUPD
; UPDATES THE SPELL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -------------------------------------------------------------------------------------------
			MOVEM.L	D0-D2/A1,-(A7)
			
			CMP.B	#8,(MPCMAP)         ; IF IS NOT IN THE LAST MAP DESTROY SPELL
			BNE		.DESTROY
			
			JSR		COLMPC              ; CHECK COLLISION WITH MPC
			
			LEA		.JTABLE,A1
			MOVE.W	SPELLDIR(A0),D0     ; GET SPELL DIRECTION
			ASL.W	#2,D0
			MOVE.L	(A1,D0),A1			
			JMP 	(A1)				; SWITCH(DIRECTION)
			
.LEFT		MOVE.L	(A0),D0				; D0 = YPOS,XPOS
			MOVE.L	D0,D1				; D1 = D0
			CLR.W 	D2					; D2 = 0,YSPEED
			SWAP	D2					; D2 = YSPEED,0
			MOVE.W	#-SPELLSPD,D2		; D2 = YSPEED,XSPEED
			
			JSR	CHECKCOL				; CHECK IF IT'S GOING TO COLLIDE
			; RETURN -> NEWX,NEWY
			
			MOVE.W	2(A0),D1			; D1 = OLDX
			SWAP	D0					; D0 = NEWY,NEWX
			CMP.W	D0,D1
			BEQ		.DESTROY			; IF NEWX = OLDX THEN DESTROY IT BECAUSE IS NOT MOVING
			CMP.W	#0,D0				; CHECK IF OUT OF BOUNDS
			BLT		.DESTROY
			
			MOVE.W	D0,2(A0)			; SAVE NEW XPOS
			BRA		.END

.UP			MOVE.L	(A0),D0				; D0 = YPOS,XPOS
			MOVE.L	D0,D1				; D1 = D0
			MOVE.W	#-SPELLSPD,D2		; D2 = 0,YSPEED
			SWAP	D2
			CLR.W	D2					; D2 = YSPEED,XSPEED
			
			JSR	CHECKCOL				; CHECK IF IT'S GOING TO COLLIDE
			; RETURN -> NEWX,NEWY
			
			MOVE.W	(A0),D1				; D1 = OLDY
			CMP.W	D0,D1
			BEQ		.DESTROY			; IF OLDY = NEWY THEN DESTROY IT BECAUSE IS NOT MOVING
			CMP.W	#0,D0
			BLT		.DESTROY			; CHECK IF OUT OF BOUNDS
			
			MOVE.W	D0,(A0)				; SAVE NEW YPOS
			BRA		.END
			
.RIGHT		MOVE.L	(A0),D0				; D0 = YPOS,XPOS
			MOVE.L	D0,D1				; D1 = D0
			CLR.W 	D2					; D2 = 0,YSPEED
			SWAP	D2
			MOVE.W	#SPELLSPD,D2		; D2 = YSPEED,XSPEED
			
			JSR	CHECKCOL				; CHECK IF IT'S GOING TO COLLIDE
			; RETURN -> NEWX,NEWY
			
			MOVE.W	2(A0),D1			; D1 = OLDX
			SWAP	D0					; D0 = NEWY,NEWX
			CMP.W	D0,D1
			BEQ		.DESTROY			; IF OLDX = NEWX THEN DESTROY IT BECAUSE IS NOT MOVING
			CMP.W	#SCRWIDTH,D0		; CHECK IF OUT OF BOUNDS
			BGT		.DESTROY
			
			MOVE.W	D0,2(A0)			; SAVE NEW XPOS
			BRA		.END
			
.DOWN		MOVE.L	(A0),D0				; D0 = YPOS,XPOS
			MOVE.L	D0,D1				; D1 = D0
			MOVE.W	#SPELLSPD,D2		; D2 = 0,YSPEED
			SWAP	D2
			CLR.W	D2					; D2 = YSPEED,XSPEED
			
			JSR	CHECKCOL				; CHECK IF IT'S GOING TO COLLIDE
			; RETURN -> NEWX,NEWY
			
			MOVE.W	(A0),D1				; D1 = OLDY
			CMP.W	D0,D1
			BEQ		.DESTROY			; IF OLDY = NEWY THEN DESTROY IT BECAUSE IS NOT MOVING
			CMP		#SCRHEIGH,D0	    ; CHECK IF OUT OF BOUNDS
			BGT		.DESTROY
			
			MOVE.W	D0,(A0)				; SAVE NEW YPOS
			
.END		MOVEM.L	(A7)+,D0-D2/A1
			RTS

.DESTROY	MOVEM.L	(A7)+,D0-D2/A1
			JSR		AGLKILL
			RTS

.JTABLE		DC.L	.LEFT,.UP,.RIGHT,.DOWN
; -------------------------------------------------------------------------------------------
ESPELPLT
; PLOT THE SPELL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -------------------------------------------------------------------------------------------
			MOVEM.L	D0-D4,-(A7)
			
			MOVE.L	#$000000FF,D1       ; GET SPELL COLOR
			MOVE.B	#80,D0
			TRAP	#15
			MOVE.B	#81,D0
			TRAP	#15
			
			MOVE.W	(A0),D2				; GET YPOS
			MOVE.W	2(A0),D1			; GET XPOS
			
			SUB.W	#SPELLRAD/2,D1		; GET LEFTX
			SUB.W	#SPELLRAD/2,D2		; GET UPY
			
			MOVE.W	D1,D3				; D3 = D1
			MOVE.W	D2,D4				; D4 = D2
	
			ADD.W	#SPELLRAD,D1		; GET RIGHTX
			ADD.W	#SPELLRAD,D2		; GET DOWNY
			
			MOVE.B	#88,D0				; DRAW BALL
			TRAP	#15
			
			MOVEM.L	(A7)+,D0-D4
			RTS
			
; -------------------------------------------------------------------------------------------
COLMPC
; CHECKS IF IT COLIDES WITH THE MPC
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -------------------------------------------------------------------------------------------
			MOVEM.L	D0-D3,-(A7)
			MOVE.W	SPELLXPOS(A0),D2        ; SAVE THE SPELLPOSITIONS
			MOVE.W	SPELLYPOS(A0),D3        
			MOVE.W	(MPCX),D0               ; SAVE THE MPC POSITION
			MOVE.W	(MPCY),D1
			
			CMP.W	D2,D0                   ;CHECKS THAT THE SPELL IS NOT IN THE MPC'S HIT BOX
			BGT		.CONT
			ADD.W	#16,D0
			CMP.W	D2,D0
			BLT		.CONT
			CMP.W	D3,D1
			BGT		.CONT
			ADD.W	#16,D1
			CMP		D3,D1
			BLT		.CONT	
			
			MOVE.W	ESPELDMG(A0),D0         ; IF IT'S IN THE HITBOX DAMAGE MPC

			JSR		MPCADDLF
			JSR		AGLKILL                 ; ELIMINATE SPELL AFTER CAUSING DAMAGE
			
.CONT		MOVEM.L (A7)+,D0-D3
			RTS








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
