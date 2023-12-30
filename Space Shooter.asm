[org 0x0100]
jmp start

bg: db 0x70
gname: db 'CATCH IT',0
gnameclr: db 0x07 ;
gnamecorstrt: dw 1,34
gnamecor: dw 4,34
block1: dw 0x0720 	;29b2
block1cor: dw 2,4
mclr: db 0xC0
m: db 'Game Instructions',0
m1: db 'Press <- to move left or -> to move right',0
m2: db '- RED object: 15 points',0	
m3: db '- BLUE object: 10 points',0	
m4: db '- GREEN object: 5 points',0
m5: db '- Avoid hitting bomb',0	
m6: db '- You have total 120 seconds',0
m7: db 'Press ENTER to start',0
;end var
block1corend: dw 7,18
mclrend: db 0x7B
mend: db 'GAME OVER',0
m1end: db 'Your Score: ',0
m2end: db 'Red Object (15 pts): ',0
m3end: db 'Blue Object (10 pts): ',0
m4end: db 'Green Object (5 pts): ',0
m5end: db 'You CATCHED: ',0
goclr: db 0xF0

;----game scrren var-----------
scoreline: db 'Score::',0
scorelinecor: dw 4,62
score: dw 0	;block1corx+1
robj: dw 0
bobj: dw 0
gobj: dw 0
scorecor: dw 4,69
timeline: db 'Time:',0
timelinecor: dw 4,7
time: dw 120	;block1corx+1
timecor: dw 4,12
timeisr: dd 0	;for saving
countfortime: dw 0
bucketcoor: dw 20,40
int9isr: dd 0
endofgame: dd 0
counterforscroll: dw 0
counterforobjgen: dw 0
counterfornewobj: dw 0



;*******FUNCTIONS********
strlen: push bp
	mov bp,sp
	;push ax ;result return in ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0
	les di,[bp+4]
	xor al,al
	mov cx,0xffff
	cld
repne	scasb
	mov ax,0xffff
	sub ax,cx
	dec ax	;decrement extra sapce for 0

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	;pop ax
	pop bp
	ret 4


locgen: push bp
	mov bp,sp
	;push ax ;result return in ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0;just a precaution
	mov al,80
	mul byte [bp+6];x
	add ax,[bp+4];y
	shl ax,1

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	;pop ax
	pop bp
	ret 4



;------------------------START SCREEN--------------
startprint:
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di



	;setting bg
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	mov ah,[bg]
	mov al,0x20
	mov di,0
	cld
  rep	stosw	;background set


	;print 1st line
	push ds
	mov si,gname
	push si
	call strlen
	mov cx,ax	;len in cx


	push word [gnamecorstrt];x
	push word [gnamecorstrt+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,[gnameclr]
	mov si,gname
nameloopstart: lodsb
	 stosw
	 loop nameloopstart

	;border start line
	push word [block1cor];x
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ax,[block1]
	mov cx,72
  rep   stosw

;;;;;;;;;;small border print
	mov si,17
	mov dx,[block1cor]
bbprintstart: 
	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,2
	mov ax,[block1]
	rep stosw

	push dx
	mov bx,74
	push bx
	call locgen
	mov di,ax
	mov cx,2
	mov ax,[block1]
	rep stosw

	dec si
	jnz bbprintstart

	;border endline	
	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,72
	mov ax,[block1]
	rep stosw

	;line 0
	push ds
	mov si,m
	push si
	call strlen
	mov cx,ax	;len in cx
	
	mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 30
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x07
	mov si,m
mloop:  lodsb
	 stosw
	 loop mloop

	;;;;;;;;;;;

	;line 1
	push ds
	mov si,m1
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 18
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0xF0
	mov si,m1
m1loop:  lodsb
	 stosw
	 loop m1loop	

	;;;;;;;;;;

	;line 2
	push ds
	mov si,m2
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 10
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x74
	mov si,m2
m2loop:  lodsb
	 stosw
	 loop m2loop	

	;;;;;;;;;;;;

	;line 3
	push ds
	mov si,m3
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 10
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x79
	mov si,m3
m3loop:  lodsb
	 stosw
	 loop m3loop	

	;;;;;;;;;;;;
		

	;line 4
	push ds
	mov si,m4
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 10
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x72
	mov si,m4
m4loop:  lodsb
	 stosw
	 loop m4loop	

	;;;;;;;;;;;;


	;line 5
	push ds
	mov si,m5
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 10
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,[bg]
	mov si,m5
m5loop:  lodsb
	 stosw
	 loop m5loop	

	;;;;;;;;;;

	;line 6
	push ds
	mov si,m6
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 10
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,[bg]
	mov si,m6
m6loop:  lodsb
	 stosw
	 loop m6loop	

	;;;;;;;;;;


	;line 7
	push ds
	mov si,m7
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1cor]
	add dx,2
	push dx
	;mov bx,10
	push 30
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x87
	mov si,m7
m7loop:  lodsb
	 stosw
	 loop m7loop	

	;;;;;;;;;;

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 
;--------------------------------------------------
;-------------END SCREEN---------------------------------
endprint:
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di



	;setting bg
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	mov ah,[bg]
	mov al,0x20
	mov di,0
	cld
	rep stosw	;background set

;====================================

;print 1st line

	push ds
	mov si,gname
	push si
	call strlen
	mov cx,ax	;len in cx


	push word [gnamecor];x
	push word [gnamecor+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x07
	mov si,gname

nameloopend:

	lodsb
	stosw
	loop nameloopend

;====================================

;border start line

	push word [block1corend];x
	push word [block1corend+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ax,[block1]
	mov cx,40
  	rep stosw

	
;====================================

;small border print

	mov si,14
	mov dx,[block1corend]

;====================================

bbprintend: 

	add dx,1
	push dx
	push word [block1corend+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,2
	mov ax,[block1]
	rep stosw

	push dx
	mov bx,56
	push bx
	call locgen
	mov di,ax
	mov cx,2
	mov ax,[block1]
	rep stosw

	dec si
	jnz bbprintend

;====================================

;border endline
	
	add dx,1
	push dx
	push word [block1corend+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,40
	mov ax,[block1]
	rep stosw

;====================================

;line GameOver

	push ds
	mov si,mend
	push si
	call strlen
	mov cx,ax	;len in cx
	
	mov dx,[block1corend]
	add dx,2
	push dx
	;mov bx,10
	push 33
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,[goclr]
	mov si,mend

mendloop:

	lodsb
	stosw
	loop mendloop

;====================================


;line Score

	push ds
	mov si,m1end
	push si
	call strlen
	mov cx,ax	;len in cx
	
	;mov dx,[block1corend]
	add dx,2
	push dx
	;mov bx,10
	push 30
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,[bg]
	mov si,m1end

m1endloop:

	lodsb
	stosw
	loop m1endloop	

;====================================

;High Score Variable

	mov ax,[score]
	mov bx,10
	mov dx,0
	mov cx,0

nextdigitend:
	
	mov dx,0
	div bx
	add dl, 0x30
	push dx
	inc cx
	cmp ax,0
	jnz nextdigitend

nextposend:
	
	pop dx
	mov dh,[bg]
	mov [es:di],dx
	add di,2
	loop nextposend

;====================================


;You Catched

	push ds
	mov si,m5end
	push si
	call strlen
	mov cx,ax	;len in cx
	
	mov dx,[block1corend]
	add dx,6
	push dx
	;mov bx,10
	push 31
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x07
	mov si,m5end

m5endloop:

	lodsb
	stosw
	loop m5endloop	

;====================================
;====================================

;RED

	push ds
	mov si,m2end
	push si
	call strlen
	mov cx,ax	;len in cx
	

	add dx,2
	push dx
	;mov bx,10
	push 26
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x74
	mov si,m2end

m2endloop:

	lodsb
	stosw
	loop m2endloop	

;====================================

;RED obj

	mov ax,[robj]
	mov bx,10
	mov dx,0
	mov cx,0

nextdigitend1:
	
	mov dx,0
	div bx
	add dl, 0x30
	push dx
	inc cx
	cmp ax,0
	jnz nextdigitend1

nextposend1:
	
	pop dx
	mov dh,0x74
	mov [es:di],dx
	add di,2
	loop nextposend1

;====================================
;====================================

;Blue

	push ds
	mov si,m3end
	push si
	call strlen
	mov cx,ax	;len in cx
	

	mov dx,[block1corend]
	add dx,10
	push dx
	;mov bx,10
	push 26
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x79
	mov si,m3end

m3endloop:

	lodsb
	stosw
	loop m3endloop	

;====================================

;Blue obj

	mov ax,[bobj]
	mov bx,10
	mov dx,0
	mov cx,0

nextdigitend2:
	
	mov dx,0
	div bx
	add dl, 0x30
	push dx
	inc cx
	cmp ax,0
	jnz nextdigitend2

nextposend2:
	
	pop dx
	mov dh,0x79
	mov [es:di],dx
	add di,2
	loop nextposend2

;====================================

;Green

	push ds
	mov si,m4end
	push si
	call strlen
	mov cx,ax	;len in cx
	

	mov dx,[block1corend]
	add dx,12
	push dx
	;mov bx,10
	push 26
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x72
	mov si,m4end

m4endloop:

	lodsb
	stosw
	loop m4endloop	

;====================================

;Blue obj

	mov ax,[gobj]
	mov bx,10
	mov dx,0
	mov cx,0

nextdigitend3:
	
	mov dx,0
	div bx
	add dl, 0x30
	push dx
	inc cx
	cmp ax,0
	jnz nextdigitend3

nextposend3:
	
	pop dx
	mov dh,0x72
	mov [es:di],dx
	add di,2
	loop nextposend3

;====================================

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 

;====================================

;--------------------------------------------------

;-------------GAME---------------------------------


point5obj: push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0xb800
	mov es,ax


	push word [bp+6]	;x
	push word [bp+4]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x72
	mov al,'*'

  rep	stosw
	mov di,[bp-2]
	add di,160	;move 1 line
	mov [es:di],ax
	add di,4
	mov [es:di],ax
	mov di,[bp-2]
	add di,320	;move 2 line
	mov cx,2
	mov ah,0x7A

  rep	stosw
	;add di,2
	mov [es:di],ax


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret 4	;x y coor

;;;;;;;;;;;;;;;;10obj;;;;;;;;;;;;;;;;;

point10obj: push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0xb800
	mov es,ax


	push word [bp+6]	;x
	push word [bp+4]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x71
	mov al,'*'

  rep	stosw
	mov di,[bp-2]
	add di,160	;move 1 line
	mov [es:di],ax
	add di,4
	mov [es:di],ax
	mov di,[bp-2]
	add di,320	;move 2 line
	mov cx,2
	mov ah,0x79	

  rep	stosw
	;add di,2
	mov [es:di],ax



	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret 4	;x y coor
;;;;;;;;;;point15obj;;;;;;;;;;;;;;;

point15obj: push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0xb800
	mov es,ax


	push word [bp+6]	;x
	push word [bp+4]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x74
	mov al,'*'

  rep	stosw
	mov di,[bp-2]
	add di,160	;move 1 line
	mov [es:di],ax
	add di,4
	mov [es:di],ax
	mov di,[bp-2]
	add di,320	;move 2 line
	mov cx,2
	mov ah,0x7C

  rep	stosw
	;add di,2
	mov [es:di],ax


	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret 4	;x y coor

;-------------------------------------------------------------

;-------------------bucket----------------

bucket: push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0xb800
	mov es,ax


	push word [bucketcoor]	;x
	push word [bucketcoor+2]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x07	;30
	mov al,0xB1

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret	;x y co


;---------------------------------------------------------------
;----------------------Bucket Left-------------------------------
movebucketleft:
	push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov bx,[bucketcoor+2]
	sub bx,2
	cmp bx,6
	jl movebucketleftexit



	mov ax,0xb800
	mov es,ax


	push word [bucketcoor]	;x
	push word [bucketcoor+2]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x70	;cyan
	mov al,0x20

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax

	sub word [bucketcoor+2],2
	;cmp word [bucketcoor+2],6
	;jl movebucketleftexit
	call bucket
movebucketleftexit:	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret

movebucketright:
		push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov bx,[bucketcoor+2]
	add bx,2
	cmp bx,71
	ja movebucketrightexit

	mov ax,0xb800
	mov es,ax


	push word [bucketcoor]	;x
	push word [bucketcoor+2]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x70	;cyan
	mov al,0x20

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,6
	mov [es:di],ax

	sub di,6
	add di,160

	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax
	add di,2
	mov [es:di],ax

	add word [bucketcoor+2],2
	call bucket
movebucketrightexit:	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret

;---------------bomb---------------------------------
bomb: push bp
	mov bp,sp
	sub sp,2
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ax,0xb800
	mov es,ax


	push word [bp+6]	;x
	push word [bp+4]	;y
	call locgen
	mov [bp-2],ax	;di
	mov di,ax
	mov cx,3

	mov ah,0x44	;30
	mov al,' '

 rep	stosw

	mov di,[bp-2]
	add di,160
	mov ah,0xEE
	mov cx,3

  rep	stosw

	mov di,[bp-2]
	add di,320
	mov ah,0x44
	mov cx,3
  rep	stosw
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	mov sp,bp
	pop bp
	ret 4	;x y co


;---------------------------------------------------------------
stprint:
	push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di



	;setting bg
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	mov ah,[bg]
	mov al,0x20
	mov di,0
	cld
  rep	stosw	;background set


	;print 1st line
	push ds
	mov si,gname
	push si
	call strlen
	mov cx,ax	;len in cx


	push word [gnamecor];x
	push word [gnamecor+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x87
	mov si,gname
nameloop: lodsb
	 stosw
	 loop nameloop 

	;border start line


	push word [block1cor];x
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ax,[block1]
	mov cx,72
  rep   stosw


	;2nd line of border
	mov dx,[block1cor]
	mov si,3
bb1print: 
	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,2
	mov ax,[block1]
	rep stosw

	push dx
	mov bx,74
	push bx
	call locgen
	mov di,ax
	mov cx,2
	mov ax,[block1]
	rep stosw

	dec si
	jnz bb1print


	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ax,[block1]
	mov cx,72
  rep   stosw

;;;;;;;;;;small border print
	mov si,16
	;mov dx,[block1cor]
bbprint: 
	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,2
	mov ax,[block1]
	rep stosw

	push dx
	mov bx,74
	push bx
	call locgen
	mov di,ax
	mov cx,2
	mov ax,[block1]
	rep stosw

	dec si
	jnz bbprint

	;border endline	
	add dx,1
	push dx
	push word [block1cor+2];y
	call locgen
	mov di,ax	;loc in di
	mov cx,72
	mov ax,[block1]
	rep stosw
	;;;;;;;;;;;;;;

	;scoreline

	push ds
	mov si,scoreline
	push si
	call strlen
	mov cx,ax	;len in cx
	
	push word [scorelinecor]
	;mov bx,10
	push word [scorelinecor+2]
	;push 30
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x07
	mov si,scoreline
scorelineloop:  lodsb
	 stosw
	 loop scorelineloop
	;;;;;;;;;;

	;scoreeee
	call printscore
	;;;;;;;;;;;

	;time line

	push ds
	mov si,timeline
	push si
	call strlen
	mov cx,ax	;len in cx
	
	push word [timelinecor]
	;mov bx,
	push word [timelinecor+2]
	;push 30
	call locgen
	mov di,ax	;loc in di


	mov ax,0xb800
	mov es,ax
	mov ah,0x07
	mov si,timeline
timelineloop:  lodsb
	 stosw
	 loop timelineloop
	;;;;;;;;;
	
	;time

	call printitme

;	-----------------

	push word 14
	push word 9
	call point5obj

	push word 8
	push word 21
	call point10obj

	push word 7
	push word 71	
	call point15obj

	push word 72
	push word 10	
	call bomb

;------------------------
	push word 13
	push word 22
	call point5obj

	push word 9
	push word 54
	call point10obj

	push word 15
	push word 32	
	call point15obj

	push word 13
	push word 54
	call bomb



	;push word 20
	;push word 40
	call bucket
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 

;-----------------TIMER ISR MODIFIED--------------------------------	

timerfunc: 
	inc word [counterforobjgen]
	cmp word [counterforobjgen],900
	jne nextinc
	mov word [counterforobjgen],1
nextinc: inc word [counterfornewobj]
	inc word [counterforscroll]
	cmp word [counterforscroll],9	;after half second
	jne fornewobj
	call scrolldown
	mov word [counterforscroll],0

fornewobj: cmp word [counterfornewobj],9
	jne fortimer
	call randobjgen
	mov word [counterfornewobj],0

fortimer:	inc word [countfortime]
	cmp word [countfortime],18
	jne timerfuncl1
	dec word [time]
	mov word [countfortime],0
	cmp word [time],0
	jge timerfuncl1
	jmp far[cs:endofgame]
;nextcheckfortimer cmp word [time],120
;	jle infl1
	;call stprint
	;call printitme

timerfuncl1: call printitme
	 jmp far [cs:timeisr]

;--------------------TIMER PRINTING----------------------------	

printitme: push ax
	push bx 
	push cx 
	push dx
	push es 
	push di


	mov ax,[time]
	mov cx,0
	mov bx,10
	
timeintlooop1: mov dx,0
	div bx
	add dl,0x30
	push dx
	inc cx
	cmp ax,0
	jne timeintlooop1

	mov ax,0xb800
	mov es,ax
	
	push word [timecor]
	push word [timecor+2]
	call locgen
	mov di,ax

	cmp word [time],10
	jae nextcmptime
	add di,2
	mov bx,0x7020
	mov [es:di],bx
	add di,2
	mov [es:di],bx
	mov di,ax
	jmp timelooop1
nextcmptime: cmp word[time],100
	jae timelooop1
	add di,4
	mov bx,0x7020
	mov [es:di],bx
	mov di,ax

timelooop1: pop dx
	mov dh,0x07
	mov [es:di],dx
	add di,2
	loop timelooop1

	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;-----------------------------------------------------------


;--------------------SCORE PRINTING----------------------------	
printscore: push ax
	push bx 
	push cx 
	push dx
	push es 
	push di

	mov ax,[score]
	mov cx,0
	mov bx,10

	scoreintloop: mov dx,0
	div bx
	add dl,0x30
	push dx
	inc cx
	cmp ax,0
	jne scoreintloop

	mov ax,0xb800
	mov es,ax
	
	push word [scorecor]
	push word [scorecor+2]
	call locgen
	mov di,ax

scoreloop: pop dx
	mov dh,0x07
	mov [es:di],dx
	add di,2
	loop scoreloop

	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;-----------------------------------------------------------	



;--------------------INT 9 NEW ISR-------------------------
int9newisr: push ax
	 push es
	 mov ax, 0xb800
	 mov es, ax 
	 in al, 0x60 
	 cmp al, 0x4b 
	 jne nextcmp 
	 call movebucketleft 
	 jmp nomatch 
nextcmp: cmp al, 0x4d 
	 jne nomatch 
	 call movebucketright 
nomatch: 
	 pop es
	 pop ax
	 jmp far [cs:int9isr] ; call the original ISR

;-----------------------------------------------------------	

;--------------------OBJECT DOWN MOVEMENT-------------------------

scrolldown:push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push ds

	;comparision idr kia hai
	mov ax,[bucketcoor]
	sub ax,1
	push ax
	push word [bucketcoor+2]
	call locgen
	mov di,ax
	mov dx,di	;saved di
	mov ax,0xb800
	mov es,ax

	mov cx,4	;eq to no of cols of bucket
	mov bx,0x4420
cmpbomb: cmp [es:di],bx
	jne nxtitrbmb
	jmp far [cs:endofgame]
nxtitrbmb: add di,2
	loop cmpbomb

	mov di,dx
	mov bh,0x7A
	mov bl,'*'
	mov cx,4
cmp5obj: cmp [es:di],bx
	jne nxtitr5obj
	add word [score],5
	inc word [gobj]
	jmp realprocess
nxtitr5obj: add di,2
	loop cmp5obj	

	mov di,dx
	mov bh,0x79
	mov bl,'*'
	mov cx,4
cmp10obj: cmp [es:di],bx
	jne nxtitr10obj
	add word [score],10
	inc word [bobj]
	jmp realprocess
nxtitr10obj: add di,2
	loop cmp10obj


	mov di,dx
	mov bh,0x7C
	mov bl,'*'
	mov cx,4
cmp15obj: cmp [es:di],bx
	jne nxtitr15obj
	add word [score],15
	inc word [robj]
	jmp realprocess
nxtitr15obj: add di,2
	loop cmp15obj


realprocess:	mov ax,0xb800
	mov es,ax
	mov ds,ax

	push word 22
	push word 73
	call locgen
	mov di,ax
	push word 21
	push word 73
	call locgen
	mov si,ax

	std
	mov bx,15
movingdown:	
	mov cx,68
	rep movsw
	sub si,24
	sub di,24
	sub bx,1
	jnz movingdown

	pop ds
	cld
	mov cx,68
	push word 7
	push word 6
	call locgen
	mov di,ax
	mov ax,0x7020
	rep stosw

	call bucket
	call printscore

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret
;-----------------------------------------------------------	
;--------------------RANDOM OBJ GENERATOR-------------------------

randobjgen:push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push ds

	
	mov ax,[counterforobjgen]
	mov bl,7
	div bl
	cmp ah,0
	jne chkfor5obj
	call randgen
	push 7
	push dx
	call bomb
	jmp objgenfinish

chkfor5obj: mov ax,[counterforobjgen]
	mov bl,11
	div bl
	cmp ah,0
	jne chkfor10obj
	call randgen
	push 7
	push dx
	call point5obj
	jmp objgenfinish

chkfor10obj: mov ax,[counterforobjgen]
	mov bl,13
	div bl
	cmp ah,0
	jne chkfor15obj
	call randgen
	push 7
	push dx
	call point10obj
	jmp objgenfinish

chkfor15obj: mov ax,[counterforobjgen]
	mov bl,17
	div bl
	cmp ah,0
	jne objgenfinish
	call randgen
	push 7
	push dx
	call point15obj
objgenfinish:	pop ds
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 
;-----------------------------------------------------------	


;--------------------RANDOM NUM GENERATOR-------------------------


randgen:push bp
	mov bp,sp
	push es
	push ax
	push bx
	push cx
	;push dx
	push si
	push di
	push ds
	
	mov ax,0xb800
	mov es,ax
	mov ah,0h
	int 0x1A
	;mov dx,cx	;rand num in dx
	;mov cx,dx
	mov ax,dx
	mov dx,0
	;mov ax,12
	;mov dx,[counterforobjgen]
genagain: mov bx,72
	div bx
	cmp dx,71
	ja genagain
	cmp dx,6
	jl genagain
	;next compare
	mov si,3
	push 7
	push dx		;col
	call locgen
	mov di,ax
nextdimain:	mov cx,3
nextdi:	cmp word [es:di],0x7020
	jne genagain
	add di,2
	loop nextdi
	sub di,6
	add di,160	;next line
	dec si
	jnz nextdimain

	pop ds
	pop di
	pop si
	;pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 
;-----------------------------------------------------------	

start:
	call startprint
waitforenter: mov ah,0
	int 16h
	cmp al,13
	jne waitforenter
	xor ax,ax
	mov es,ax
	;----------TIMER ISR---------------------
	mov ax,[es:8*4]
	mov [timeisr],ax
	mov ax,[es:8*4+2]
	mov [timeisr+2],ax
	cli
	mov word [es:8*4],timerfunc
	mov [es:8*4+2],cs
	sti
	;----------INT 9 ISR---------------
	mov ax, [es:9*4]
 	mov [int9isr], ax ; save offset of old routine
 	mov ax, [es:9*4+2]
 	mov [int9isr+2], ax ; save segment of old routine
 	cli ; disable interrupts
 	mov word [es:9*4], int9newisr ; store offset at n*4
 	mov [es:9*4+2], cs ; store segment at n*4+2
 	sti

	call stprint

	;-------end of file offset segment saving------------
	mov word [endofgame],endit
	mov [endofgame+2],cs
	;---------------------------------

infinite: jmp infinite

;---------------UNHOOK TIMER------------------
endit:	xor ax,ax
	mov es,ax
	mov ax, [timeisr] ; read old offset in ax
	 mov bx, [timeisr+2] ; read old segment in bx
	 cli ; disable interrupts
	 mov [es:8*4], ax ; restore old offset from ax
	 mov [es:8*4+2], bx ; restore old segment from bx
	 sti
;---------------UNHOOK INT9------------------
	 mov ax, [int9isr] ; read old offset in ax
	 mov bx, [int9isr+2] ; read old segment in bx
	 cli ; disable interrupts
	 mov [es:9*4], ax ; restore old offset from ax
	 mov [es:9*4+2], bx ; restore old segment from bx
	 sti
;----------------------------------------------
	call endprint




	mov ax,0x4c00
	int 21h