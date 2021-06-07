; =============================================================================
; TITLE    : EXAMPLE GAME (MAIN PROGRAM)
; AUTHOR   : ANTONI BURGUERA
; HISTORY  : 10-OCT-2020 - CREATION
;            11-OCT-2020 - MINOR CHANGES
; =============================================================================

            ORG     $1000

; --- CODE INCLUDES -----------------------------------------------------------

            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONST.X68"             ; GAME CONSTANTS
            INCLUDE "UTIL.X68"              ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "STATES.X68"            ; STATE MANAGEMENT
            INCLUDE "AGENTLST.X68"			; AGENT MANAGEMENT
            
            INCLUDE	"MATH.X68"				; MATH OPERATIONS
            INCLUDE "RANDOM.X68"            ; RANDOM NUMBERS GENERATOR
            INCLUDE "MAP.X68"				; MAP MANAGEMENT
            INCLUDE "MPC.X68"               ; MAIN CHARACTER MANAGEMENT
            INCLUDE "MOUSE.X68"             ; MOUSE MANAGEMENT
            INCLUDE "COLLISIONS.X68"		; COLLISIONS MANAGEMENT
            INCLUDE "IMG.X68"				; IMAGE MANAGEMENT
            INCLUDE	"HUD.X68"				; PLAYER HUD MANAGEMENT
            INCLUDE	"SPELL.X68"				; SPELL MANAGEMENT
            INCLUDE "ESPELL.X68"			; BOSS SPELL MANAGEMENT
            INCLUDE "NPC.X68"				; NPC MANAGEMENT
            INCLUDE	"BOSS.X68"				; BOSS MANAGEMENT

; --- INITIALIZE --------------------------------------------------------------

START       JSR     SYSINIT                 ; INITIALIZE SYSTEM-RELATED STUFF
            JSR     STAINIT                 ; INITIALIZES STATES
            ; TO DO : ADD YOUR GAME INITIALIZATION HERE
            
; --- UPDATE ------------------------------------------------------------------

.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD
            JSR     STAUPD                  ; UPDATE STATES
            ; TO DO : ADD YOUR GAME UPDATE HERE
            
; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------

            ; TO DO : ADD YOUR GAME PLOT HERE
            JSR     STAPLOT                 ; PLOT STATES
  
            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP                   ; MAIN LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START

























*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
