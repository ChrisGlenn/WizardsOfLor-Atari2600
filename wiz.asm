    PROCESSOR 6502

; *******************************************************************
; THE WIZARDS OF LOR (ATARI 2600 PORT)
; By CHRUS
; *******************************************************************
; *******************************************************************
;   TODO:
;   [] Create Playfield with Tower and Bushes at Bottom
;   [] Create Player and add Movement
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


; *******************************************************************
; Start our ROM code at memory address $F000
; *******************************************************************

    SEG code
    ORG $F000                   ; set program orgin to $F000

Reset:
    CLEAN_START                 ; macro to clear memory

    LDA #$9C                    ; load the hex code for LIGHT BLUE
    STA COLUBK                  ; set the background to light blue
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
    LDX #192                    ; 192 - 20
DrawScreen:
    STA WSYNC
    DEX
    BNE DrawScreen

; DRAW THE PLAYFIELD
    
    
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

Wizard:
    .byte #%00000000        ; 
    .byte #%11111001        ; #####  #
    .byte #%01111101        ;  ##### #
    .byte #%01111111        ;  #######
    .byte #%00000001        ;        #
    .byte #%01111111        ;  #######
    .byte #%10111101        ; # #### #
    .byte #%01011001        ;  # ##  #
    .byte #%00110000        ;   ##

Barbarian:
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