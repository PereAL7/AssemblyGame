; =============================================================================
; TITLE    : GAME VARIABLES
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; HISTORY  :
; =============================================================================

; --- MCH RELATED VARIABLES ---------------------------------------------------

MPCPOS
MPCX        DS.W    1               ; MPC LEFT X COORD
MPCY        DS.W    1               ; MPC UPPER Y COORD
MPCDIR		DS.B	1				; MPC LOOKING DIRECTION
			DS.W	0
MPCIMG		DS.B	768				; MPC BMP IMAGE
			DS.W	0
MPCSPDIR	DS.W	1				; MPC SPELL DIRECTION
MPCMAP		DS.B	1				; THE MAP WHERE THE MPC IS LOCATED
MPCBOUND	DS.B	1				; THE BOUNDARY THAT HAS BEEN TRESPASSED
ATKTIMER	DS.B	1				; ATACK TIMER
			DS.W    0
MPCHP       DS.W    1               ; MPC LIFE
MPCMANA		DS.W	1				; MPC MANA
MPCSCORE    DS.W    1               ; MPC SCORE            

; ---MOUSE RELATED VARIABLES --------------------------------------------------

MSTATE      DS.B    1               ; MOUSE STATE
            DS.W    0
MPOS                                ; MOUSE POSITION YYYYXXXX
MPOSY       DS.W    1               ; MOUSE Y POSITION
MPOSX       DS.W    1               ; MOUSE X POSITION

; --- IMG RELATED VARIABLES ----------------------------------------------------

IMGX		DS.W	1               ; IMAGE X POSITION
IMGY		DS.W	1               ; IMAGE Y POSITION
OFFSET		DS.B	1               ; IMAGE OFFSET
			DS.W	0
; --- NPC RELATED VARIABLES ---------------------------------------------------

RNDINDEX    DS.B    1               ; RANDOM INDEX
            DS.W    0
            
; --- STATE MANAGEMENT VARIABLES ----------------------------------------------

STACUR      DS.W    1               ; CURRENT STATE
STANEXT     DS.W    1               ; NEXT STATE

; --- BOSS RELATED VARIABLES --------------------------------------------------

BOSSPWN		DS.B	1
BOSSF1U		DS.B	768				; BOSS PHASE 1 LOOKING UP
BOSSF1D		DS.B	768				; BOSS PHASE 1 LOOKING DOWN
BOSSF1LR	DS.B	768				; BOSS PHASE 1 LOOKING TO THE SIDE
BOSSF2U		DS.B	768				; BOSS PHASE 2 LOOKING UP
BOSSF2D		DS.B	768				; BOSS PHASE 2 LOOKING DOWN
BOSSF2LR	DS.B	768				; BOSS PHASE 2 LOOKING TO THE SIDE
BOSSF3U		DS.B	768				; BOSS PHASE 3 LOOKING UP
BOSSF3D		DS.B	768				; BOSS PHASE 3 LOOKING DOWN
BOSSF3LR	DS.B	768				; BOSS PHASE 3 LOOKING TO THE SIDE
			DS.W	0




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
