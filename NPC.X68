; ===========================================================================================
; TITLE    : NPC MANAGEMENT
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================
;--------------------------------------------------------------------------------------------
NPCINIT
; INITIALIZE NPC
; INPUT    - D1.L = Y,X
;		   - D2.W = MAP VECTOR SPAWN
;		   - D3.W = ENEMY TYPE
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
            MOVE.L  D4,-(A7)
            MOVE.W  D1,NPCPOXOF(A0)         ; WRITE INITIAL X
            SWAP    D1
            MOVE.W  D1,NPCPOYOF(A0)         ; WRITE INTEGER PART OF INITIAL Y
            MOVE.W  D2,NPCIDMAP(A0)         ; WRITE THE POSITION IN THE MAP'S VECTOR
            MOVE.W  #NPCLIFE,NPCHP(A0)      ; WRITE INITIAL LIFE
            MOVE.W  D3,NPCTYPOF(A0)         ; STORE TYPE
            MOVE.W  #LEFT,NPCMOTOF(A0)      ; TYPE ==0: MOTION LEFT
            SWAP	D3                      ; (ALL ENEMYS HAVE LEFT MOVE AS DEFECT)
            MOVE.B  D3,NPCMAP(A0)           ; GET MAP
            SWAP	D3
            MOVE.W	#DICNTMAX,NPCDICNT(A0)  ; WRITE TIMER
            MOVE.W	#8,NPCSPEED(A0)         ; WRITE SPEED
            CLR.W	NPCDMGTM(A0)            ; CLEAR DMG TIME
            MOVE.L  (A7)+,D4
            RTS

; -----------------------------------------------------------------------------
NPCUPD
; UPDATES THE ENEMY MOTION
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	D0,-(A7)
			CLR.W	D0
			MOVE.B	NPCMAP(A0),D0           ; GETS NPC'S MAP ID
			MOVE.B	(MPCMAP),D0             ; GETS MPC'S MAP ID
			CMP.B	NPCMAP(A0),D0           
			BNE		.DESPAWN                ; IF ITS NOT EQUAL DONT SPAWN
            JSR     NPCCHKHP                ; CHECK IF NPC HAS ANY HP LEFT
            
			MOVE.W	NPCTYPOF(A0),D0         ; CHECK NPC'S TYPE
			SUBQ.W	#1,D0
			BEQ		.TYPE1
			SUBQ.W	#1,D0
			BEQ		.TYPE2
			SUBQ.W	#1,D0
			BEQ		.TYPE3
			
; --- TYPE0 ENEMIES MOVE RIGHT-LEFT, CHANGING DIRECTION ON OBSTACLES ----------

.TYPE0      BRA     .END1

; --- TYPE1 ENEMIES MOVE UP-DOWN -----------------------------------------------

.TYPE1		CMP.W	#0,NPCMOTOF(A0)         ;IF MOVE IS NOT LEFT END 
			BNE		.END1
			MOVE.W	#UP,NPCMOTOF(A0)        ;IF DONT MAKE MOVE RIGHT UP
			BRA		.END1

; --- TYPE2 ENEMIES MOVE LEFT-UP-RIGHT-DOWN OR STOP RANDOMLY -------------------

.TYPE2		CMP		#DICNTMAX,NPCDICNT(A0)  ; COMPARING DAMAGE TIMERS
			BLT		.END1                   ; BRANCH IF TIMER DIDN'T END
			CLR.W	NPCDICNT(A0)            ; RESTART DMG TIMER
			JSR		RNDGET                  ; GET RANDOM NUMBER
			CMP.W	#51,D0                  ; MOVE DEPENDING THE RANDOM NUMBER
			BLE		.NPCLEFT
			CMP.W	#102,D0
			BLE		.NPCUP
			CMP.W	#153,D0
			BLE		.NPCRIGHT
			CMP.W	#204,D0
			BLE		.NPCDOWN
			BRA		.NPCSTOP
			

; --- TYPE2 ENEMIES MOVE TOWARDS THE PLAYER ------------------------------------

.TYPE3		MOVE.W	#MPCSPEED+4,NPCSPEED(A0) ; INCREASED SPEED
			MOVE.W	(MPCY),D0
			CMP		NPCPOYOF(A0),D0	
			BLT		.NPCUP					; NPCY < MPCY
			CMP		NPCPOYOF(A0),D0
			BGT		.NPCDOWN				; NPCY > MPCY
			MOVE.W	(MPCX),D1
			CMP		NPCPOXOF(A0),D1
			BGT		.NPCRIGHT				; NPCX < MPCX
			CMP		NPCPOXOF(A0),D1
			BLT		.NPCLEFT
			
.END1		JSR     NPCPLCOL                ;CHECK COL.
			ADDQ.W	#1,NPCDICNT(A0)
			MOVEM.L	(A7)+,D0
			RTS

.NPCLEFT	MOVE.W	#LEFT,NPCMOTOF(A0)		; SET MOTION TO LEFT
			BRA		.END1
			
.NPCUP		MOVE.W	#UP,NPCMOTOF(A0)		; SET MOTION TO UP
			BRA		.END1
			
.NPCRIGHT	MOVE.W	#RIGHT,NPCMOTOF(A0)		; SET MOTION TO RIGHT
			BRA		.END1
			
.NPCDOWN	MOVE.W	#DOWN,NPCMOTOF(A0)		; SET MOTION TO DOWN
			BRA		.END1
			
.NPCSTOP	MOVE.W	#STOP,NPCMOTOF(A0)		; SET MOTION TO STOP
			BRA		.END1
.DESPAWN	JSR		AGLKILL
			MOVE.L	(A7)+,D0
			RTS
; -----------------------------------------------------------------------------
NPCPLOT
; PLOTS THE AGENT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D4,-(A7)
            MOVE.L	#$0000FF00,D1           ; GET THE FILLING COLOR
            MOVE.B	#80,D0
            TRAP	#15
            
            MOVE.L	#$000000FF,D1           ; GET THE OUTSIDE COLOR
            MOVE.B	#81,D0
            TRAP	#15
            
            MOVE.W	NPCPOXOF(A0),D1         ;GET X
            MOVE.W	NPCPOYOF(A0),D2         ;GET Y
            MOVE.W	D1,D3
            MOVE.W	D2,D4
                                            ;RECTANGLE MEASURES
			ADD.W	#15,D3                  ;ADD NPCHEIGH-1
			ADD.W	#15,D4                  ;ADD NPCWIDTH-1
			
			MOVE.B 	#87,D0                  ;PLOT RECTANGLE
			TRAP	#15

            MOVEM.L (A7)+,D0-D4
            RTS

; -----------------------------------------------------------------------------
NPCPLCOL
; CHECKS ENEMY-PLAYER AND ENVIRONMENT COLLISION AND SUBSTRACTS LIFE IF NECESSARY
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - THIS SUBROUTINE CHECKS AND MODIFIES PLAYER DATA.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A1,-(A7)
            
			CLR.L   D0
            CLR.L   D1
            CLR.L	D2
            
            MOVE.W	NPCDMGTM(A0),D0
			BNE		.NODMG
            
            MOVE.W  NPCPOXOF(A0),D0			; D1=NPCX
            MOVE.W	NPCPOYOF(A0),D1			; D3=NPCY
            ADDQ.W	#8,D0
            ADDQ.W	#8,D1
            
            JSR		GETDISVM				; GET DISTANCE NPC-MPC
            
            CMP		#16,D2
            BGE		.SEGUIR
           	
			MOVE.W	#NPCDMGTI,NPCDMGTM(A0)
           	MOVE.W  #-NPCDMG,D0               ;SUBTRACT MPC HP 
            JSR     MPCADDLF
.NODMG     SUBQ.W	#1,NPCDMGTM(A0)

.SEGUIR     CLR     D0
            MOVE.W  NPCPOYOF(A0),D0            ;GET NPCY
            SWAP    D0
            MOVE.W  NPCPOXOF(A0),D0            ;GET NPCX
            CLR     D3
            LEA     .DIR,A1
            MOVE.W  NPCMOTOF(A0),D3
            LSL.L	#2,D3
            MOVE.L  (A1,D3),A1
            JMP     (A1)
.LEFT       MOVE.L  D0,D1                     ; D1=D0=UY,LX
            SWAP    D1                        ; D1=LX,UY
            ADD.W   #NPCHEIGH-1,D1            ; D1=LX,DY
            SWAP    D1                        ; D1=DY,LX
            CLR.W   D2              
            SWAP    D2                          
            MOVE.W  NPCSPEED(A0),D2           ; D2=YSP,XSP
            NOT.W	D2
            ADDQ.W	#1,D2
            JSR     CHECKCOL                  ; D0=NLX,NUY
            SWAP    D0
            MOVE.W  NPCPOXOF(A0),D1           ; GET NPCX
            CMP.W   D1,D0                     ; IF NLX=LX
            BEQ     .ADD2                     ; MOVE RIGHT
            
            MOVE.W  D0,NPCPOXOF(A0)           ; SAVE NEW POSLX
            BRA .END
.ADD2       ADDQ.W  #2,NPCMOTOF(A0)           ; MOVE TO THE OPPOSITE DIRECTION
            BRA     .END       
.SUB2       SUBQ.W  #2,NPCMOTOF(A0)           ; MOVE TO THE OPPOSITE DIRECTION
            BRA     .END 
.UP         MOVE.L  D0,D1                     ; REPEATING THE SAME BUT LOOKING LEFT-UP CORNER AND RIGHT-UP CORNER
            ADD.W   #NPCHEIGH-1,D1            
            CLR.L   D2
            MOVE.W  NPCSPEED(A0),D2  
			NOT.W	D2
			ADDQ.W	#1,D2           
            SWAP    D2
            JSR     CHECKCOL
            MOVE.W  NPCPOYOF(A0),D1            
            CMP.W   D1,D0
            BEQ     .ADD2     
            MOVE.W  D0,NPCPOYOF(A0)
            BRA .END


.RIGHT      ADD.W   #NPCWIDTH-1,D0           ; REPEATING THE SAME BUT LOOKING RIGHT-DOWN CORNER AND RIGHT-UP CORNER
            MOVE.L  D0,D1
            SWAP    D1
            ADD.W   #NPCHEIGH-1,D1
            SWAP    D1
            CLR.W   D2
            SWAP    D2
            MOVE.W  NPCSPEED(A0),D2
            JSR     CHECKCOL
            SWAP    D0
            SUB.W	#NPCWIDTH-1,D0
            MOVE.W  NPCPOXOF(A0),D1            
            CMP.W   D1,D0
            BEQ     .SUB2     
            MOVE.W  D0,NPCPOXOF(A0)
            BRA .END      

.DOWN       SWAP    D0                      ; REPEATING THE SAME BUT LOOKING RIGHT-DOWN CORNER AND LEFT-DOWN CORNER
            ADD.W   #NPCHEIGH-1,D0
            SWAP    D0
            MOVE.L  D0,D1
            ADD.W   #NPCWIDTH-1,D1
            CLR.L   D2
            MOVE.W  NPCSPEED(A0),D2
            SWAP    D2
            JSR     CHECKCOL
            SUB.W	#NPCHEIGH-1,D0
            
            MOVE.W  NPCPOYOF(A0),D1            
            CMP.W   D1,D0
            BEQ     .SUB2     
            MOVE.W  D0,NPCPOYOF(A0)
            BRA .END     
            
.END        MOVEM.L (A7)+,D0-D7/A1
            RTS
            
.DIR		DC.L	.LEFT,.UP,.RIGHT,.DOWN,.END


; -----------------------------------------------------------------------------
NPCCHKHP
; CHECKS THE NPC HP AND KILLS IT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)
			MOVE.W	NPCHP(A0),D0
            CMP.B   #0,D0                   ;IF STILL HAVE HP END ROUTINE
            BGT     .ENDNPCHP   
            
          	MOVE.B	(MPCMAP),D0     
			LSL.L	#2,D0
			LEA		MAPS,A1
			MOVE.L	(A1,D0),A1				; GET ACTUAL MAP
			
			ADD.W	#MAPENEMY,A1			; GET ENEMY VECTOR POINTER
			MOVE.L	(A1),A1
			
			MOVE.W	NPCIDMAP(A0),D0			; ENEMY MAP VECTOR ID
			LSL.L	#3,D0
			MOVE.L	(A1,D0),D1
			BTST.L	#23,D1
			BNE		.ENDKILL		
			
			AND.L	#$FEFFFFFF,D1
			MOVE.L	D1,(A1,D0)
            
.ENDKILL    JSR     AGLKILL                 ; KILL THE ENEMY
            ADD.W   #6,(MPCSCORE)
.ENDNPCHP   
            MOVEM.L (A7)+,D0
            RTS

























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
