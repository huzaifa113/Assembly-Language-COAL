;Printing a snake at random position and start moving
[org 0x0100]
jmp start
if_collide: db 0
count: dd 0
foodposition: dw 1876
row: dw 0
col: dw 0
delay: dd 0 
dash: db '-'
line: db '|'
last_snake_pos: dw 0
snake_face_pos: dw 0
welcome: db 'Snake Game'
name:    db 'By Huzaifa Arshad'
roll_no:     db '21F-9323'
hurdle_position: dw 0
temp:  dw 0
score:  db '0'
endgame: db 'GAME OVER YOU LOST '
scoreprint: db 'SCORE ='
keyN: db 'KEYS : '
keyRight: db '1- Press the right arrow to move right '
keyLeft: db '2- Press the left arrow to move left '
keyDown: db '3- Press the down arrow to move down '
keyUp: db '4- Press the up arrow to move up '
keyEsc: db '5- Press esc to end game '
keystart: db 'Press any key to start the game'
selfByte: db 0
snakeShape: db 02,'*','*','*','*','*'
snakeLength: dw 6

;;;;;;;;;;;;;;;;;;;;;;;KEY MENU;;;;;;;;;;;;;;;;;;
keyMenu:
   push bp
   mov bp,sp
   push ax
   push bx
   push cx
   push si

mov ax,80
mov bx,5               ;all this work for printing KEY
mul bx
add ax,20
shl ax,1

mov di,ax
mov si,keyN
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,7
nextK:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextK

mov ax,80                ;all this for printing our key 
mov bx,8
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keyRight
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,39
nextR:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextR

mov ax,80                ;all this for printing our key 
mov bx,10
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keyLeft
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,36
nextL:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextL

mov ax,80                ;all this for printing our key 
mov bx,12
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keyDown
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,36
nextD:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextD

   mov ax,80                ;all this for printing our key 
mov bx,14
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keyUp
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,33
nextU:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextU

 mov ax,80                ;all this for printing our key 
mov bx,16
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keyEsc
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,25
nextEsc:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextEsc
   
 mov ax,80              
mov bx,18
mul bx
add ax,10
shl ax,1

mov di,ax
mov si,keystart
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,22

next4:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop next4
   
pop si
pop cx
pop bx
pop ax
pop bp
ret

;code to clear the screen
clearscreen:
    push es
    push ax
    push di
    push cx
    mov ax,0xb800                   ; video memory address
    mov es,ax
    mov ax,0x0720                   ; color code and space ASCII
    mov di,0
    nextchar:
        mov [es:di],ax
        add di,2
        cmp di,4000
        jne nextchar

    ;popping all values
    pop cx
    pop di
    pop ax
    pop es
    ret

printboundary:
 push bp
 mov bp,sp
 push ax
 push bx
 push di
 
mov ax,0xb800
mov es,ax

mov cx,156
mov ah,0x07
mov al,[dash]
mov di,2
loop1:

   mov [es:di],ax
   add di,2
   cmp di,cx
   jne loop1

mov di,3840
mov cx,3998
loop2:
   mov [es:di],ax
   add di,2
   cmp di,cx
   jne loop2

mov cx,22
mov di,160
mov al,[line]   
loop3:
 mov [es:di],ax
   add di,158
   mov [es:di],ax
   add di,2
   loop loop3


 
pop di
pop bx
pop ax
pop bp
ret
                             ;;;;;;;;;;;;;;;welcome note;;;;;;;;;;;
welcome_note:
   push bp
   mov bp,sp
   push ax
   push bx
   push cx
   push si
  
mov ax,80
mov bx,10               ;all this work for printing Snake Game 
mul bx
add ax,36
shl ax,1

mov di,ax
mov si,welcome
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,10
next:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop next
mov ax,80                ;all this for printing our names 
mov bx,14
mul bx
add ax,28
shl ax,1

mov di,ax
mov si,name
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,17
next2:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop next2
                           ;all this for printing roll numbers 
mov ax,80              
mov bx,16
mul bx
add ax,34
shl ax,1

mov di,ax
mov si,roll_no
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,8
next3:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop next3
   


pop si
pop cx
pop bx
pop ax
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;HURDLE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_random:
   push ax 
   push cx 
   push dx
  l2:
  MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 25    
   div  cx
   
   mov word[hurdle_position],dx
   
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 40    
   div  cx  
   
   mov word[temp],dx
   
   mov ax,word[hurdle_position]
   mov bx,80
   mul bx
   add ax,word[temp]
   shl ax,1
   cmp ax,2800
   jg l2
   
   mov word[hurdle_position],ax
   
   pop dx
   pop cx
   pop ax
   ret
   

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;HURDLE ;;;;;;;;;;;;;;;;;;;

print_hurdle:
push bp
mov bp,sp
push ax
push bx
push cx
push es
push di
    
   call print_random
   call print_random
   call print_random
   mov di,word[hurdle_position]
   add di,2
   mov ax,0xb800
   mov es,ax
   mov ax,0x0724
   mov [es:di],ax
pop di
pop es
pop cx
pop bx
pop ax
pop bp
ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FOOD;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

setApplePosition:
push ax
push cx
push dx
l1:
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 25    
   div  cx      

   mov word[row],dx
 

 MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 80    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9

   mov word[col],dx

  mov ax,[row]
  mov bx,80
  mul bx
 add ax,[col]
 shl ax,1
 cmp ax,4000
 jg l1

mov [foodposition],ax

pop dx
pop cx
pop ax
ret

printApple:
 push ax
push bx
push di
push es
 

mov ax,0xb800                   ; access video memory 
mov es,ax
call setApplePosition           ; call subroutine to print food 
mov di,[foodposition]
mov ah,0x47
mov al,0x03                      ; move heart to al 
mov [es:di],ax                   ; move the heart to the screen 
mov byte[if_collide],0

mov di,[hurdle_position]
mov ax,0x0720
mov [es:di],ax
pop es
pop di
pop bx
pop ax
ret

print_space:
    push bp
    mov bp, sp
    push ax
    push es
    push di
    push cx 

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 10
    space:
    mov ax,0x0720
    mov word [es:di],ax
    sub di,2
    dec cx
    jnz space
   
   mov ax,0x0720
    mov word [es:di],ax

    pop cx
    pop di
    pop es
    pop ax
    pop bp
    ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PRINT SNAKE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printsnake:
   push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx


  mov si,[bp+6] ;;;; snakeshape
    mov cx,[bp+8] ;;;; snake length
    mov di,[foodposition] ;;;;;;;;;;;;random position
	add di,2
    mov bx,0xb800
    mov es,bx

    mov bx,[bp+4] ;;;;;;location
    mov ah,0x09 ;;;; color
call printApple
    drawnext:
    mov al,[si]
    mov [es:di],ax
    mov [bx],di   ;;; changing location of snake
	inc si
    add bx,2
    add di,2
    loop drawnext
	
    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; moving snake upwards;;;;;;;;;;;;;;;;;;;;;

moveUp:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

    mov bx,[bp+4] ;; location
    mov dx,[bx]  ;;; the last location value as a temp register
    mov cx,[bp+8]
    sub dx,160    ;;;; to get to the upper row

    ;;;;;;;;check if moving upwards is even possible or not;;;;;;;;;;;

    upColision:
    cmp dx,[bx]
    je errorUP
    add bx,2
    loop upColision

   moveUP2:    ;;;; doing it all again after knowing ke its possible to move upwards
   mov si,[bp+6]  ;;; snake
   mov bx,[bp+4]  ;;; location
   mov dx,[bx]
   sub dx,160
   mov di,dx
 mov word[last_snake_pos],dx
    
   mov ax,0xb800
   mov es,ax
   mov ah,0x09
   mov al,[si]
   mov [es:di],ax   ;;;;;; snake head 
   mov cx,[bp+8]  ;length
   mov di,[bx] ;; location
   inc si
   mov ah,0x09
   mov al,[si]
   mov [es:di],ax
;;;;;;;;; need prev location to clear after snake moves
   upExchg:
   mov ax,[bx]
   mov [bx],dx
   mov dx,ax
   add bx,2

   loop upExchg

   ;;;;;; clearing previous postion
   mov di,dx
   mov ax,0x0720
   mov [es:di],ax

endU:

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
	
    pop bp
    ret 6

     errorUP:
        mov byte[selfByte],1
        jmp endU


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; moving snake downwards;;;;;;;;;;;;;;;;;;;;;;
moveDown:
   push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

    mov bx,[bp+4] ;; location
    mov dx, [bx]  ;;; the last location value as a temp register
    mov cx,[bp+8] ;;;;length
    add dx,160    ;;;; to get to the lower row
    mov word[last_snake_pos],dx
	 mov word[snake_face_pos],dx
  downColision:
cmp dx,[bx]

je errorDown
add bx,2

loop downColision
moveDown2:
 mov si,[bp+6]  ;;; snake
   mov bx,[bp+4]  ;;; location
   mov dx,[bx]
   add dx,160
   mov di,dx
  

  mov ax,0xb800
   mov es,ax
   mov ah,0x09
   mov al,[si]
   mov [es:di],ax   ;;;;;; snake head 


  mov cx,[bp+8]  ;length
   mov di,[bx] ;; location

   inc si
   mov ah,0x09
   mov al,[si]
   mov [es:di],ax
;;;;;;;;; need prev location to clear after snake moves
  
   downExchg:
    mov ax,[bx]
   mov [bx],dx
   mov dx,ax
   add bx,2

   loop downExchg

   mov di,dx
   mov ax,0x0720
   mov [es:di],ax

endD:

    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
 errorDown:
        mov byte[selfByte],1
        jmp endD


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;moving snake Right;;;;;;;;;;;;;;;;;

moveRight:
   push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
        add dx, 2 ;;;; move towards right by a block

    rightColision:
    cmp dx,[bx]
    je errorRight
    add bx,2
    loop rightColision


    moveRight2:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov word[last_snake_pos],dx
	
	mov di, dx
    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di], ax             ;snake head placed
  mov word[last_snake_pos],dx
    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax
    rightExchg:
       mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
          loop rightExchg
           mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
endR:
     pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
     errorRight:
        mov byte[selfByte],1
        jmp endR

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;moving left;;;;;;;;;;;;;

    moveLeft:
      push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
   
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    sub dx, 2
  mov word[last_snake_pos],dx

    leftColision:
     cmp dx, [bx]
        je errorLeft
        add bx, 2
        loop leftColision

moveLeft2:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx
  mov word[last_snake_pos],dx
    mov ax, 0xb800
    mov es, ax
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x09
    mov al, [si]
    mov [es:di],ax

leftExchg:
 mov ax,[bx]
   mov [bx],dx
   mov dx,ax
   add bx,2

   loop leftExchg

   mov di,dx
   mov ax,0x0720
   mov [es:di],ax

     
endL:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
       errorLeft:
        mov byte[selfByte],1
        jmp endL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;borderssss;;;;;;;;;;;;;
Vborder:
 push bp
    mov bp,sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 25
    corner:
    mov word [es:di], 0x0378
    add di, 160
    loop corner

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2


Hborder:
  push bp
    mov bp,sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 80
corner2: 
    mov word [es:di], 0x0378
    add di, 2
    loop corner2

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MOVING;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moving_snake:
push ax
push bx
push es
push si
push di
push cx

repeat:
mov ax,80
mov bx,1               
mul bx
add ax,1
shl ax,1

mov di,ax
mov si,scoreprint
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,7
nextScore1:
   mov al,[si]
   mov [es:di],ax
   add di,2
   add si,1
   loop nextScore1


   mov al,byte[score]
   add di,2
   mov [es:di],ax
  

mov ah,0
int 0x16
;;;;;;; upward movement
cmp ah,0x48
je up
;;;;;;;;;;; left movement
cmp ah,0x4B
je left
;;;;;;;;;; right movement
cmp ah,0x4D
je right
;;;;;;;;;;; down movement
cmp ah,0x50
je down

;;;;;;;;;;;;;
cmp ah,1
jne repeat    

;;;;;;;;;;;;;;;;;;;Escape check
mov ah,0x4c
je hi
;;;;;;;;;;;;;;; moving upwards
up:
push word[snakeLength]  ;;;;bp+8
mov bx,snakeShape  ;;;bp+6
push bx
mov bx,snake_location   ;;;bp+4
push bx
call  moveUp
;call border_collision
call hurdle_collision
call food_collsion
;call self_collision
cmp byte[if_collide],1
je apple

jmp repeat
hi:
jmp exitKey
down:
push word[snakeLength]  ;;;;bp+8
mov bx,snakeShape  ;;;bp+6
push bx
mov bx,snake_location   ;;;bp+4
push bx
call  moveDown
;call border_collision
call hurdle_collision
call food_collsion
;call self_collision
cmp byte[if_collide],1
je apple
jmp repeat

left:
push word[snakeLength]  ;;;;bp+8
mov bx,snakeShape  ;;;bp+6
push bx
mov bx,snake_location   ;;;bp+4
push bx
call  moveLeft
;call border_collision
call hurdle_collision
call food_collsion
;call self_collision
cmp byte[if_collide],1
je apple
jmp repeat

right:
push word[snakeLength]  ;;;;bp+8
mov bx,snakeShape  ;;;bp+6
push bx
mov bx,snake_location   ;;;bp+4
push bx
call  moveRight
;call border_collision
call hurdle_collision
call food_collsion
;call self_collision
cmp byte[if_collide],1
je apple
jmp repeat
  
apple:
    call printApple
  call print_hurdle
  jmp repeat
exitKey:
        pop cx
		pop di
		pop si
		pop es
        pop bx
        pop ax
        ret

            ;;;;;;;;;;;;;;;;;;;;;;;;food collision;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;adds to score 

food_collsion:
push bp
mov bp,sp
push ax
push bx
push es
push di


mov bx,word[foodposition]
cmp bx,word[last_snake_pos]
jnz exit

mov ax,0xb800
mov es,ax

mov di,word[foodposition]
mov ax,0x0720     ;;; prints space at food position
mov [es:di],ax
inc word[score]  ;;; adds to score 
call inc_size

exit:
pop di
pop es
pop bx
pop ax
pop bp
ret
;;;;;;;;;;;;;;; self collision code (remaining);;;;;;;;;

self_collision:
push bp
mov bp,sp
push ax
push bx
push cx

xor dx,dx
mov cx,[snakeLength]
mov dx,[last_snake_pos]
add dx,2
loopmove:
    cmp dx,[last_snake_pos]
	je here
	add dx,2
    loop loopmove
	jmp noselfcollision
here:
   call EndGame
   
noselfcollision:
pop cx
pop bx
pop ax
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;clearscreen to show GAme has ended;;;;;;;;;;;;;

EndGame:
call clearscreen


push bp
mov bp,sp
push ax
push bx
push cx
push si

mov ax,80
mov bx,10               ;all this work for printing Game Over
mul bx
add ax,36
shl ax,1

mov di,ax
mov si,endgame
mov ax,0xb800
mov es,ax
mov ah,0x07
mov cx,18
nextEnd:
mov al,[si]
mov [es:di],ax
add di,2
add si,1
loop nextEnd

   pop si
   pop cx
   pop bx
   pop ax
   pop bp
   ret
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BORDER COLLISION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
border_collision:

push bp
mov bp,sp
push ax
push bx
push es
push di

cmp byte[selfByte],1
je over1
;;;;;;;; check for right columns
mov bx,0
mov cx,25
rightcol:
cmp bx,word[last_snake_pos]
je over1
add bx,160
loop rightcol

;;; check for left left col
mov bx,158
mov cx,25
leftcol:
cmp bx,word[last_snake_pos]
je over1
add bx,160
loop leftcol

;;; check for upper row
mov bx,0
mov cx,80
upperrow:
cmp bx,word[last_snake_pos]
je over1
add bx,2
loop upperrow

;;; check for lower row
mov bx,3840
mov cx,80

lowerrow:
cmp bx,word[last_snake_pos]
je over1
add bx,2
loop lowerrow

goOut:
pop di
pop es
pop bx
pop ax
pop bp
ret

over1:
call EndGame
jmp finish
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HURDLE COllISION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hurdle_collision:
push bp
mov bp,sp
push ax
push bx
push es
push di

mov bx,word[hurdle_position]
cmp bx,word[last_snake_pos]
jnz endH

mov ax,0xb800
mov es,ax
mov di,[hurdle_position]
call clearscreen
call EndGame


endH:
pop di
pop es
pop bx
pop ax
pop bp
ret
welcome_inter:
     push bp            ; subroutine to start the game after taking input from the user 
	 push ax
	 push bx
	 push cx
	 push dx
	
	mov ah,0x10          ; access video screen 
	int 0x16             ; take input from keyboard 
	call clearscreen     ; call clearscreen after the user takes input 
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret

inc_size:
   push bp
   push ax
   push bx
   push cx
   push es
   push di
   
   mov byte[if_collide],1
    add word[snakeLength],2
   push word[snakeLength]
   mov bx,snakeShape
   push bx
   mov bx,snake_location
   push bx
   call moving_snake  
   pop di
   pop es
   pop cx
   pop bx
   pop ax
   pop bp
   ret



start:
call clearscreen
; location of snake at start
call printboundary
call welcome_note
call welcome_inter
call keyMenu
call welcome_inter
;;;;;;; border printing
mov ax,0
push ax
call Vborder ;; left

mov ax,158
push ax
call Vborder ;;;right

mov ax,0
push ax
call Hborder ;; top
mov ax,3840
push ax
call Hborder ;; bottom

push word[snakeLength]
mov bx,snakeShape
push bx
mov bx,snake_location
push bx
call printsnake
call moving_snake

finish:
mov ax,0x4c00
int 0x21

snake_location: dw 0
