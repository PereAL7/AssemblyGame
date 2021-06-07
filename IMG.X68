; ===========================================================================================
; TITLE    : IMG MANAGEMENT
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; COMMENTS :
; HISTORY  :
; ===========================================================================================

; -------------------------------------------------------------------------------------------
LOADIMG
; LOAD A 16X16 IMAGE
; INPUT    - A1:=FILE NAME
;		   - A2:=POINTER WHERE WE WILL STORE THE IMG
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			
			MOVEM.L	D0-D7/A0-A7,-(A7)	; STACK REGISTERS
			
			MOVE.B	#50,D0				; CLOSE ALL FILES
			TRAP	#15
			
			MOVE.B	#51,D0				; OPEN FILE
			TRAP	#15					; D1.L:=FILE ID
			
			MOVE.L	#10,D2				; READ BYTE Nº 10
			MOVE.B	#55,D0
			TRAP	#15
			
			LEA		OFFSET,A1			; A1:=OFFSET POINTER
			MOVE.L	#1,D2
			MOVE.B	#53,D0				
			TRAP	#15					; STORE WHERE THE IMG BEGGINS
			
			MOVE.B	(OFFSET),D2			; GO TO THE OFFSET OF THE FILE
			MOVE.B	#55,D0
			TRAP	#15
			
			MOVE.L	A2,A1				; A1:= POINTER WHERE WE STORE THE IMG
			MOVE.L	#$300,D2			; READ AND SAVE 300 BYTES
			MOVE.B	#53,D0
			TRAP	#15
			
			MOVE.B	#50,D0				; CLOSE ALL FILES
			TRAP	#15
			
			MOVEM.L	(A7)+,D0-D7/A0-A7	; RESTORE REGISTERS
			
			RTS
			
; -------------------------------------------------------------------------------------------
DRAWIMG
; PLOTS A 16X16 IMAGE
; INPUT    - A1:=IMG POINTER
;		   - D3.W:=POSX
;		   - D4.W:=POSY
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			MOVEM.L D0-D7/A1,-(A7) 		; STACK REGISTERS
			CLR.L	D1
			MOVE.W	D3,D5				; COPY D3 IN D5
			SUBQ.W	#1,D4
			
			MOVE.L	#15,D6				; PREPARE YLOOP

.YLOOP		MOVE.L	#15,D7				; PREPARE XLOOP
			MOVE.W	D5,D3				; COPY D5 IN D3

.XLOOP		MOVE.B	(A1)+,D1			; GET BLUE
			LSL.L	#8,D1
			MOVE.B	(A1)+,D1			; GET GREEN
			LSL.L	#8,D1
			MOVE.B	(A1)+,D1			; GET RED
			MOVE.B	#80,D0
			TRAP	#15					; SET PEN COLOR
			
			CMP		#$0000FF00,D1		; IF COLOR == GREEN THEN SKIP
			BEQ		.SKIPCLR
			
			MOVE.W	D3,D1
			MOVE.W	D4,D2
			MOVE.B	#82,D0
			TRAP	#15					; PAINT PIXEL
			
.SKIPCLR	ADDQ.W	#1,D3				; INCREASE X COORD	
			CLR.L	D1
			DBRA	D7,.XLOOP
			
			SUBQ.W	#1,D4				; DECREMENT Y COORD
			DBRA	D6,.YLOOP

			MOVEM.L	(A7)+,D0-D7/A1		; RESTORE REGISTERS
			RTS

; -------------------------------------------------------------------------------------------
SWAPDRW
; DRAW AN INVERSED 16X16 IMG
; INPUT    - A1:=IMG POINTER
;		   - D3.W:=POSX
;		   - D4.W:=POSY
; OUTPUT   - NONE
; MODIFIES - NONE
;--------------------------------------------------------------------------------------------
			MOVEM.L D0-D7/A1,-(A7)		; STACK REGISTERS
			
			CLR.L	D1
			ADD.W	#16,D3				; INCREMENT X POS
			SUBQ.W	#1,D4
			
			MOVE.W	D3,D5				; COPY D3 IN D5
		
			MOVE.L	#15,D6				; SET .YLOOP

.YLOOP		MOVE.L	#15,D7				; SET .XLOOP
			MOVE.W	D5,D3				; COPY D5 IN D3

.XLOOP		MOVE.B	(A1)+,D1			; GET BLUE
			LSL.L	#8,D1
			MOVE.B	(A1)+,D1			; GET GREEN
			LSL.L	#8,D1
			MOVE.B	(A1)+,D1			; GET RED
			MOVE.B	#80,D0
			TRAP	#15					; SET PEN COLOR
			
			CMP		#$0000FF00,D1		; IF COLOR == GREEN THEN SKIP
			BEQ		.SKIPCLR
			
			MOVE.W	D3,D1
			MOVE.W	D4,D2
			MOVE.B	#82,D0
			TRAP	#15					; PAINT PIXEL
			
.SKIPCLR	SUBQ.W	#1,D3				; DECREMENT X COORD	
			CLR.L	D1
			DBRA	D7,.XLOOP
			
			SUBQ.W	#1,D4				; DECREMENT Y COORD
			DBRA	D6,.YLOOP

			MOVEM.L	(A7)+,D0-D7/A1 		; RESTORE REGISTERS
			RTS


*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
