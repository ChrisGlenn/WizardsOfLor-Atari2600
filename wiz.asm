    PROCESSOR 6502

; *******************************************************************
; THE WIZARDS OF LOR (ATARI 2600 PORT)
; By CHRUS
; *******************************************************************
; *******************************************************************
;   TODO:
;   [] Create Playfield with Tower and Bushes at Bottom
;   [] Display Player
;   [] Add Player Movement
;   [] Add Missle Firing
;   [] Add Score
;   [] Add Enemy Movment and Collision
;   [] Lives
;   [] Tower Life
; *******************************************************************
; *******************************************************************
;   include required files with VCS register mapping
; *******************************************************************

    INCLUDE "vcs.h"
    INCLUDE "macro.h"

; *******************************************************************
; Declare variables starting from memory address $80
; *******************************************************************
    SEG.U Variables
    ORG $80

WizXPos         byte                    ; player x-position
WizYPos         byte                    ; player y-position
BarbXPos        byte                    ; barbarian x-position
BarbYPos        byte                    ; barbarian y-position
TowerHP         byte                    ; tower's hit-points
Score           byte                    ; player's score
Level           byte                    ; game level (enemies get faster the higher it goes)

; Define Constants
WIZ_HEIGHT = 9                          ; player0 (wizard) sprite height

; *******************************************************************
; Start our ROM code at memory address $F000
; *******************************************************************

    SEG code
    ORG $F000                   ; set program orgin to $F000

Reset:
    CLEAN_START                 ; macro to clear memory

    LDA #$00                    ; load the hex code for BLACK
    STA COLUBK                  ; set the background to black

    LDA #$84                    ; load the hex code for BLUE
    STA COLUP0                  ; set the player color to blue

; Initialize variables (player position, ect.)
    LDA #20
    STA WizXPos                 ; player X position
    LDA #80
    STA WizYPos                 ; player Y position

; *******************************************************************
; START A NEW FRAME
; *******************************************************************
; Turn on the VSYNC/VBLANK (30)
StartFrame:
    LDA #02
    STA VBLANK                  ; turn on VBLANK
    STA VSYNC                   ; turn on VSYNC

    STA WSYNC                   ; generate the 3 lines for VSYNC
    STA WSYNC                   ; generate the 3 lines for VSYNC
    STA WSYNC                   ; generate the 3 lines for VSYNC

    LDA #0                      ; turn VSYNC off
    STA VSYNC

; GENERATE 37 LINES OF VBLANK
    LDX #37
RepeatVblank:
    STA WSYNC
    DEX
    BNE RepeatVblank

    LDA #0                      ; turn VBLANK off
    STA VBLANK

; *******************************************************************
; DRAW THE VISIBLE SCANLINES (192)
; *******************************************************************
    LDX #192                    ; 192
GameLoop:
.CheckWizardPos:
    TXA                         ; transfer X to A
    SEC                         ; set carry flag before subtraction
    SBC WizYPos                 ; subtract with wizard y-position
    CMP WIZ_HEIGHT              ; compare wizard height
    BCC .DrawWizard             ; if result < sprite height go to draw routine
    lda #0
.DrawWizard:
    STA GRP0

    STA WSYNC
    DEX
    BNE GameLoop

; OUTPUT 30 LINES OF OVERSCAN
    LDA #2
    STA VBLANK                  ; turn VBLANK on

    LDX #30
RepeatOverscan:
    STA WSYNC
    DEX
    BNE RepeatOverscan

    LDA #0                      ; turn VBLANK off
    STA VBLANK

; LOOP TO NEXT FRAME
    JMP StartFrame

; *******************************************************************
; Declare ROM lookup tables
; *******************************************************************
Digits:
    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###

    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #

    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %00110011          ;  ##  ##
    .byte %00010001          ;   #   #
    .byte %01110111          ; ### ###

    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #

    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #
    .byte %00010001          ;   #   #

    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###
    .byte %00010001          ;   #   #
    .byte %01110111          ; ### ###

    .byte %00100010          ;  #   #
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #

    .byte %01110111          ; ### ###
    .byte %01010101          ; # # # #
    .byte %01100110          ; ##  ##
    .byte %01010101          ; # # # #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01000100          ; #   #
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###

    .byte %01100110          ; ##  ##
    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #
    .byte %01010101          ; # # # #
    .byte %01100110          ; ##  ##

    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01110111          ; ### ###

    .byte %01110111          ; ### ###
    .byte %01000100          ; #   #
    .byte %01100110          ; ##  ##
    .byte %01000100          ; #   #
    .byte %01000100          ; #   #

WizardBitmap:
    .byte #%00110000        ;   ##
    .byte #%01011001        ;  # ##  #
    .byte #%10111101        ; # #### #
    .byte #%01111111        ;  #######
    .byte #%00000001        ;        #
    .byte #%01111111        ;  #######
    .byte #%01111101        ;  ##### #
    .byte #%11111001        ; #####  #
    .byte #%00000000        ; 

BarbarianBitmap:
    .byte #%00000000        ;
    .byte #%00010010        ;    #  # 
    .byte #%00010010        ;    #  # 
    .byte #%01011111        ;  # #####
    .byte #%01011111        ;  # #####
    .byte #%01111111        ;  #######
    .byte #%11010010        ; ## #  # 
    .byte #%11011110        ; ## #### 
    .byte #%10010010        ; #  #  #

; *******************************************************************
; Complete ROM size to 4k
; *******************************************************************
    ORG $FFFC
    .word Reset
    .word Reset