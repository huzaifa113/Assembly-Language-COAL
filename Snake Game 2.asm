[ORG 0x100]
jmp start                  ; Jump to the start label

             length: dw 8              ; Variable to store the length of the snake
             head_of_snake: dw 0       ; Variable to store the head position of the snake
			 row: dw 0                 ; Variable to store the row position of the snake
			 col: dw 0                 ; Variable to store the column position of the snake
			 w: db 'PRESS up_arrow   : UPWARD MOVEMENT',0  ; Message for upward movement
			 s: db 'PRESS down_arrow : DOWNWARD MOVEMENT',0  ; Message for downward movement
			 a: db 'PRESS left_arrow : LEFT MOVEMENT',0    ; Message for left movement
			 d: db 'PRESS right_arrow: RIGHT MOVEMENT',0   ; Message for right movement
			 msg1: db '    WELCOME TO THE SNAKE GAME                         ',0  ; Welcome message
			 scr: db "SCORE: ",0          ; Message for the score
			 msg2: db "SNAKE GAME",0        ; Message for the game
			 over: db "GAME OVER ",0        ; Message for game over
			 load:db "Loading...",0
			 score: dw 0                ; Variable to store the score
			 student1: db ' 22f-3339 Alia',0    ; Student ID
			 student2: db ' 22f-8818 Zainab',0    ; Student ID
			 food_position: dw 0       ; Variable to store the position of the food
             cute_snake: db '__________'   ; Representation of the snake

clrscr:                                         
    push ax
    push di
    push es

    mov ax,0xb800      ; Set video memory segment to ax
    mov es,ax          ; Move ax to es register
    mov di,0           ; Set destination index to the beginning of video memory

  nextloc:
      mov word[es:di],0x0720  ; Write a space character to the video memory
      add di,2                ; Move to the next character in video memory
      cmp di,4000             ; Compare with the end of video memory
      jne nextloc              ; If not equal, jump back to nextloc
  
      pop es                    ; Restore registers from the stack
      pop di
      pop ax
      ret                       ; Return
strlen:
       push bp            ; Save base pointer
       mov bp,sp          ; Set base pointer to stack pointer
       push es            ; Save extra segment register
       push cx            ; Save cx register
       push di            ; Save di register

       les di,[bp+4]      ; Load effective address of the string into di
       mov cx,0xffff      ; Set cx to maximum count
       xor al,al          ; Set al to the null terminator

       repne scasb        ; Scan the string until the null terminator is found
       mov ax,0xffff      ; Set ax to maximum count
       sub ax,cx          ; Subtract cx to get the length
       sub ax,1           ; Adjust for the null terminator

       pop di             ; Restore registers from the stack
       pop cx
       pop es
       pop bp
       ret 4              ; Return, popping the parameter from the stack
printstr:
      push bp            ; Save base pointer
      mov bp,sp          ; Set base pointer to stack pointer
      push es            ; Save extra segment register
      push ax            ; Save ax register
      push cx            ; Save cx register
      push si            ; Save si register
      push di            ; Save di register

      push ds            ; Push data segment register
      mov ax,[bp+4]      ; Load the address of the string into ax
      push ax            ; Push it onto the stack
      call strlen        ; Call the strlen subroutine to get the length of the string

      cmp ax,0            ; Compare the length with 0
      jz exitch           ; If zero, jump to exitch
      mov cx,ax           ; Move the length to cx

      mov ax,0xb800       ; Set video memory segment to ax
      mov es,ax           ; Move ax to es register
      mov ax,80           ; Set the number of rows per line
      mul byte[bp+8]      ; Multiply it by the row specified in the parameter
      add ax,[bp+10]      ; Add the column specified in the parameter
      shl ax,1            ; Multiply by 2 to get the offset in video memory
      mov di,ax           ; Move it to di
      mov si,[bp+4]       ; Load the address of the string into si
      mov ah,[bp+6]       ; Load the color attribute into ah

      cld                 ; Clear the direction flag for forward movement
	  
	  
	  
	  
    nextchar:
           lodsb         ; Load the next byte from si into al and increment si
           stosw         ; Store the word in ax at the destination address es:di and increment di by 2
           loop nextchar ; Repeat until cx becomes zero

    exitch:  
          pop di        ; Restore registers from the stack
          pop si
          pop cx
          pop ax
          pop es
          pop bp
          ret 8                ; Return, popping the parameters from the stack

score_num:
       push bp                ; Save base pointer
       mov bp,sp               ; Set base pointer to stack pointer
       push ax                ; Save registers on the stack
       push bx
       push cx
       push dx
       push es
       push di
          
          
	    mov ax,[score]       ; Load the value of the 'score' variable into ax
        mov bx,10            ; Set bx to 10 for division
        mov cx,0             ; Initialize the counter cx to 0

          loop1:
              mov dx,0          ; Clear dx
              div bx            ; Divide ax by bx, result in ax, remainder in dx
              add dl,0x30       ; Convert the remainder to ASCII (decimal digits)
              push dx           ; Push the converted digit onto the stack
              inc cx            ; Increment the counter
              cmp ax,0          ; Compare ax with 0 to check if division is complete
              jnz loop1         ; If not zero, jump back to loop1

         mov ax,0xb800           ; Set video memory segment to ax
         mov es,ax               ; Move ax to es register
         mov ax,80               ; Set the number of rows per line
         mul byte[bp+6]          ; Multiply it by the row specified in the parameter
         add ax,[bp+4]           ; Add the column specified in the parameter
         shl ax,1                ; Multiply by 2 to get the offset in video memory
         mov di,ax               ; Move it to di

         nextnum:
              pop dx            ; Pop the converted digit from the stack
              mov dh,0x0f       ; Set the high nibble of dh to 0x0f (color attribute)
              mov [es:di],dx    ; Write the digit to the video memory
              add di,2           ; Move to the next position in video memory
              loop nextnum      ; Repeat until all digits are processed
        
        pop di                 ; Restore registers from the stack
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp

        ret 4                   ; Return, popping the parameter from the stack

snake_print:
    push bp            ; Save base pointer
	mov bp,sp           ; Set base pointer to stack pointer
	push ax            ; Save registers on the stack
	push bx
	push cx
	push dx
	push si
	push di
	push es

	mov si,[bp+6]       ; Load the address of the snake array into si
	mov cx,[bp+8]       ; Load the length of the snake into cx
	sub cx,2            ; Subtract 2 from the length (adjust for the null terminator)
	mov ax,80           ; Set the number of rows per line to 80
	mov dx,9            ; Set the row offset for the snake in the screen
	mul dx              ; Multiply ax by dx
	add ax,22           ; Add an offset for the starting column of the snake
	shl ax,1            ; Multiply by 2 to get the offset in video memory
	mov di,ax           ; Set di to the starting location in video memory

	mov ax,0xb800       ; Set video memory segment to ax
	mov es,ax           ; Move ax to es register
	mov bx,[bp+4]       ; Load the address of the variable storing the location into bx
	mov ah,0x05         ; Set color attribute for printing

snake_next_char:
    mov al,[si]        ; Load the next character of the snake into al
	mov [es:di],ax      ; Write the character to the video memory at the current location
	mov [bx],di         ; Update the location variable with the current position
	inc si              ; Move to the next character in the snake array
	add bx,2            ; Move to the next position in the variable storing the location
	add di,2            ; Move to the next position in video memory
	dec cx              ; Decrease the counter
	jnz snake_next_char ; If counter is not zero, jump back to snake_next_char

    pop es               ; Restore registers from the stack
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax 
    pop bp
    ret 6                ; Return, popping the parameters from the stack


boarder:
         push ax            ; Save registers on the stack
         push bx
         push cx
         push dx
         push es
         push di

         mov ax,0xb800       ; Set video memory segment to ax
         mov es,ax           ; Move ax to es register
         mov di,320          ; Set destination index to the starting position in video memory
         mov ax,0x9f5f		 ; Set the color attribute for drawing the border

         left:
             mov word[es:di],ax  ; Write the color attribute to the video memory
             add di,160           ; Move to the next column in video memory
             cmp di,4000           ; Compare with the end of video memory
             jb left              ; If not equal, jump back to left
          mov di,478              ; Set destination index to the starting position for the right border
         right:
             mov word[es:di],ax  ; Write the color attribute to the video memory
             add di,160           ; Move to the next column in video memory
             cmp di,4000           ; Compare with the end of video memory
             jb right             ; If not equal, jump back to right

         mov al,0x5f             ; Set the ASCII character for '-' to al
         mov di,3840             ; Set destination index to the starting position for the bottom border
         down:
             mov word[es:di],ax  ; Write the character to the video memory
             add di,2             ; Move to the next position in video memory
             cmp di,4000           ; Compare with the end of video memory
             jb down              ; If not equal, jump back to down

         mov di,320              ; Set destination index to the starting position for the top border
         up:
             mov word[es:di],ax  ; Write the character to the video memory
             add di,2             ; Move to the next position in video memory
             cmp di,480            ; Compare with the end of the top border
             jb up                ; If not equal, jump back to up

         mov di,0                ; Set destination index to the starting position for clearing the center
         mov ax,0xb800           ; Set video memory segment to ax
         mov es,ax               ; Move ax to es register
         mov ax,0x0720           ; Set the color attribute for clearing the center
         next_space:
             mov [es:di],ax       ; Write the space character to the video memory
             add di,2             ; Move to the next position in video memory
             cmp di,318            ; Compare with the end of the center
             jnz next_space       ; If not equal, jump back to next_space

         mov ax,33               ; Prepare parameter for printing the welcome message
         push ax
         mov ax,2                ; Prepare color attribute for printing the welcome message
         push ax
         mov ax,0x0A             ; Prepare color attribute for printing the welcome message
         push ax
         mov ax,msg2             ; Load the address of the welcome message into ax
         push ax
         call printstr          ; Call the printstr subroutine to print the welcome message

         mov ax,1                ; Prepare parameter for printing the score label
         push ax
         mov ax,1                ; Prepare color attribute for printing the score label
         push ax
         mov ax,0x09             ; Prepare color attribute for printing the score label
         push ax
         mov ax,scr              ; Load the address of the score label into ax
         push ax
         call printstr          ; Call the printstr subroutine to print the score label

         mov ax,1                ; Prepare parameter for printing the initial score value
         push ax
         mov ax,8                ; Prepare color attribute for printing the initial score value
         push ax
         call score_num         ; Call the score_num subroutine to print the initial score value

         pop di                 ; Restore registers from the stack
         pop es
         pop dx
         pop cx
         pop bx
         pop ax
         ret                           ; Return


end_game:
    call clrscr               ; Call the clrscr subroutine to clear the screen

	mov ax,34                 ; Prepare parameter for printing the "Game Over" message
    push ax
    mov ax,11                 ; Prepare color attribute for printing the "Game Over" message
    push ax
    mov ax,0x04               ; Prepare color attribute for printing the "Game Over" message
    push ax
    mov ax,over               ; Load the address of the "Game Over" message into ax
    push ax
    call printstr            ; Call the printstr subroutine to print the "Game Over" message

    mov ax,34                 ; Prepare parameter for printing the "Score" label
    push ax
    mov ax,12                 ; Prepare color attribute for printing the "Score" label
    push ax
    mov ax,0x02               ; Prepare color attribute for printing the "Score" label
    push ax
    mov ax,scr                ; Load the address of the "Score" label into ax
    push ax
    call printstr            ; Call the printstr subroutine to print the "Score" label

    mov ax,12                 ; Prepare parameter for printing the final score value
    push ax
    mov ax,02                 ; Prepare color attribute for printing the final score value
    push ax
    call score_num           ; Call the score_num subroutine to print the final score value

    mov ax,0x4c00             ; Set ax for program termination
    int 0x21                   ; Invoke the DOS system call




upward_movement:
      push bp            ; Save base pointer
	  mov bp,sp           ; Set base pointer to stack pointer
	  push ax            ; Save registers on the stack
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	  mov bx,[bp+4]       ; Load the address of the snake array into bx
	  mov dx,[bx]         ; Load the current head position into dx
	  mov cx,[bp+8]       ; Load the length of the snake into cx
	  sub dx,160          ; Move the head position upward by reducing the row value
		  
	up_hit:
	    cmp dx,[bx]        ; Compare the updated head position with the rest of the snake
	    jne exit_up1       ; If not equal, jump to exit_up1
		call end_game       ; If equal, call the end_game subroutine
        exit_up1:
	    add bx,2            ; Move to the next position in the snake array
		dec cx              ; Decrease the counter
	    jnz up_hit          ; If the counter is not zero, jump back to up_hit

	 up_move:
	    mov si,[bp+6]       ; Load the address of the snake array into si
	    mov bx,[bp+4]       ; Load the address of the snake array into bx
	    mov dx,[bx]         ; Load the current head position into dx
	    sub dx,160          ; Move the head position upward by reducing the row value
	    mov di,dx           ; Copy the updated head position to di
	 
	    mov ax,0xb800       ; Set video memory segment to ax
	    mov es,ax           ; Move ax to es register

	    mov ah,0x05         ; Set color attribute for printing the snake
	    mov al,[si]         ; Load the character from the snake array into al
	    mov [es:di],ax      ; Write the character to the video memory
	    mov cx,[bp+8]       ; Load the length of the snake into cx
	    mov di,[bx]         ; Load the current head position into di
	    inc si              ; Move to the next character in the snake array
		
	    mov ah,0x05         ; Set color attribute for printing the snake
	    mov al,[si]         ; Load the character from the snake array into al
	    mov [es:di],ax      ; Write the character to the video memory
up_printing:
	      mov ax,[bx]        ; Load the word from the current position in the video memory into ax
	      mov [bx],dx        ; Update the position in the snake array with the new position
	      mov dx,ax          ; Copy the original word to dx
	      add bx,2           ; Move to the next position in the snake array
		  dec cx             ; Decrease the counter
	      jnz up_printing    ; If the counter is not zero, jump back to up_printing

	      mov di,dx          ; Copy the updated head position to di
	      mov ax,0x0720      ; Set the color attribute for clearing the space
	      mov [es:di],ax     ; Write the space character to the video memory

	      push di              ; Save di on the stack
	   	  sub di,160        ; Move to the position one row above the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je a1              ; If yes, jump to a1
		  mov [es:di],ax     ; Otherwise, write the space character to the video memory

        a1:
		  sub di,160         ; Move to the position two rows above the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je b1               ; If yes, jump to b1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

        b1:
          pop di                ; Restore di from the stack
	      push di               ; Save di on the stack
		  add di,160         ; Move to the position one row below the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je c1               ; If yes, jump to c1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		c1:
		  add di,160         ; Move to the position two rows below the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je d1               ; If yes, jump to d1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		d1:
          pop di                ; Restore di from the stack
	      push di               ; Save di on the stack
		  add di,2           ; Move to the position one column to the left of the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je e1               ; If yes, jump to e1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		e1:
		  add di,2           ; Move to the position two columns to the left of the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je f1               ; If yes, jump to f1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		f1:
          pop di                ; Restore di from the stack
	      push di               ; Save di on the stack
		  sub di,2           ; Move to the position one column to the right of the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je g1               ; If yes, jump to g1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		g1:
		  sub di,2           ; Move to the position two columns to the right of the head
		  cmp word[es:di],0x4f01  ; Check if the position contains the food character
		  je h1               ; If yes, jump to h1
		  mov [es:di],ax      ; Otherwise, write the space character to the video memory

		h1:
          pop di                ; Restore di from the stack
		  call boarder      ; Call the boarder subroutine to redraw the border
		  jmp up_exit         ; Jump to the up_exit label

up_exit:
    pop di                ; Restore registers and base pointer from the stack
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6                 ; Return to the calling routine

downward_movement:
      push bp            ; Save base pointer
	  mov bp,sp           ; Set base pointer to stack pointer
	  push ax            ; Save registers on the stack
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	     mov bx,[bp+4]     ; Load the address of the snake array into bx
	     mov dx,[bx]       ; Load the current head position into dx
	     mov cx,[bp+8]     ; Load the length of the snake into cx
	     add dx,160        ; Move the head position downward by increasing the row value    
	down_hit:
	        cmp dx,[bx]        ; Compare the updated head position with the rest of the snake
	        jne exit_down1     ; If not equal, jump to exit_down1
			call end_game       ; If equal, call the end_game subroutine
          exit_down1:
	        add bx,2            ; Move to the next position in the snake array
			dec cx              ; Decrease the counter
            jnz down_hit        ; If the counter is not zero, jump back to down_hit

	down_mov:
	        mov si,[bp+6]       ; Load the address of the snake array into si
	        mov bx,[bp+4]       ; Load the address of the snake array into bx
	        mov dx,[bx]         ; Load the current head position into dx
	        add dx,160          ; Move the head position downward by increasing the row value
	        mov di,dx           ; Copy the updated head position to di
	 
	        mov ax,0xb800       ; Set video memory segment to ax
	        mov es,ax           ; Move ax to es register
	        mov ah,0x05         ; Set color attribute for printing the snake

	        mov al,[si]         ; Load the character from the snake array into al
	        mov [es:di],ax      ; Write the character to the video memory
	        mov cx,[bp+8]       ; Load the length of the snake into cx
	        mov di,[bx]         ; Load the current head position into di
	        inc si              ; Move to the next character in the snake array
	        mov ah,0x05         ; Set color attribute for printing the snake
	        mov al,[si]         ; Load the character from the snake array into al
	        mov [es:di],ax      ; Write the character to the video memory

	 down_printing:
	        mov ax,[bx]        ; Load the word from the current position in the video memory into ax
	        mov [bx],dx        ; Update the position in the snake array with the new position
	        mov dx,ax          ; Copy the original word to dx
	        add bx,2           ; Move to the next position in the snake array
			dec cx             ; Decrease the counter
	        jnz down_printing  ; If the counter is not zero, jump back to down_printing

	   mov di,dx              ; Copy the updated head position to di
	   mov ax,0x0720          ; Set the color attribute for clearing the space
	   mov [es:di],ax         ; Write the space character to the video memory

	       push di                ; Save di on the stack
	   	   sub di,160          ; Move to the position one row above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je a2               ; If yes, jump to a2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory
        a2:
		   sub di,160          ; Move to the position two rows above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je b2               ; If yes, jump to b2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

        b2:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   add di,160          ; Move to the position one row below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je c2               ; If yes, jump to c2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		c2:
		   add di,160          ; Move to the position two rows below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je d2               ; If yes, jump to d2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		d2:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   add di,2            ; Move to the position one column to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je e2               ; If yes, jump to e2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		e2:
		   add di,2            ; Move to the position two columns to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je f2               ; If yes, jump to f2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		f2:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   sub di,2            ; Move to the position one column to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je g2               ; If yes, jump to g2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		g2:
		   sub di,2            ; Move to the position two columns to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je h2               ; If yes, jump to h2
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		h2:
          pop di                  ; Restore di from the stack
		  call boarder        ; Call the boarder subroutine to redraw the border
	      jmp down_exit          ; Jump to the down_exit label

down_exit:
    pop di                  ; Restore registers and base pointer from the stack
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6                   ; Return to the calling routine

leftward_movement:
      push bp            ; Save base pointer
	  mov bp,sp           ; Set base pointer to stack pointer
	  push ax            ; Save registers on the stack
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	     mov bx,[bp+4]     ; Load the address of the snake array into bx
	     mov dx,[bx]       ; Load the current head position into dx
	     mov cx,[bp+8]     ; Load the length of the snake into cx
	     sub dx,2           ; Move the head position leftward by decreasing the column value
	left_hit:
	      cmp dx,[bx]        ; Compare the updated head position with the rest of the snake
	      jne exit_left1     ; If not equal, jump to exit_left1
		  call end_game       ; If equal, call the end_game subroutine
       exit_left1:
	      add bx,2            ; Move to the next position in the snake array
	      dec cx              ; Decrease the counter
	      jnz left_hit        ; If the counter is not zero, jump back to left_hit

	left_mov:
	      mov si,[bp+6]       ; Load the address of the snake array into si
	      mov bx,[bp+4]       ; Load the address of the snake array into bx
	      mov dx,[bx]         ; Load the current head position into dx
	      sub dx,2            ; Move the head position leftward by decreasing the column value
	      mov di,dx           ; Copy the updated head position to di
	 
	    mov ax,0xb800        ; Set video memory segment to ax
	    mov es,ax            ; Move ax to es register
	    mov ah,0x05          ; Set color attribute for printing the snake
	    mov al,[si]          ; Load the character from the snake array into al
	    mov [es:di],ax       ; Write the character to the video memory
	    mov cx,[bp+8]        ; Load the length of the snake into cx
	    mov di,[bx]          ; Load the current head position into di
	    inc si               ; Move to the next character in the snake array
	    mov ah,0x05          ; Set color attribute for printing the snake
	    mov al,[si]          ; Load the character from the snake array into al
	    mov [es:di],ax       ; Write the character to the video memory

	left_printing:
	        mov ax,[bx]        ; Load the word from the current position in the video memory into ax
	        mov [bx],dx        ; Update the position in the snake array with the new position
	        mov dx,ax          ; Copy the original word to dx
	        add bx,2           ; Move to the next position in the snake array
	        dec cx             ; Decrease the counter
	        jnz left_printing  ; If the counter is not zero, jump back to left_printing

	    mov di,dx              ; Copy the updated head position to di
	    mov ax,0x0720          ; Set the color attribute for clearing the space
	    mov [es:di],ax         ; Write the space character to the video memory

	       push di                ; Save di on the stack
	   	   sub di,160          ; Move to the position one row above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je a3               ; If yes, jump to a3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

        a3:
		   sub di,160          ; Move to the position two rows above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je b3               ; If yes, jump to b3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

        b3:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   add di,160          ; Move to the position one row below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je c3               ; If yes, jump to c3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		c3:
		   add di,160          ; Move to the position two rows below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je d3               ; If yes, jump to d3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		d3:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   add di,2            ; Move to the position one column to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je e3               ; If yes, jump to e3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		e3:
		   add di,2            ; Move to the position two columns to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je f3               ; If yes, jump to f3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		f3:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   sub di,2            ; Move to the position one column to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je g3               ; If yes, jump to g3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		g3:
		   sub di,2            ; Move to the position two columns to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je h3               ; If yes, jump to h3
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		h3:
           pop di                  ; Restore di from the stack
		   call boarder        ; Call the boarder subroutine to redraw the border
		   jmp left_exit         ; Jump to left_exit label

 left_exit:
    pop di                  ; Restore registers and base pointer from the stack
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6                   ; Return to the calling routine

rightward_movement:
      push bp            ; Save base pointer
	  mov bp,sp           ; Set base pointer to stack pointer
	  push ax            ; Save registers on the stack
	  push bx
	  push cx
	  push dx
	  push es
	  push si
	  push di
	  
	         mov bx,[bp+4]    ; Load the address of the snake array into bx
	         mov dx,[bx]      ; Load the current head position into dx
	         mov cx,[bp+8]    ; Load the length of the snake into cx
	         add dx,2         ; Move the head position rightward by increasing the column value
	   right_hit:
	           cmp dx,[bx]     ; Compare the updated head position with the rest of the snake
	           jne exit_right1  ; If not equal, jump to exit_right1
			   call end_game    ; If equal, call the end_game subroutine
		exit_right1:
	           add bx,2          ; Move to the next position in the snake array
	           dec cx            ; Decrease the counter
	           jnz right_hit     ; If the counter is not zero, jump back to right_hit
			   
	   right_mov:
	           mov si,[bp+6]      ; Load the address of the snake array into si
	           mov bx,[bp+4]      ; Load the address of the snake array into bx
	           mov dx,[bx]        ; Load the current head position into dx
	           add dx,2           ; Move the head position rightward by increasing the column value
	           mov di,dx          ; Copy the updated head position to di
	 
	           mov ax,0xb800       ; Set video memory segment to ax
	           mov es,ax           ; Move ax to es register
	           mov ah,0x05         ; Set color attribute for printing the snake
	           mov al,[si]         ; Load the character from the snake array into al
	           mov [es:di],ax      ; Write the character to the video memory
	           mov cx,[bp+8]       ; Load the length of the snake into cx
	           mov di,[bx]         ; Load the current head position into di
	           inc si              ; Move to the next character in the snake array
	           mov ah,0x05         ; Set color attribute for printing the snake
	           mov al,[si]         ; Load the character from the snake array into al
	           mov [es:di],ax      ; Write the character to the video memory

	   right_printing:
	       mov ax,[bx]         ; Load the word from the current position in the video memory into ax
	       mov [bx],dx         ; Update the position in the snake array with the new position
	       mov dx,ax           ; Copy the original word to dx
	       add bx,2            ; Move to the next position in the snake array
	       dec cx              ; Decrease the counter
	       jnz right_printing  ; If the counter is not zero, jump back to right_printing

	       mov di,dx            ; Copy the updated head position to di
	       mov ax,0x0720        ; Set the color attribute for clearing the space
	       mov [es:di],ax       ; Write the space character to the video memory

	       push di              ; Save di on the stack
	   	   sub di,160           ; Move to the position one row above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je a4               ; If yes, jump to a4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

        a4:
		   sub di,160           ; Move to the position two rows above the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je b4               ; If yes, jump to b4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory
        b4:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   add di,160           ; Move to the position one row below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je c4               ; If yes, jump to c4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		c4:
		   add di,160           ; Move to the position two rows below the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je d4               ; If yes, jump to d4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		d4:
          pop di                  ; Restore di from the stack
	      push di                 ; Save di on the stack
		   add di,2             ; Move to the position one column to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je e4               ; If yes, jump to e4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		e4:
		   add di,2             ; Move to the position two columns to the left of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je f4               ; If yes, jump to f4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		f4:
           pop di                  ; Restore di from the stack
	       push di                 ; Save di on the stack
		   sub di,2             ; Move to the position one column to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je g4               ; If yes, jump to g4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		g4:
		   sub di,2             ; Move to the position two columns to the right of the head
		   cmp word[es:di],0x4f01  ; Check if the position contains the food character
		   je h4               ; If yes, jump to h4
		   mov [es:di],ax      ; Otherwise, write the space character to the video memory

		h4:
           pop di                  ; Restore di from the stack
		   call boarder        ; Call the boarder subroutine to redraw the border
		   jmp right_exit       ; Jump to right_exit label
		   
right_exit:
    pop di                  ; Restore registers and base pointer from the stack
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6                   ; Return to the calling routine

keyboard:
    push ax             ; Save registers on the stack
    push bx
    push cx
    push dx
	
    kb_hit:

         mov ah,0        ; Function 0 of int 16h - check for keyboard input
         int 0x16

	        cmp ah,0x48     ; Check if the key pressed is the UP arrow key
	        je up_ko_move    ; If yes, jump to up_ko_move

	        cmp ah,0x4B     ; Check if the key pressed is the LEFT arrow key
	        je left_ko_move  ; If yes, jump to left_ko_move

	        cmp ah,0x4D     ; Check if the key pressed is the RIGHT arrow key
	        je right_ko_move ; If yes, jump to right_ko_move

	        cmp ah,0x50     ; Check if the key pressed is the DOWN arrow key
	        je down_ko_move  ; If yes, jump to down_ko_move

	        cmp ah,1        ; Check if any key is pressed (except arrow keys)
	        jne kb_hit      ; If yes, continue waiting for arrow keys

	      mov ax,0x4c00      ; Exit program
	      je exit

    up_ko_move:
		   push word[length]      ; Push the length of the snake onto the stack
		   mov bx,cute_snake      ; Move the address of the snake characters to bx
		   push bx                ; Push the address of the snake characters onto the stack
		   mov bx,head_of_snake   ; Move the address of the head of the snake to bx
		   push bx                ; Push the address of the head of the snake onto the stack
		   call upward_movement   ; Call the upward_movement subroutine
		   jmp checking           ; Jump to the checking label

	down_ko_move:
		   push word[length]      ; Push the length of the snake onto the stack
		   mov bx,cute_snake      ; Move the address of the snake characters to bx
		   push bx                ; Push the address of the snake characters onto the stack
		   mov bx,head_of_snake   ; Move the address of the head of the snake to bx
		   push bx                ; Push the address of the head of the snake onto the stack
		   call downward_movement ; Call the downward_movement subroutine
		   jmp checking           ; Jump to the checking label

	left_ko_move:
		 push word[length]       ; Push the length of the snake onto the stack
		 mov bx,cute_snake       ; Move the address of the snake characters to bx
	     push bx                 ; Push the address of the snake characters onto the stack
		 mov bx,head_of_snake    ; Move the address of the head of the snake to bx
		 push bx                 ; Push the address of the head of the snake onto the stack
		 call leftward_movement  ; Call the leftward_movement subroutine
		 jmp checking            ; Jump to the checking label

	right_ko_move:
		 push word[length]       ; Push the length of the snake onto the stack
		 mov bx,cute_snake       ; Move the address of the snake characters to bx
		 push bx                 ; Push the address of the snake characters onto the stack
		 mov bx,head_of_snake    ; Move the address of the head of the snake to bx
		 push bx                 ; Push the address of the head of the snake onto the stack
		 call rightward_movement ; Call the rightward_movement subroutine
		 jmp checking            ; Jump to the checking label

    checking:
		 call check_dead_element  ; Call the check_dead_element subroutine
	     push word[food_position] ; Push the food position onto the stack
		 push word[length]           ; Push the length of the snake onto the stack
		 mov ax,cute_snake           ; Move the address of the snake characters to ax
		 push ax                     ; Push the address of the snake characters onto the stack
		 mov ax,head_of_snake        ; Move the address of the head of the snake to ax
		 push ax                     ; Push the address of the head of the snake onto the stack

		 call check_food             ; Call the check_food subroutine
		 jmp kb_hit                  ; Jump back to kb_hit to continue waiting for key presses
	    
  exit:
	pop bx                   ; Restore registers from the stack
	pop ax
	ret                     ; Return to the calling routine
check_dead_element:
       push ax            ; Save registers on the stack
	   push bx
	   push cx
	   push dx
	   push di
	   push si
	   push es



    right1:
       mov dx,158          ; Set initial value for the right collision check
       right_collision:
           add dx,160       ; Move to the next position in the right direction
           cmp dx,4000       ; Check if reached the end of the screen
           jae left1         ; If yes, jump to left1
           cmp [head_of_snake],dx   ; Compare head position with current position
           je finish        ; If equal, finish (collision detected)
           ja right_collision       ; If not equal and less, continue checking right

   left1:
      mov dx,0             ; Set initial value for the left collision check      
      left_collision:
          add dx,160        ; Move to the next position in the left direction
          cmp dx,4000       ; Check if reached the end of the screen
          jae down1         ; If yes, jump to down1
          cmp [head_of_snake],dx  ; Compare head position with current position
          je finish         ; If equal, finish (collision detected)
          ja left_collision        ; If not equal and less, continue checking left

   up1:     
     mov dx,320           ; Set initial value for the up collision check
     up_collision:
          add dx,2          ; Move to the next position in the up direction
          cmp dx,480        ; Check if reached the end of the screen
          jae down1         ; If yes, jump to down1
          cmp [head_of_snake],dx  ; Compare head position with current position
          je finish         ; If equal, finish (collision detected)
          ja up_collision          ; If not equal and less, continue checking up

	down1:
     mov dx,3840          ; Set initial value for the down collision check
     down_collision:
          add dx,2          ; Move to the next position in the down direction
          cmp dx,4000       ; Check if reached the end of the screen
          jae end            ; If yes, jump to end (no collision detected)
          cmp [head_of_snake],dx  ; Compare head position with current position
          je finish         ; If equal, finish (collision detected)
          jb down_collision       ; If not equal and greater, continue checking down



finish:
    call clrscr             ; Clear the screen
    mov ax,34               ; Prepare parameters for printstr (color)
    push ax
    mov ax,11               ; Prepare parameters for printstr (color)
    push ax
    mov ax,0x03            ; Prepare parameters for printstr (color)
    push ax
    mov ax,over             ; Prepare parameters for printstr (message)
    push ax
    call printstr           ; Print the "Game Over" message

    mov ax,34               ; Prepare parameters for printstr (color)
    push ax
    mov ax,12               ; Prepare parameters for printstr (color)
    push ax
    mov ax,0x06             ; Prepare parameters for printstr (color)
    push ax
    mov ax,scr              ; Prepare parameters for printstr (message)
    push ax
    call printstr           ; Print the "SCORE: " message

    mov ax,12               ; Prepare parameters for score_num (color)
    push ax
    mov ax,42               ; Prepare parameters for score_num (color)
    push ax
    call score_num          ; Print the score

	   pop es                 ; Restore registers from the stack
	   pop si
	   pop di
	   pop dx
	   pop cx
	   pop bx
	   pop ax

  mov ax,0x4c00             ; Exit program
  int 0x21

end:
	   pop es                 ; Restore registers from the stack
	   pop si
	   pop di
	   pop dx
	   pop cx
	   pop bx
	   pop ax
       ret                         ; Return to the calling routine
random:
     push ax            ; Save registers on the stack
     push bx
     push cx
     push dx
	 push si
	 push di
	 push es



    inloop:
        mov ah,00h                   ; Set up for generating a random number
        int 1ah                      ; Call the BIOS interrupt to get the current time

        mov ax,dx                    ; Copy the result of the interrupt to ax
        mov dx,0                     ; Clear dx
        mov cx,25                    ; Set up for generating a random row number
        div cx                       ; Divide the result by 25

        mov [row],dx                 ; Store the result in the variable 'row'

        mov ah,00h                   ; Set up for generating another random number
        int 1ah                      ; Call the BIOS interrupt again to get more randomness

        mov ax,dx                    ; Copy the result of the second interrupt to ax
        mov dx,0                     ; Clear dx
        mov cx,80                    ; Set up for generating a random column number
        div cx                       ; Divide the result by 80

        mov [col],dx                 ; Store the result in the variable 'col'

     mov ax,80                      ; Calculate the position in the screen buffer
     mov bx,[row]                   ; Load 'row' into bx
     mul bx                         ; Multiply ax by bx
     mov bx,[col]                   ; Load 'col' into bx
     add ax,bx                      ; Add bx to ax
     shl ax,1                       ; Multiply ax by 2 (each position in the screen buffer is 2 bytes)
   not_at_up:
     mov di,0                       ; Initialize di to the top of the screen
	 loop_up:
	    cmp di,ax                    ; Compare di with ax (current position)
		je inloop                    ; If equal, generate a new random position
		add di,2                      ; Move to the next position in the up direction
		cmp di,480                    ; Check if reached the top of the screen
		jb loop_up                    ; If not, continue checking up

    not_at_down:
	   mov di,3840                    ; Initialize di to the bottom of the screen
	   loop_down:
	       cmp di,ax                    ; Compare di with ax (current position)
		   je inloop                    ; If equal, generate a new random position
		   add di,2                      ; Move to the next position in the down direction
		   cmp di,4000                   ; Check if reached the bottom of the screen
		   jb loop_down                  ; If not, continue checking down

    not_at_left:
	    mov di,0                      ; Initialize di to the left side of the screen
		loop_left:
		    cmp di,ax                   ; Compare di with ax (current position)
			je inloop                   ; If equal, generate a new random position
			add di,160                  ; Move to the next position in the left direction
			cmp di,4000                 ; Check if reached the left side of the screen
			jb loop_left                ; If not, continue checking left

     not_at_right:
	     mov di,158                    ; Initialize di to the right side of the screen
		 loop_right:
		    cmp di,ax                   ; Compare di with ax (current position)
			je inloop                   ; If equal, generate a new random position
			add di,160                  ; Move to the next position in the right direction
			cmp di,4000                 ; Check if reached the right side of the screen
			jb loop_right               ; If not, continue checking right

   cmp ax,4000                     ; Check if ax is greater than the screen size
   jg inloop                        ; If yes, generate a new random position

   mov word[food_position],ax      ; Store the generated random position as the food position
   cmp word[food_position],0x0f6f  ; Check if the food position is in the snake's body
   je inloop                        ; If yes, generate a new random position

   pop es                           ; Restore registers from the stack
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   ret                               ; Return to the calling routine

food:                                      ; Printing food subroutine
      push ax
	  push bx
      push cx
	  push dx
      push di
      push es

           call random                     ; Calling the random subroutine to store a random value in row and col
         
         mov ax,80                         ; Set up constants for screen calculations
         mov cx,[row]                      ; Load 'row' into cx
         mul cx                            ; Multiply ax by cx
         mov cx,[col]                      ; Load 'col' into cx
         add ax,cx                         ; Add cx to ax
         shl ax,1                          ; Multiply ax by 2 (each position in the screen buffer is 2 bytes)
         mov di,ax                         ; Move the calculated position to di

         mov ax,0xb800                     ; Set up for writing to the screen buffer
         mov es,ax

         mov ax,0x4f11                      ; Set the character and attribute for the food
         mov word[es:di],ax                ; Write the character and attribute to the screen buffer
     pop es                               ; Restore registers
     pop di
	 pop dx
     pop cx
	 pop bx
     pop ax

     ret                                    ; Return to the calling routine
check_food:
    push bp                              ; Save registers on the stack
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si

	 mov ax,0xb800                         ; Set up for clearing the top line of the screen
	 mov es,ax
	 mov ax,0x0720                        ; Set the character and attribute for clearing
	 mov di,0
	 firstline:
	     mov word[es:di],ax                ; Write the character and attribute to clear the line
		 add di,2
		 cmp di,158                         ; Check if reached the end of the line
		 jne firstline

    mov bx, [bp + 4]                       ; Load address of the snake array
    mov dx, [bp + 10]                      ; Load the current head position of the snake

    cmp [bx], dx                           ; Check if the head of the snake is at the food position
    jne not_change                         ; If not, skip to the 'not_change' label

    add word [score], 1                    ; Increment the score
		   mov ax,1
           push ax
           mov ax,8
           push ax
           call score_num                  ; Call the score_num subroutine to update the score display

    mov cx, [bp + 8]                       ; Load snake length
	dec cx
	shl cx,1
    add bx, cx                             ; Move to the end of the snake array
    mov dx, [bx]                           ; Load the last position of the snake
    sub dx, [bx - 2]                       ; Subtract the second last position of the snake

    mov ax, [bx]                           ; Load the last position of the snake
    add ax, dx                             ; Add the difference to the last position
    mov dx, ax

   shr cx,1
   inc cx                                 ; Increment the length by 1
   add word[length], 1                    ; Increment the length variable

    add bx, 2                              ; Move to the next empty position in the snake array
    mov [bx], dx                           ; Update the position in the snake array
    mov si, [bp + 6]                       ; Load the address of the snake body array
    inc si                                 ; Move to the next character in the snake body
    mov ax, 0xb800                         ; Set up for writing to the screen buffer
    mov es, ax
    mov di, dx                             ; Load the current food position
    mov ah, 0x05
    mov al, [si]                           ; Load the character from the snake body

    mov [es:di], ax                        ; Write the character and attribute to the screen buffer


    mov ax, 0xb800                         ; Set up for writing to the screen buffer
    mov es, ax 

    call food                             ; Call the food subroutine to print a new food

 not_change:
    pop si                                ; Restore registers from the stack
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8                                   ; Return to the calling routine

start:

   call clrscr                            ; Call the clrscr subroutine to clear the screen
   ;call draw_border
   mov ax,25                              ; Set up parameters for printing a message
   push ax
   mov ax,9
   push ax
   mov ax,0x05
   push ax
   mov ax,msg1
   push ax
   call printstr                          ; Call the printstr subroutine to display the message

   mov ax,33                              ; Set up parameters for printing student1 message
   push ax
   mov ax,11
   push ax
   mov ax,0x0c
   push ax
   mov ax,student1
   push ax
   call printstr                          ; Call the printstr subroutine to display the message

   mov ax,33                              ; Set up parameters for printing student2 message
   push ax
   mov ax,12
   push ax
   mov ax,0x0c
   push ax
   mov ax,student2
   push ax
   call printstr                          ; Call the printstr subroutine to display the message

   mov ah,0x1                             ; Wait for a keypress
   int 0x21                               ; DOS interrupt

   call clrscr                            ; Call clrscr subroutine to clear the screen
   mov ax,25                              ; Set up parameters for printing ''
   push ax
   mov ax,9
   push ax
   mov ax,0x09
   push ax
   mov ax,w
   push ax
   call printstr                          ; Call printstr subroutine to display ''

   mov ax,25                              ; Set up parameters for printing ''
   push ax
   mov ax,10
   push ax
   mov ax,0x0a
   push ax
   mov ax,s
   push ax
   call printstr                          ; Call printstr subroutine to display ''

   mov ax,25                              ; Set up parameters for printing ''
   push ax
   mov ax,11
   push ax
   mov ax,0x0c
   push ax
   mov ax,a
   push ax
   call printstr                          ; Call printstr subroutine to display ''

   mov ax,25                              ; Set up parameters for printing ''
   push ax
   mov ax,12
   push ax
   mov ax,0x07
   push ax
   mov ax,d
   push ax
   call printstr                          ; Call printstr subroutine to display ''
	
   mov ah,0x1                             ; Wait for a keypress
   int 0x21                               ; DOS interrupt
 call clrscr
 
   mov ax,25                              ; Set up parameters for printing 'loading'
   push ax
   mov ax,12
   push ax
   mov ax,0x17
   push ax
   mov ax,load
   push ax
  
   call printstr 
   
   mov ah,0x1                             ; Wait for a keypress
   int 0x21                               ; DOS interrupt
   
   call clrscr                            ; Call clrscr subroutine to clear the screen
   call boarder                           ; Call boarder subroutine to draw a border

   push word[length]                       ; Push parameters for snake_print subroutine
   mov ax,cute_snake
   push ax
   mov ax,head_of_snake
   push ax
   call snake_print                       ; Call snake_print subroutine to print the snake

   call food                              ; Call food subroutine to print food

   call keyboard                          ; Call keyboard subroutine for handling keyboard input

   mov ax,0x4c00                           ; DOS exit syscall
   int 21h                                ; DOS interrupt

