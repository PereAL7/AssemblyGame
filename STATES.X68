; =============================================================================
; TITLE    : GAME STATE MANAGEMENT
; AUTHOR   : ANTONI BURGUERA
; HISTORY  : XX-XXX-201X - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #-1,(STACUR)            ; INVALID STATE, JUST TO FORCE INIT
            MOVE.W  #0,(STANEXT)            ; INITIAL STATE
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAGAMEI,STAGOVRI,STAGWINI
.UPDTBL     DC.L    STAINTRU,STAGAMEU,STAGOVRU,STAGWINU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAGAMEP,STAGOVRP,STAGWINP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS
; -----------------------------------------------------------------------------
STAINTRI    EQU     STAEMPTY
; GAME INTRO INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; GAME INTRO UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)          ; STACK REGISTERS
            JSR     MOUSEREAD               ; UPDATE MOUSE DATA
            BTST.B   #0,(MSTATE)            ; IF ITS NOT PRESS END
            BEQ     .END
            MOVE.W  (MPOSX),D0              ; GET MOUSE X
            CMP.W   #((80-14)/2)*8,D0       ; IF ITS CLICKED IN THE HIT BOX PASS TO NEXT STATE
            BLT     .END
            CMP.W   #((80+14)/2)*8,D0
            BGT     .END
            CLR     D0
            MOVE.W  (MPOSY),D0
            CMP.W   #368,D0
            BLT     .END
            CMP.W   #405,D0
            BGT     .END
            MOVE.W  #STAGAME,(STANEXT)
.END        MOVEM.L (A7)+,D0-D1
            RTS

; -----------------------------------------------------------------------------
STAINTRP
; GAME INTRO PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)          ; STACK REGISTERS
            
            MOVE.L	#$00FFFFFF,D1			; SET PEN COLOR
            MOVE.B	#80,D0
            TRAP	#15
            MOVE.L	#$00000000,D1			; SET FILL COLOR
            MOVE.B	#81,D0
            TRAP	#15
			
			MOVE.W  #((80-14)/2)<<8|10,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.W  #((80-50)/2)<<8|12,D1   ; SECOND TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.W  #((80-80)/2)<<8|16,D1   ; THIRD TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR3,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
    
            MOVE.W  #((80-10)/2)<<8|25,D1   ; LAST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
.END        MOVEM.L (A7)+,D0-D1/A1
            RTS
.STR0       DC.B    'MAGICIAN''S RED',0
.STR1       DC.B    'ELIMINATE ALL THE MONSTERS AND PROTECT OUR KINGDOM',0
.STR2       DC.B    'CLICK HERE',0
.STR3       DC.B    'USE ARROW KEYS FOR MOVEMENT AND  FIRE1 TO SHOOT IN THE LAST DIRECTION YOU WALKED',0
            DS.W    0
; -----------------------------------------------------------------------------
STAGOVRI    EQU     STAEMPTY
; GAME OVER INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)         ; IF SPACE IS PRESS NEXT STATE
            BEQ     .END                        ; IF DONT END
            MOVE.W  #STAINTRO,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME PLOT PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)          ; STACK REGISTERS
            
			MOVE.L	#$00FFFFFF,D1			; SET PEN COLOR
            MOVE.B	#80,D0
            TRAP	#15
            MOVE.L	#$00000000,D1			; SET FILL COLOR
            MOVE.B	#81,D0
            TRAP	#15

			MOVE.W  #((80-10)/2)<<8|10,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.W  #((80-32)/2)<<8|12,D1   ; SECOND TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
    
            MOVE.W  #((80-14)/2)<<8|25,D1   ; THIRD TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
.END        MOVEM.L (A7)+,D0-D1/A1
            RTS
            
.STR0       DC.B    'GAME  OVER',0
.STR1       DC.B    'YOU LOST!! THAT IS KINDA LAME...',0
.STR2       DC.B    'PUSH SPACE KEY',0
            DS.W    0

; -----------------------------------------------------------------------------
STAGAMEI
; GAMEMPLAY INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			JSR     RNDINIT
            JSR     MPCINIT
            JSR		MAPINIT
			RTS
; -----------------------------------------------------------------------------
STAGAMEU
; GAMEMPLAY UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			
            JSR     MPCUPDATE
            JSR		MAPUPDATE
            JSR		AGLUPD
            
			RTS
; -----------------------------------------------------------------------------
STAGAMEP
; GAMEPLAY PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			JSR 	MAPPLOT
            JSR		AGLPLOT
            JSR     MPCPLOT
			JSR		PLOTHUD
			RTS
			
; -----------------------------------------------------------------------------
STAGWINI	EQU		STAEMPTY
; WIN SCREEN INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
						
; -----------------------------------------------------------------------------
STAGWINU
; WIN SCREEN UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
			BTST.B  #KBDBITF1,(KBDEDGE)  ; IF SPACE IS PRESS NEXT STATE
            BEQ     .END                 ; IF DONT END
            MOVE.W  #STAINTRO,(STANEXT)
.END        RTS
			
; -----------------------------------------------------------------------------
STAGWINP
; WIN SCREEN PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A1,-(A7)          ; STACK REGISTERS

			MOVE.L	#$00FFFFFF,D1			; SET PEN COLOR
            MOVE.B	#80,D0
            TRAP	#15
            MOVE.L	#$00000000,D1			; SET FILL COLOR
            MOVE.B	#81,D0
            TRAP	#15

			MOVE.W  #((80-12)/2)<<8|10,D1   ; FIRST TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR0,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            MOVE.W  #((80-56)/2)<<8|12,D1   ; SECOND TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR1,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
            
            BTST.B  #3,(SCRCYCCT)
            BEQ     .END
    
            MOVE.W  #((80-14)/2)<<8|25,D1   ; THIRD TEXT COORDINATES
            MOVE.B  #11,D0
            TRAP    #15                     ; LOCATE TEXT CURSOR
            LEA     .STR2,A1                ; STRING POINTER
            MOVE.B  #13,D0                  ; PRINT STRING TASK
            TRAP    #15                     ; DO IT
.END        MOVEM.L (A7)+,D0-D1/A1
            RTS
            
.STR0       DC.B    '!!YOU  WON!!',0
.STR1       DC.B    'THE KINGDOM WAS SAVED THANKS TO YOUR MIGHTY MAGIC POWERS',0
.STR2       DC.B    'PUSH SPACE KEY',0
            DS.W    0
			RTS





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
