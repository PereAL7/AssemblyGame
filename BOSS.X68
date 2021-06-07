; ===========================================================================================
; TITLE    : BOSS MANAGEMENT
; AUTHOR   : PERE ALZAMROA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================

; -----------------------------------------------------------------------------
BOSSINIT
; INITIALIZES THE BOSS AGENT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVE.W	#BOSPOSXI,BOSSPOSX(A0)		; SET BOSS SPAWN X COORD
			MOVE.W	#BOSPOSYI,BOSSPOSY(A0)		; SET BOSS SPAWN Y COORD
			MOVE.W	#BOSSHPI,BOSSHP(A0)			; SET BOSS INITIAL HP
			MOVE.W	#LEFT,BOSSDIR(A0)			; SET BOSS INITIAL DIR
			MOVE.W	#FASE1,BOSSFASE(A0)			; SET BOSS INITIAL FASE
			CLR.W	BOSSDMGT(A0)				; SET BOSS INITIAL DMGTIMER
			CLR.W	BOSSPELT(A0)				; SET BOSS INITIAL SPELLTIMER
			MOVE.W	#DICNTMAX,BOSDIRTM(A0)
			JSR		BOSSIMG
			RTS
; -----------------------------------------------------------------------------
BOSSUPD
; UPDATES THE BOSS AGENT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	D0/A1,-(A7)
			
			CMP.B	#8,(MPCMAP)
			BNE		.KILL					; CHECK IF MPCMAP == 8
			JSR		CHGPHASE				; CHECK PHASE
			MOVE.B	BOSSFASE(A0),D0			; GET PHASE
			LSL.L	#2,D0
			LEA		.PHASES,A1
			MOVE.L	(A1,D0),A1				; GET ACTUAL PHASE
			
			JMP		(A1)					; JUMP TO ACTUAL PHASE

; --- BOSS MOVES LEFT TO RIGHT -------------------------------------------------	
.PHASE1		MOVE.W	#-BOSDMGF1,BOSSDMG(A0)	; SET DAMAGE
			MOVE.B	#BOSPEDF1,BOSSPEED(A0)	; SET SPEED
			BRA		.END

; --- BOSS MOVES LEFT-UP-RIGHT-DOWN OR STOPS RANDOMLY --------------------------
.PHASE2		MOVE.W	#-BOSDMGF2,BOSSDMG(A0)	; SET DAMAGE
			MOVE.B	#BOSPEDF2,BOSSPEED(A0)	; SET SPEED

			CMP.W	#DICNTMAX,BOSDIRTM(A0)	; CHECK IF BOSS DIRECTION TIMER == DIRECTION MAX COUNTER
			BLT		.P2END
			CLR.W	BOSDIRTM(A0)			; RESET BOSS DIRECTION TIMER
			JSR		RNDGET					; GET RANDOM NUMBER
			CMP.W	#51,D0
			BLE		.BOSSLEFT				; 20% LEFT
			CMP.W	#102,D0
			BLE		.BOSSUP					; 20% UP
			CMP.W	#153,D0
			BLE		.BOSRIGHT				; 20% RIGHT
			CMP.W	#204,D0
			BLE		.BOSSDOWN				; 20% DOWN
			
			BRA		.BOSSTOP				; 20% STOP
			
.P2END		ADDQ.W	#1,BOSDIRTM(A0)			; INCREASE BOSS DIRECTION TIMER
			BRA		.END			

; --- BOSS STOPS AND STARTS SHOTING A LOT OF BULLETS ---------------------------
.PHASE3		MOVE.W	#-BOSDMGF3,BOSSDMG(A0)	; SET DAMAGE
			MOVE.B	#BOSPEDF3,BOSSPEED(A0)	; SET SPEED
			BRA		.BOSSTOP				; SET MOTION
			
.END		JSR BOSSCOL						; CHECK COLISIONS
			JSR	BOSSPELL					; SHOOT SPELL
			
			MOVEM.L	(A7)+,D0/A1				; RESTORE REGISTERS
			RTS
			
.BOSSLEFT	MOVE.B	#LEFT,BOSSDIR(A0)		; SET MOTION TO LEFT
			BRA		.END
.BOSSUP		MOVE.B	#UP,BOSSDIR(A0)			; SET MOTION TO UP
			BRA		.END
.BOSRIGHT	MOVE.B	#RIGHT,BOSSDIR(A0)		; SET MOTION TO RIGHT
			BRA		.END
.BOSSDOWN	MOVE.B	#DOWN,BOSSDIR(A0)		; SET MOTION TO DOWN
			BRA		.END
.BOSSTOP	MOVE.B	#STOP,BOSSDIR(A0)		; SET MOTION TO STOP
			BRA		.END		
.KILL		JSR AGLKILL						; DESTROY AGENT
			BRA		.END	
.PHASES		DC.L	.PHASE1,.PHASE2,.PHASE3
	
; -----------------------------------------------------------------------------
BOSSPLOT
; PLOTS THE BOSS AGENT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	D0-D6/A0-A7,-(A7)
			
			MOVE.W	BOSSPOSX(A0),D3			; GET BOSS X COORD
			MOVE.W	BOSSPOSY(A0),D4			; GET BOSS Y COORD
			ADD.W	#16,D4					; GET BOSS BOTTOM Y COORD
			
			LEA		.PLOTVECT,A1
			CLR.L	D0
			MOVE.B	BOSSDIR(A0),D0
			LSL.L	#2,D0
			MOVE.L	(A1,D0),A1
			
			JMP 	(A1)					; JUMP TO DIRECTIONAL PLOT
			
.PLTLEFT	MOVE.L	BOSSIMGS(A0),A1
			JSR		DRAWIMG					; DRAW IMG LOOKING LEFT
			BRA		.END
.PLTUP		MOVE.L	BOSSIMGU(A0),A1
			JSR		DRAWIMG					; DRAW IMG LOOKING UP
			BRA		.END
.PLTRIGHT	MOVE.L	BOSSIMGS(A0),A1
			JSR		SWAPDRW					; DRAW IMG LOOKING RIGHT
			BRA		.END
.PLTDOWN	MOVE.L	BOSSIMGD(A0),A1
			JSR		DRAWIMG					; DRAW IMG LOOKING DOWN
.END		MOVEM.L	(A7)+,D0-D6/A0-A7
			RTS

.PLOTVECT	DC.L	.PLTLEFT,.PLTUP,.PLTRIGHT,.PLTDOWN,.PLTDOWN

; -----------------------------------------------------------------------------
CHGPHASE
; CHANGES THE BOSS PHASE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	A1,-(A7)				; STACK REGISTERS
			
			CMP.W	#0,BOSSHP(A0)
			BLE		.DEATH					; IF BOSSHP <= 0 THEN BRANCH
			
			CMP		#BOSSHPI/3,BOSSHP(A0)
			BLT		.PHASE3					; IF BOSSHP<BOSSHPI/3 BRANCH
			
			CMP		#(BOSSHPI/3)*2,BOSSHP(A0)
			BLT		.PHASE2					; IF BOSSHP<2*BOSSHPI/3 BRANCH
			
.PHASE1		MOVE.B	#FASE1,BOSSFASE(A0)		; SET BOSS PHASE TO PHASE 1
			LEA		BOSSF1U,A1
			MOVE.L	A1,BOSSIMGU(A0)
			LEA		BOSSF1D,A1
			MOVE.L	A1,BOSSIMGD(A0)
			LEA		BOSSF1LR,A1
			MOVE.L	A1,BOSSIMGS(A0)			; LOAD BOSS PHASE 1 GRAPHICS
			BRA 	.END
			
.PHASE2		MOVE.B	#FASE2,BOSSFASE(A0)		; SET BOSS PHASE TO PHASE 2
			LEA		BOSSF2U,A1
			MOVE.L	A1,BOSSIMGU(A0)
			LEA		BOSSF2D,A1
			MOVE.L	A1,BOSSIMGD(A0)
			LEA		BOSSF2LR,A1
			MOVE.L	A1,BOSSIMGS(A0)			; LOAD BOSS PHASE 2 GRAPHICS
			BRA		.END
			
.PHASE3		MOVE.B	#FASE3,BOSSFASE(A0)		; SET BOSS PHASE TO 3
			LEA		BOSSF3U,A1
			MOVE.L	A1,BOSSIMGU(A0)
			LEA		BOSSF3D,A1
			MOVE.L	A1,BOSSIMGD(A0)
			LEA		BOSSF3LR,A1
			MOVE.L	A1,BOSSIMGS(A0)			; LOAD BOSS PHASE 3 GRAPHICS

.END		MOVEM.L (A7)+,A1				; RESTORE REGISTERS
			RTS
			
.DEATH		JSR		AGLKILL					; KILL AGENT
			MOVE.W	#STAGWIN,(STANEXT)
			MOVEM.L	(A7)+,A1				; RESTORE REGISTERS
			RTS
			
; -----------------------------------------------------------------------------
BOSSCOL
; CHECKS BOSS-PLAYER AND ENVIRONMENT COLLISION AND SUBSTRACTS LIFE IF NECESSARY
; INPUT    - A0 POINTER TO THE AGENT DATA BLOCK
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - THIS SUBROUTINE CHECKS AND MODIFIES PLAYER DATA.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A6,-(A7)
            
			CLR.L   D0
            CLR.L   D1
            CLR.L	D2
            
            MOVE.W	BOSSDMGT(A0),D0
			BNE		.NODMG
            
            MOVE.W  BOSSPOSX(A0),D0			; D1=NPCX
            MOVE.W	BOSSPOSY(A0),D1			; D3=NPCY
            ADDQ.W	#8,D0
            ADDQ.W	#8,D1
            
            JSR		GETDISVM				; GET DISTANCE NPC-MPC
            
            CMP		#16,D2
            BGE		.SEGUIR
           	
			MOVE.W	#BOSDMGTI,BOSSDMGT(A0)
           	MOVE.W  BOSSDMG(A0),D0          ; SUBTRACT MPC HP 
            JSR     MPCADDLF
.NODMG     	SUBQ.W	#1,BOSSDMGT(A0)

.SEGUIR     CLR     D0
            MOVE.W  BOSSPOSY(A0),D0       	; GET NPCY
            SWAP    D0
            MOVE.W  BOSSPOSX(A0),D0         ; GET NPCX
            CLR     D3
            LEA     .DIR,A1
            MOVE.B  BOSSDIR(A0),D3
            LSL.L	#2,D3
            MOVE.L  (A1,D3),A1
            JMP     (A1)
.LEFT       MOVE.L  D0,D1                   ; D1=D0=UY,LX
            SWAP    D1                      ; D1=LX,UY
            ADD.W   #BOSHEIGH-1,D1          ; D1=LX,DY
            SWAP    D1                      ; D1=DY,LX
            CLR.L   D2              
            SWAP    D2                          
            MOVE.B  BOSSPEED(A0),D2         ; D2=YSP,XSP
            NOT.W	D2
            ADDQ.W	#1,D2
            JSR     CHECKCOL                 ; D0=NLX,NUY
            SWAP    D0
            MOVE.W  BOSSPOSX(A0),D1          ; GET NPCX
            CMP.W   D1,D0                    ; IF NLX=LX
            BEQ     .ADD2                    ; MOVE RIGHT
            
            MOVE.W  D0,BOSSPOSX(A0)          ; SAVE NEW POSLX
            BRA .END
.ADD2       ADDQ.B  #2,BOSSDIR(A0)           ; MOVE TO THE OPPOSITE DIRECTION
            BRA     .END       
.SUB2       SUBQ.B  #2,BOSSDIR(A0)           ; MOVE TO THE OPPOSITE DIRECTION
            BRA     .END 
.UP         MOVE.L  D0,D1                    ; SAME AS .LEFT BUT USING THE UPPER CORNERS
            ADD.W   #BOSHEIGH-1,D1
            CLR.L   D2
            MOVE.B  BOSSPEED(A0),D2  
			NOT.W	D2
			ADDQ.W	#1,D2           
            SWAP    D2
            JSR     CHECKCOL
            MOVE.W  BOSSPOSY(A0),D1
            CMP.W   D1,D0
            BEQ     .ADD2     
            MOVE.W  D0,BOSSPOSY(A0)
            BRA .END


.RIGHT      ADD.W   #BOSWIDTH-1,D0			; SAME AS .LEFT BUT USING THE RIGHTMOST CORENRS
            MOVE.L  D0,D1
            SWAP    D1
            ADD.W   #BOSHEIGH-1,D1
            SWAP    D1
            CLR.L   D2
            MOVE.B  BOSSPEED(A0),D2
            JSR     CHECKCOL
            SWAP    D0
            SUB.W	#BOSWIDTH-1,D0
            MOVE.W  BOSSPOSX(A0),D1            
            CMP.W   D1,D0
            BEQ     .SUB2     
            MOVE.W  D0,BOSSPOSX(A0)
            BRA .END      

.DOWN       SWAP    D0						; SAME AS .LEFT BUS USING THE BOTTOM CORNERS
            ADD.W   #BOSHEIGH-1,D0
            SWAP    D0
            MOVE.L  D0,D1
            ADD.W   #BOSWIDTH-1,D1
            CLR.L   D2
            MOVE.B  BOSSPEED(A0),D2
            SWAP    D2
            JSR     CHECKCOL
            SUB.W	#BOSHEIGH-1,D0
            
            MOVE.W  BOSSPOSY(A0),D1
            CMP.W   D1,D0
            BEQ     .SUB2     
            MOVE.W  D0,BOSSPOSY(A0)
            BRA .END     
            
.END        MOVEM.L (A7)+,D0-D7/A0-A6		; RESTORE REGISTERS
            RTS
            
.DIR		DC.L	.LEFT,.UP,.RIGHT,.DOWN,.END

; -----------------------------------------------------------------------------
BOSSPELL
; BOSS SHOOTS RANDOMLY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	D0/A1-A3,-(A7)
			
			MOVE.W	BOSSPELT(A0),D0
			BNE		.END						; IF BOSS SPELL TIMER != 0 THEN BRANCH
			MOVE.W	#BOSSPLTI,BOSSPELT(A0)		; SET BOSS SPELL TIMER
			MOVE.W	BOSSPOSY(A0),D1				; GET BOSS Y COORD
			ADD.W	#8,D1						; ADD 8 TO Y COORD
			SWAP	D1
			MOVE.W	BOSSPOSX(A0),D1				; D1=BOSSY,BOSSX
			ADD.W	#8,D1						; ADD 8 TO X COORD
			MOVE.W	BOSSDMG(A0),D3				; SET BOSSDMG
									
			JSR		RNDGET						; GET RANDOM NUMBER
			CMP		#63,D0
			BLE		.SPELLEFT					; 25% LEFT
			CMP		#63*2,D0
			BLE		.SPELUP						; 25% UP
			CMP		#63*3,D0
			BLE		.SPELRIGH					; 25% RIGHT
			BRA		.SPELDOWN					; 25% DOWN

.SPELLEFT	MOVE.W	#LEFT,D2					; SET SPELLDIR TO LEFT
			BRA		.CNT
			
.SPELUP		MOVE.W	#UP,D2						; SET SPELLDIR TO UP
			BRA		.CNT
			
.SPELRIGH	MOVE.W	#RIGHT,D2					; SET SPELLDIR TO RIGHT
			BRA		.CNT

.SPELDOWN	MOVE.W	#DOWN,D2					; SET SPELLDIR TO DOWN
			BRA		.CNT

.CNT		MOVE.L	#SPELLID,D0
			LEA		ESPELINI,A1
			LEA		ESPELUPD,A2
			LEA		ESPELPLT,A3
			JSR		AGLADD						; SHOOT SPELL
			
.END		SUBQ.W	#1,BOSSPELT(A0)
			MOVEM.L	(A7)+,D0/A1-A3
			RTS

;------------------------------------------------------------------------------			
BOSSIMG
; INITIALIZES THE BOSS VISUALS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			MOVEM.L	A1-A2,-(A7)				; STACK REGISTERS
			
			LEA		.BOSSF1U,A1
			LEA		BOSSF1U,A2
			JSR		LOADIMG
			
			LEA		.BOSSF1D,A1
			LEA		BOSSF1D,A2
			JSR		LOADIMG
			
			LEA		.BOSSF1LR,A1
			LEA		BOSSF1LR,A2
			JSR		LOADIMG
			
			LEA		.BOSSF2U,A1
			LEA		BOSSF2U,A2
			JSR		LOADIMG
			
			LEA		.BOSSF2D,A1
			LEA		BOSSF2D,A2
			JSR		LOADIMG
			
			LEA		.BOSSF2LR,A1
			LEA		BOSSF2LR,A2
			JSR		LOADIMG
			
			LEA		.BOSSF3U,A1
			LEA		BOSSF3U,A2
			JSR		LOADIMG
			
			LEA		.BOSSF3D,A1
			LEA		BOSSF3D,A2
			JSR		LOADIMG
			
			LEA		.BOSSF3LR,A1
			LEA		BOSSF3LR,A2
			JSR		LOADIMG
			
			MOVEM.L	(A7)+,A1-A2				; RESTORE REGISTERS
			RTS
			
.BOSSF1U	DC.B	'BossF1U.bmp',0
.BOSSF1D	DC.B	'BossF1D.bmp',0
.BOSSF1LR	DC.B	'BossF1LR.bmp',0
.BOSSF2U	DC.B	'BossF2U.bmp',0
.BOSSF2D	DC.B	'BossF2D.bmp',0
.BOSSF2LR	DC.B	'BossF2LR.bmp',0
.BOSSF3U	DC.B	'BossF3U.bmp',0
.BOSSF3D	DC.B	'BossF3D.bmp',0
.BOSSF3LR	DC.B	'BossF3LR.bmp',0







*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
