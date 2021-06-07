; ===========================================================================================
; TITLE    : MPC MANAGEMENT
; AUTHOR   : PERE ALZAMROA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================


;--------------------------------------------------------------------------------------------
MPCINIT
; INITIALIZES THE MAIN CHARACTER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            MOVEM.L	A1-A2,-(A7)					; STACK REGISTERS
            
			MOVE.W 	#SCRWIDTH/2,(MPCX)			; SET INITIAL MPC X COORD
            MOVE.W 	#SCRHEIGH/2,(MPCY)			; SET INITIAL MPC Y COORD
            MOVE.W 	#MPCLIFEI,(MPCHP)			; SET INITIAL HP
            MOVE.W	#MPCMANAI,(MPCMANA)			; SET INITIAL MANA
            CLR.B	(MPCMAP)					; SET INITIAL MAP
            CLR.B	(MPCDIR)					; SET INITIAL DIRECTION
            CLR.B	(ATKTIMER)					; SET INITIAL ATKTIMER
            CLR.W   (MPCSCORE)					; SET INITIAL SCORE
          	MOVE.W	#RIGHT,(MPCSPDIR)			; SET INITIAL SPELL DIRECTION
            LEA		.MPCFILE,A1					; GET FILE NAME POINTER
            LEA		MPCIMG,A2					; GET VAR POINTER
            JSR 	LOADIMG						; LOAD FILE INTO MEMORY
            			
			MOVEM.L (A7)+,A1-A2					; RESTORE REGISTERS
            RTS

.MPCFILE	DC.B	'MAGO.BMP',0
			DS.W	0
;--------------------------------------------------------------------------------------------
MPCUPDATE
; UPDDATES THE MAIN CHARACTER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            
            MOVEM.L D0-D7/A0-A7,-(A7)			; STACK REGISTERS
            
            CMP		#MPCMANA0,(MPCMANA)
            BLE		.CORRECTD					; IF MPCMANA <= MPCMANA0 BRANCH
            CMP		#MPCMANAI,(MPCMANA)
            BGT		.CORRECTU					; IF MPCMANA > MPCMANAI BRANCH
            
            BTST.B	#4,(KBDVAL)					; CHECK IF FIRE1 HAS BEEN PRESSED
            BNE		.ATK
            
.MOVE       LEA     .JTABLE,A0					; GET .JTABLE POINTER
            MOVE.B  (KBDVAL),D0					; GET KBDVAL
            AND.L   #%1111,D0					; APPLY MASK
            ASL.W   #2,D0						; MULTIPY X2
            MOVE.L  (A0,D0),A0					; GET JUMP ADRESS
            
            JMP     (A0)						; JUMP

.CORRECTD	MOVE.W	#MPCMANA0,(MPCMANA)			; SET MPCMANA TO MINIMUM MANA
			BRA		.MOVE
.CORRECTU	MOVE.W	#MPCMANAI,(MPCMANA)			; SET MPCMANA TO MAXIMUM MANA
			BRA		.ATK
			
.ATK		MOVE.B	(ATKTIMER),D0				
			BNE		.SKIPATK					; CHECK IF ATKTIMER == 0 ELSE BRANCH
			MOVE.B	#SPELLCD,(ATKTIMER)			; SET ATKTIMER TO SPELLCD

			MOVE.W	(MPCX),D0					; GET MPCX
			MOVE.W 	(MPCY),D1					; GET MPCY
			ADD.W	#MPCWIDTH/2,D0				; GET MPC'S CENTER X COORD
			ADD.W	#MPCHEIGH/2,D1				; GET MPC'S CENTER Y COORD
			SWAP	D1
			MOVE.W	D0,D1						; SET SPELL POSITION
			MOVE.W	(MPCSPDIR),D2				; SET SPELL DIRECTION
			LEA		SPELINIT,A1					; GET SPELINIT
			LEA		SPELUPDT,A2					; GET SPELUPDT
			LEA		SPELPLOT,A3					; GET SPELPLOT
			MOVE.W  #SPELLID,D0					; GET SPELLID

			JSR		AGLADD						; SHOOT SPELL
			
            SUB.W	#SPELLCST,(MPCMANA)			; SUBTRACT SPELL COST
			
			BRA		.MOVE
			
			
.SKIPATK	SUBQ.B	#1,(ATKTIMER)				; DON'T ATTACK	
			BRA		.MOVE
			
.MOVEL      MOVE.W	#LEFT,(MPCSPDIR)			; SET SPELL DIRECTION
			MOVE.L	(MPCPOS),D0					; D0 = LEFTX,UPY
			SWAP	D0							; D0 = UPY,LEFTX
			
			MOVE.L	D0,D1						; D1 = D0
			SWAP	D1							; D1 = LEFTX,UPY
			ADD.W	#MPCHEIGH-1,D1				; D1 = LEFTX,DOWNY
			SWAP	D1							; D1 = DOWNY,LEFTX
           	
           	CLR.W	D2
           	SWAP	D2
           	MOVE.W	#-MPCSPEED,D2				; D2 = YSPEED,XSPEED
           	
            JSR 	CHECKCOL					; CHECK IF IT'S GOING TO COLLIDE
            ; RETURN -> D0 = NEWLEFTX,NEWUPY
            
            SWAP	D0							; D0 = UPY,LEFTX
            
            MOVE.W	D0,(MPCX)					; SAVE NEWXPOS
            MOVE.B	#1,(MPCDIR)					; SET MPCDIR TO 1
            
			BRA     .END

.MOVER      MOVE.W	#RIGHT,(MPCSPDIR)			; SET SPELL DIRECTION
			MOVE.L	(MPCPOS),D0					; D0 = LEFTX,UPY
			SWAP	D0							; D0 = UPY,LEFTX
			
			ADD.W	#MPCWIDTH-1,D0				; D0 = UPY,RIGHTX
			
			MOVE.L	D0,D1						; D1 = UPY,RIGHTX
			SWAP	D1							; D1 = RIGHTX,UPY
			ADD.W	#MPCHEIGH-1,D1				; D1 = RIGHTX,DOWNY
			
			SWAP	D1							; D1 = DOWNY,RIGHTX
			
			CLR.W	D2
			SWAP	D2
			MOVE.W	#MPCSPEED,D2				; D2 = YSPEED,XSPEED
			
			JSR		CHECKCOL
			; RETURN -> D0 = NEWRIGHTX,NEWUPY
			
			SWAP	D0							; D0 = UPY,RIGHTX
			SUB.W	#MPCWIDTH-1,D0				; D0 = UPY,LEFTX
			
			MOVE.W	D0,(MPCX)					; SAVE NEWPOS
			MOVE.B	#0,(MPCDIR)					; SET MPCDIR TO 0
			
            BRA     .END

.MOVEU      MOVE.W	#UP,(MPCSPDIR)				; SET SPELL DIRECTION
			MOVE.L	(MPCPOS),D0					; D0 = LEFTX,UPY
			SWAP	D0							; D0 = UPY,LEFTX
			
			
			MOVE.L	D0,D1						; D1 = UPY,LEFTX
			ADD.W	#MPCWIDTH-1,D1				; D1 = UPY,RIGHTX
			
			MOVE.W	#-MPCSPEED,D2
			SWAP	D2
			CLR.W	D2							; D2 = YSPEED,XSPEED
			
			JSR		CHECKCOL			
			; RETURN -> D0 = NEWLEFTX,NEWUPY 
			
			MOVE.W	D0,(MPCY)					; SAVE NEWPOS
			
            BRA     .END
            
.MOVED      MOVE.W	#DOWN,(MPCSPDIR)
			MOVE.L	(MPCPOS),D0					; D0 = LEFTX,UPY
			
			ADD.W	#MPCHEIGH-1,D0				; D0 = LEFTX,DOWNY
			SWAP	D0							; D0 = DOWNY,LEFTX
			
			MOVE.L	D0,D1						; D1 = DOWNY,LEFTX
			ADD.W	#MPCWIDTH-1,D1				; D1 = DOWNY,RIGHTX
			
			MOVE.W	#MPCSPEED,D2
			SWAP	D2
			CLR.W	D2							; D2 = YSPEED,XSPEED
			
			JSR		CHECKCOL
			; RETURN -> D0 = NEWLEFTX,NEWDOWNY
			
			SUB.W	#MPCHEIGH-1,D0				; D0 = LEFTX,UPY
			MOVE.W	D0,(MPCY)					; SAVE NEWPOS
			
            BRA     .END
 
.END		JSR MPCBNDRY

            MOVEM.L (A7)+,D0-D7/A0-A7
            RTS
            
.JTABLE     DC.L    .END,.MOVEL,.MOVEU,.END,.MOVER,.END,.END,.END,.MOVED,.END
            DC.L    .END,.END,.END,.END,.END,.END,.END

;--------------------------------------------------------------------------------------------
MPCPLOT
; PLOTS MAIN CHARACTER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            MOVEM.L D0-D4/A1,-(A7)				; STACK REGISTERS

            MOVE.W  (MPCX),D3                   ; GET MPCX
            MOVE.W  (MPCY),D4                   ; GET MPCY
            
            ADD.W   #MPCHEIGH,D4              	; GET MPC'S BOTTOM Y COORD
			LEA		MPCIMG,A1					; GET MPCIMG POINTER
			
			MOVE.B	(MPCDIR),D0
			BEQ .PLTRIGT						; CHECK IF MPC IS LOOKING AT THE RIGHT OR LEFT SIDE
			
			JSR		SWAPDRW						; DRAW INVERSE IMG
			MOVEM.L (A7)+,D0-D4/A1
            RTS
			
.PLTRIGT	JSR		DRAWIMG						; DRAW IMG
            
            MOVEM.L (A7)+,D0-D4/A1				; RESTORE REGISTERS
            RTS

;--------------------------------------------------------------------------------------------
MPCBNDRY
; CHECKS IF THE MPC IS INSIDE OR OUTSIDE THE MAP BOUNDS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			MOVEM.L	D0-D1,-(A7)					; STACK REGISTERS
			
			MOVE.W	(MPCX),D0					; GETX
			MOVE.W	(MPCY),D1					; GETY
			CMP		#8,D0						; IF OUTOFLEFTBOUNDARY
			BLT		.LBOUND
			CMP		#8,D1						; IF OUTOFTOPBOUNDARY
			BLT		.TBOUND
			CMP		#SCRWIDTH-17,D0				; IF OUTOFRIGHTBOUNDARY
			BGT		.RBOUND
			CMP		#SCRHEIGH-17,D1				; IF OUTOFBOTTOMBOUNDRAY
			BGT		.BBOUND
			CLR.B	(MPCBOUND)					; ELSE MPCBOUND = 0
			
.MPCBEND	MOVEM.L	(A7)+,D0-D1					; RESTORE REGISTERS
			RTS
			
.LBOUND		MOVE.B	#1,(MPCBOUND)				; MPCBOUND = 1
			BRA		.MPCBEND		
.TBOUND		MOVE.B	#2,(MPCBOUND)				; ETC
			BRA		.MPCBEND		
.RBOUND		MOVE.B	#3,(MPCBOUND)
			BRA		.MPCBEND		
.BBOUND		MOVE.B	#4,(MPCBOUND)
			BRA		.MPCBEND

; -----------------------------------------------------------------------------
MPCADDLF
; ADDS/SUBSTRACTS LIFE TO THE PLAYER
; INPUT    - D0.W   AMOUNT TO ADD/SUBSTRACT
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------			
            ADD.W   D0,(MPCHP)					; ADD D0 TO MPCHP
            
			CMP.W   #MPCLIFEI,(MPCHP)
            BGE     .TOMAX						; IF MPCHP>=MPCMAX BRANCH
            CMP		#0,(MPCHP)
            BLE		.TOMIN						; IF MCHP<=MPCMIN BRANCH
            
            RTS
            	
.TOMAX      MOVE.W  #MPCLIFEI,(MPCHP)			; SET MPCHP TO MAXHP
			RTS
			
.TOMIN      CLR.W   (MPCHP)						; SET HP TO 0
            MOVE.W  #STAGOVER,(STANEXT)     	; SET NEXT STATE
			RTS


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
