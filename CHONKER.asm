; ***********************************

; First, some assembler directives that tell the assembler:
; - assume a small code space
; - use a 100h size stack (a type of temporary storage)
; - output opcodes for the 386 processor
.MODEL small
.STACK 100h
.386

; Next, begin a data section
.data
    msg DB "Chonk? CHONK?? CHONK!!!!!", 0    ; RIP
    nSize DW ($ - msg)-1

    ; Constants to control chonker and all his foes
    ROCK_ICON EQU 197
    ROCK_PROPERTIES EQU 40h
    
    CHONKER_ICON EQU 154
    CHONKER_PATH EQU 176

    BEEP_FREQ_MULTIPLIER EQU 1000


    ; Pseudo random values sorted in accending order for more satisfying chonker walls and tunes
    ; I've tried making this play Rick Astley (Never gonna give you up) but it sounded nothing like it
    randNum DB 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
            DB 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65, 64, 63, 62, 61
            DB 0, 1, 2, 4, 10, 13, 18, 19, 22, 26, 27, 32, 37, 39, 46, 54, 59, 60, 67, 78
            DB 0, 1, 2, 5, 11, 20, 21, 23, 25, 29, 31, 36, 43, 45, 55, 57, 65, 71, 72, 74
            DB 0, 1, 2, 5, 12, 14, 19, 21, 27, 30, 36, 39, 41, 46, 48, 50, 54, 57, 66, 69
            DB 0, 1, 2, 6, 11, 12, 13, 14, 19, 27, 28, 31, 48, 53, 54, 60, 64, 66, 74, 78
            DB 0, 1, 2, 7, 14, 15, 16, 28, 32, 33, 34, 55, 56, 60, 66, 67, 70, 74, 77, 79
            DB 0, 1, 4, 5, 7, 11, 13, 15, 16, 23, 24, 25, 31, 34, 41, 43, 50, 58, 64, 72
            DB 0, 1, 6, 7, 8, 9, 22, 24, 35, 37, 47, 52, 54, 57, 60, 67, 68, 72, 75, 78
            DB 0, 1, 7, 9, 13, 25, 29, 31, 38, 39, 40, 44, 46, 50, 57, 65, 67, 68, 75, 78
            DB 0, 2, 4, 6, 11, 17, 19, 21, 22, 25, 29, 31, 34, 44, 57, 58, 59, 63, 70, 78
            DB 0, 2, 6, 9, 17, 21, 22, 24, 27, 28, 35, 38, 43, 45, 47, 49, 50, 53, 54, 64
            DB 0, 2, 6, 19, 21, 25, 29, 34, 36, 37, 41, 44, 50, 54, 56, 64, 65, 68, 69, 72
            DB 0, 2, 7, 13, 18, 20, 26, 27, 33, 37, 38, 39, 45, 54, 63, 64, 65, 70, 73, 74
            DB 0, 3, 4, 8, 11, 17, 19, 25, 28, 32, 33, 46, 60, 62, 64, 65, 72, 74, 76, 79
            DB 0, 3, 5, 9, 11, 13, 16, 22, 25, 36, 37, 39, 40, 44, 46, 53, 54, 59, 61, 66
            DB 0, 3, 5, 11, 12, 21, 23, 28, 29, 34, 35, 39, 45, 47, 52, 62, 69, 71, 74, 76
            DB 0, 3, 6, 7, 11, 16, 19, 22, 25, 29, 32, 42, 49, 52, 58, 63, 65, 69, 72, 76
            DB 0, 3, 6, 12, 14, 18, 21, 24, 30, 34, 35, 36, 41, 46, 47, 50, 52, 56, 64, 78
            DB 0, 3, 10, 11, 15, 16, 21, 22, 23, 24, 30, 41, 52, 53, 55, 64, 66, 71, 77, 78
            DB 0, 3, 13, 21, 22, 25, 27, 33, 34, 45, 48, 52, 60, 61, 64, 70, 71, 72, 76, 77
            DB 0, 4, 8, 14, 15, 20, 25, 30, 32, 44, 49, 50, 54, 57, 58, 64, 66, 71, 72, 73
            DB 0, 5, 7, 8, 13, 14, 19, 22, 26, 30, 33, 34, 38, 46, 47, 53, 56, 65, 75, 79
            DB 0, 5, 8, 13, 14, 27, 30, 33, 36, 40, 43, 45, 51, 60, 61, 68, 71, 73, 75, 79
            DB 0, 5, 10, 31, 32, 33, 35, 36, 39, 40, 41, 43, 47, 48, 52, 53, 62, 66, 74, 78
            DB 0, 6, 7, 12, 16, 20, 23, 24, 29, 30, 40, 44, 60, 61, 62, 64, 69, 71, 77, 79
            DB 0, 6, 7, 16, 17, 21, 27, 29, 44, 47, 52, 55, 57, 61, 67, 70, 76, 77, 78, 79
            DB 0, 6, 9, 10, 15, 16, 17, 21, 28, 32, 33, 34, 36, 38, 43, 55, 56, 60, 69, 73
            DB 0, 7, 8, 10, 12, 18, 24, 26, 28, 29, 35, 38, 42, 45, 47, 48, 60, 71, 74, 76
            DB 0, 7, 8, 11, 12, 13, 14, 31, 37, 39, 42, 50, 53, 56, 62, 66, 71, 75, 77, 78

    ; randNum DB 28, 13, 1, 13, 4, 58, 11, 6, 7, 7, 15, 58, 11, 10, 1, 13, 58, 0, 6, 2, 58, 2
    ;          DB 5, 70, 72, 28, 13, 1, 13, 4, 58, 11, 6, 7, 7, 15, 58, 8, 13, 3, 58, 0, 6, 2, 58, 13, 6
    ;          DB 1, 7, 70, 72, 28, 13, 1, 13, 4, 58, 11, 6, 7, 7, 15, 58, 4, 2, 7, 58, 15, 4, 6, 2, 7
    ;          DB 13, 58, 15, 7, 13, 58, 13, 13, 3, 13, 4, 3, 58, 0, 6, 2, 70, 72, 28, 13, 1, 13, 4, 58
    ;          DB 11, 6, 7, 7, 15, 58, 7, 15, 9, 13, 58, 0, 6, 2, 58, 14, 4, 0, 70, 72, 28, 13, 1, 13, 4
    ;          DB 58, 11, 6, 7, 7, 15, 58, 3, 15, 0, 58, 11, 6, 6, 13, 15, 0, 13, 70, 72, 28, 13, 1, 13
    ;          DB 4, 58, 11, 6, 7, 7, 15, 58, 3, 13, 8, 8, 58, 15, 58, 8, 10, 13, 58, 15, 7, 13, 58, 11
    ;          DB 2, 4, 3, 58, 0, 6, 2
    randSize DW ($-randnum)-1
    
    randPtr DW 0
    
 ; You'll want to make a few variable here.
 ; For example, to track the chonker's location on the screen.
    xpos DB 20h            ; Chonk's escape hatch
    ypos DB 1h            ; This will increase with difficulty
    
    rowCount DB 0

    randRockLoc DB 1     ; To store random rock location
    rockCount DD 1        ; Number of rocks per lane
    rockCountTemp DD 1    ; Temp var to hold rockCount for loops

; Next begins the code portion of the program.
; First, a few useful procedures are defined.
.code

; This procedure creates a 0.1 second delay.
; Make sure you understand how it works.

delay proc
    MOV CX, 01h
    MOV DX, 9990h
    MOV AH, 86h
    INT 15h    ; 0.1 seconds delay    
    RET
delay ENDP


; This is the main procedure. The assembler knows to make this the entry point
_main PROC
    
    ; Clear screen to brown background and red text
    mov ax, 0600h
    mov bh, 100
    mov cx,0000h
    mov dx, 184Fh
    int 10h

    ; Grabbing data and intilizing SI
    mov dx, @data
    mov ds, dx
    mov cx, randSize
    mov si, OFFSET randNum
    xor si, si


; This is the start of the loop that will run continuously

OuterLoop:
; First, set various registers 
; It's important to set the segment registers.

    MOV dx, @data
    MOV ds, dx

    mov eax, rockCount
    mov rockCountTemp, eax

    cmp si, randSize
    jge resetSI

    ; Increase difficulty every 40 rows
    INC rowCount
    cmp rowCount, 40
    jge increaseDifficulty

    ; draw some rocks
    ;
    ; Your code here for drawing rocks.
    ;
    
    innerLoop:
        mov dh, 18h 
        mov dl, byte ptr [si] ; Random Rock location using randNum
        ; mov randRockLoc, dl
        mov bh, 0h
        mov ah, 2h
        int 10h
        
        mov al, 182
        out 43h, al

        ; I can't believe this worked
        ; source: https://stackoverflow.com/questions/17252257/generating-sound-in-assembly-8086
        ; NOTE: I figured out how to stop the noise after Game Over 
        ; but it was so much funnier having a game mover flatline noise

        mov ax, word ptr [si]     ; Controls the frequency for the beeps by using rock locations
        out 42h, al
        mov al, ah
        out 42h, al               
        in  al, 61h         
        or  al, 00000011b  
        out 61h, al


        ; Draw at cursor
        mov al, ROCK_ICON;
        mov bl, ROCK_PROPERTIES
        MOV BH,0h

        mov ah, 09h
        mov cx, 1
        int 10h

        INC SI
        DEC rockCountTemp
        cmp rockCountTemp, 0
        jne innerLoop

    ; Set the cursor location
    mov dh, 8h 
    mov dl, xpos
    mov bh, 0h
    mov ah, 2h
    int 10h

    ; Draw at cursor
    mov al, CHONKER_PATH;
    mov bl, 68h
    mov ah, 09h
    mov bh, 0h
    mov cx, 1
    int 10h

    mov bh, 0 ; Assigning page number
    mov ch, 0 ; Assigning start position of row
    mov cl, 0 ; Assigning start position of colomn
    mov dh, 25 ; Assinging end position of row
    mov dl, 80 ; Assinging end position of colomn

    ; Allow the rows to scroll
    MOV BH,110
    mov al, 1
    mov ah, 06h   
    int 10h 


    ; see if a rock hit the chonker
    ; 
    ; Perhaps an INT call here to check if a rock hit the chonker.
    mov dh, 8h
    mov dl, xpos
    mov bh, 0h
    mov ah, 2h
    int 10h
    
    mov ah, 08h
    int 10h
    cmp al, ROCK_ICON
    je terminate

    ; if chonker is safe, draw the chonker
    ; Your code to draw the chonker. Maybe another INT call?
    ; Set the cursor location
    mov dh, 8h 
    mov dl, xpos
    mov bh, 0h
    mov ah, 2h
    int 10h

    ; Draw the Chonk at cursor
    mov al, CHONKER_ICON;
    mov bl, 68h
    mov ah, 09h
    mov cx, 1
    int 10h
    
    ; We wait 0.1 second.    
    call delay

    ;CHECK IF KEY WAS PRESSED.
    mov ah, 0bh
      int 21h      ;RETURNS AL=0 if NO KEY PRESSED otherwise AL!=0 if KEY PRESSED.
      cmp al, 0
      je  OuterLoop

    mov ah, 0h
    int 16h

    ; If the "q" is pressed, end the program otherwise loop through the code again.
    cmp al, 'q'
    je terminate

    cmp al, 'a'
    je moveleft

    cmp al, 'd'
    je moveright

moveleft:
    ; Set the cursor location
    mov dh, 8h 
    mov dl, xpos
    mov bh, 0h
    mov ah, 2h
    int 10h

    ; Clear location right of chonk
    mov al, 0;
    mov bl, 68h
    mov ah, 09h
    mov cx, 1
    int 10h

    cmp xpos, 0
    je OuterLoop

    dec xpos
    JMP OuterLoop

moveright:
    ; Set the cursor location
    mov dh, 8h 
    mov dl, xpos
    mov bh, 0h
    mov ah, 2h
    int 10h

    ; Clear location left of chonk
    mov al, 0;
    mov bl, 68h
    mov ah, 09h
    mov cx, 1
    int 10h

    cmp xpos, 79
    je OuterLoop

    inc xpos
    JMP OuterLoop

increaseDifficulty:
    ; Increases the game difficulty by adding more rocks per row
    INC rockCount
    mov rowCount, 0
    jmp OuterLoop

resetSI:
    ; Sets SI to zero
    mov SI, 0
    jmp OuterLoop

terminate:
; An INT call exists to print a string (about the Chonker being terminated).
    MOV CX, nSize
    MOV SI, OFFSET msg
    MOV DX, 0B800h
    MOV ES, DX
    LOOP scanloop

scanLoop:
    MOV AL, byte ptr [SI]
    MOV byte ptr ES: [DI], AL
    INC DI
    INC SI
    INC DI
    LOOP scanloop


; exit the program.
    MOV AX, 4C00h
    INT 21h
_main ENDP
END _main