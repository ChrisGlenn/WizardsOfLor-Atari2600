    processor 6502

; *******************************************************************
; THE WIZARDS OF LOR (ATARI 2600 PORT)
; By CHRUS
; *******************************************************************
; *******************************************************************
;   TODO:
;   [] Create Playfield with Tower and Bushes at Bottom
; *******************************************************************
; *******************************************************************
;   include required files with VCS register mapping
; *******************************************************************

    INCLUDE "vcs.h"
    INCLUDE "macro.h"

    SEG code
    ORG $F000                   ; set program orgin to $F000

Reset:
    CLEAN_START                 ; macro to clear memory

    LDA #$9C                    ; load the hex code for BLACK
    STA COLUBK                  ; set the background to black
; *******************************************************************
; START A NEW FRAME
; *******************************************************************
; Turn on the VSYNC/VBLANK (30)
StartFrame:
    lda #02
    sta VBLANK                  ; turn on VBLANK
    sta VSYNC                   ; turn on VSYNC

    STA WSYNC                   ; generate the 3 lines for VSYNC
    STA WSYNC                   ; generate the 3 lines for VSYNC
    STA WSYNC                   ; generate the 3 lines for VSYNC

    lda #0                      ; turn VSYNC off
    sta VSYNC

; GENERATE 37 LINES OF VBLANK
    LDX #37
RepeatVblank:
    STA WSYNC
    DEX
    BNE RepeatVblank

    lda #0                      ; turn VBLANK off
    sta VBLANK

; *******************************************************************
; DRAW THE VISIBLE SCANLINES (192)
; *******************************************************************
    LDX #192
DrawScreen:
    STA WSYNC
    DEX
    BNE DrawScreen
    
; OUTPUT 30 LINES OF OVERSCAN
    lda #2
    sta VBLANK                  ; turn VBLANK on

    LDX #30
LoopOverscan:
    STA WSYNC
    DEX
    BNE LoopOverscan

    lda #0                      ; turn VBLANK off
    sta VBLANK

; LOOP TO NEXT FRAME
    jmp StartFrame

; COMPLETE ROM SIZE TO 4KB
    org $FFFC
    .word Reset
    .word Reset