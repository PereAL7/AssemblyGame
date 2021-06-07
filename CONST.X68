; =============================================================================
; TITLE    : GAME CONSTANTS
; AUTHOR   : PERE ALZAMORA LLABATA & MATEO JAVIER RAMÓN ROMÁN
; HISTORY  :
; =============================================================================

; --- MPC RELATED CONSTANTS ---------------------------------------------------
MAXSCORE	EQU		150                     ; MAX SCORE TO ENGAGE FINAL BOSS
MPCWIDTH    EQU     16                      ; PLAYER WIDTH
MPCHEIGH    EQU     16                      ; PLAYER HEIGH
MPCSPEED    EQU     4                       ; PLAYER SPEED
MPCLIFEI    EQU     90                     	; PLAYER INITIAL HP
MPCMANAI	EQU		90						; PLAYER INITIAL MANA
MPCMANA0	EQU		6						; PLAYER MINIMUM MANA
MPCTXTCL    EQU     $00FFFFFF               ; FONT COLOR
MPCTXTX     EQU     1                       ; SCORE X COORDINATE
MPCTXTY     EQU     3                       ; SCORE Y COORDINATE
; --- MOUSE RELATED CONSTANTS -------------------------------------------------

RCLICK      EQU     1                       ; RIGHT CLICK
LCLICK      EQU     0                       ; LEFT CLICK

; --- MAP RELATED CONSTANTS ---------------------------------------------------

MAPENEMY	EQU		124                     ; NPCS IN MAP
MAPPARAM	EQU		128                     ; MAP PARAMETERS
MAPINPOS	EQU		136                     ; MAP POSITION

; --- SPELL RELATED CONSTANTS -------------------------------------------------
SPELLRAD	EQU		8                       ; SPELL RADIUS
SPELLSPD	EQU		8                       ; SPELL SPEED
SPELLCD		EQU		10                      ; SPELL COLD DOWN
SPELLDMG    EQU     6                       ; SPELL DMG
SPELLID    	EQU     1                       ; SPELL ID 
SPELLCST	EQU		30                      ; SPELL MP COST
; OFFSET TO AGENT VARIABLES
SPELLYPOS	EQU		0                       ; SPELL Y POSITION
SPELLXPOS	EQU		2                       ; SPELL X POSITION
SPELLDIR	EQU		4                       ; SPELL DIRECTION
SPELLMAP	EQU		6                       ; SPELL MAP
ESPELDMG    EQU		SPELLMAP
; --- NPC  RELATED CONSTANTS -------------------------------------------------
NPCID		EQU		2
NPCDMG      EQU     6                       ; DAMAGE PERFORMED BY ENEMY
NPCLIFE     EQU     24                      ; ENEMY INITIAL LIFE
NPCWIDTH    EQU     16                      ; AGENT WIDTH
NPCHEIGH    EQU     16                      ; AGENT HEIGHT
DICNTMAX	EQU		20                      ; MAX TIMER FOR ONE DIRECTION 
NPCDMGTI	EQU		10						; NPC DMG TIME
; OFFSET TO AGENT VARIAVLES
NPCPOXOF    EQU     0                       ; X COORD
NPCPOYOF    EQU     2                       ; Y COORD
NPCMAP      EQU     4                       ; MAP 
NPCIDMAP    EQU     6                       ; POSITION IN THE MAP'S VECTOR
NPCHP       EQU     8                       ; HP

; OFFSETS TO AGENT COMMANDS

NPCMOTOF    EQU     10                      ; DESIRED MOTION

; OFFSET TO AGENT PARAMETERS

NPCTYPOF    EQU     12                      ; TYPE
NPCFRMOF    EQU     14                      ; FRAMES FOR LEFT AND RIGHT
NPCSPEED    EQU     16                      ; X SPEED
NPCDICNT	EQU		18						; NPC DIR COUNTER
NPCDMGTM	EQU		20						; NPC DAMAGE TIMER

; --- BOSS RELATED CONSTANTS --------------------------------------------------
BOSSID		EQU		NPCID					; BOSS AGENT ID
BOSWIDTH	EQU		16
BOSPEDF1	EQU		4						; BOSS PHASE 1 SPEED
BOSPEDF2	EQU		8						; BOSS PHASE 2 SPEED
BOSPEDF3	EQU		1						; BOSS PHASE 3 SPEED
BOSDMGF1	EQU		5						; BOSS PHASE 1 DAMAGE
BOSDMGF2	EQU		10						; BOSS PHASE 2 DAMAGE
BOSDMGF3	EQU		15						; BOSS PHASE 3 DAMAGE


FASE1		EQU		0                       ; BOSS FASE 1 MODE
FASE2		EQU		1                       ; BOSS FASE 2 MODE
FASE3		EQU		2                       ; BOSS FASE 3 MODE

; INITIAL CONSTANTS
BOSPOSXI	EQU		SCRWIDTH/2				; INITIAL X COORD
BOSPOSYI	EQU		SCRHEIGH/2				; INITIAL Y COORD
BOSSHPI		EQU		50						; BOSS INITIAL HP
BOSHEIGH	EQU		16						; BOSS HEIGHT
BOSDMGTI	EQU		20						; BOSS INITIAL DMG TIMER
BOSSPLTI	EQU		5						; BOSS INITIAL SPELL TIEMR

; OFFSET TO AGENT VARIABLES
BOSSPOSX	EQU		0						; BOSS CURRENT X COORD
BOSSPOSY	EQU		2						; BOSS CURRENT Y COORD
BOSSDIR		EQU		4						; BOSS CURRENT DIRECTION
BOSSFASE	EQU		6						; BOSS CURRENT PHASE
BOSSHP		EQU		8						; BOSS CURRENT HP
BOSSDMG		EQU		10						; BOSS DMG
BOSSDMGT	EQU		12						; BOSS DMG TIMER
BOSSPEED	EQU		14						; BOSS SPEED
BOSSIMGU	EQU		16						; BOSS LOOKING UP
BOSSIMGD	EQU		20						; BOSS LOOKING DOWN
BOSSIMGS	EQU		24						; BOSS LOOKING TO THE SIDES
BOSDIRTM	EQU		28						; BOSS DIRECTION TIMER
BOSSPELT	EQU		30						; BOSS SPELL DMG TIMER
; ----MOVEMENT TYPE CONSTANTS--------------------------------------------------
LEFT        EQU     0                       ; LEFT ID
UP          EQU     1                       ; UP ID
RIGHT       EQU     2                       ; RIGHT ID
DOWN        EQU     3                       ; DOWN ID
STOP        EQU     4                       ; STOP ID

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     31                      ; TITLE X COORDINATE
INTTITY     EQU     5                       ; TITLE Y COORDINATE
INTTITC     EQU     $000000FF               ; TITLE COLOR
INTPRSX     EQU     31                      ; PRESS FIRE X COORDINATE
INTPRSY     EQU     26                      ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS FIRE COLOR

; --- STATE RELATED VARIABLES -------------------------------------------------

STAINTRO    EQU     0                       ; GAME INTRO SCREEN STATE
STAGAME     EQU     1                       ; GAME STATE
STAGOVER    EQU     2                       ; GAME OVER STATE
STAGWIN		EQU		3						; GAME WIN STATE























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
