messnumber EQU 5


DATA SEGMENT
	keep_cs dw 0
	keep_ip dw 0
	message DB 'Hello $'
DATA ENDS

AStack SEGMENT STACK
	DW 512 DUP(?)
AStack ENDS


CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack

print_number PROC FAR
	push ax
	push bx
	push dx
	mov ah, 0
	mov bl, 16
	div bl
	add ah, '0'
	add al, '0'
	mov bh, ah
	mov ah, 02h
	mov dl, al
	int 21h
	mov dl, bh
	int 21h
	pop dx
	pop bx
	pop ax
	
	ret

print_number ENDP
	
print_time PROC FAR
	push cx
	push dx
	push ax
	mov ah,02h
	int 1ah
	mov al,ch
	call print_number
	mov dl, ':'
	int 21h
	mov al,cl
	call print_number
	mov dl, ':'
	int 21h
	mov al,dh
	call print_number
	mov dl, ' '
	int 21h
	pop ax
	pop dx
	pop cx
	
	ret
	
print_time ENDP	

SUBR_PRINT PROC FAR
    jmp towork
	ss_int dw 0
	sp_int dw 0
	mes_end_iter DB 'End iter$'
	int_stack dw 20 DUP(?)

	towork:
	mov ss_int, ss
	mov sp_int, sp

	; store registers
	push dx
	push cx
	push bx
	push ax
	push ax

	mov al, 0

	print_message:
		;mov ah, 9
		;mov dx, offset message
		;int 21h
		call print_time

	set_delay:
		pop cx
		dec cl
		jz complete
		push cx

		cmp al, 0
		je first

		shl al, 1
		jmp start

	first:
		add al, 1

	start:
		mov bl, al
		mov  ah, 2ch
		int  21h 
		mov bh, dh		

	delaying:   
		nop
		mov  ah, 2ch
		int  21h 
		cmp dh, bh
		je delaying

		mov  bh, dh      
		dec  bl   
		jnz  delaying  
		jmp print_message


	complete:
		; restore registers
		pop ax
		pop bx
		pop cx
		pop dx

		mov al, 20h
		out 20h, al
	iret

SUBR_PRINT ENDP


Main PROC FAR
    push DS
    sub ax, ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov ax, 3523h
    int 21h
    mov keep_cs, es
    mov keep_ip, bx

    push ds
    mov dx, offset SUBR_PRINT
    mov ax, seg SUBR_PRINT
    mov ds, ax
    mov ax, 2523h
    int 21h
    pop ds
 

	begin:
		mov ah,0
		int 16h
		cmp al, 'q'
		je quit
		cmp al,3
		jnz begin

		mov al, messnumber		
		int 23h	
		jmp begin

	quit:




    cli
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ax, 2523h
    int 21h
    pop ds
    sti
    
    ret
Main ENDP

CODE ENDS
     END Main
