AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT

a DW 3
b DW 5
i DW 5
k DW 5
i1 DW 5
i2 DW 0
res DW 0

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
    push DS
    sub AX,AX
    push AX
    mov AX,DATA
    mov DS,AX

    mov AX,i
    shl AX,1
    mov DX,AX ;DX = 2*i
    add AX,i ;AX = 3*i
	  neg AX ;AX = -3*i
    mov CX,a
    cmp CX,b
    jg first_path ;a > b
	;i2 =5-3*(i+1) = -3i+2 
    add AX,2 ;AX = -3*i +2
    mov i2,AX
    ;i1 = 3*(i+2)
	  neg AX
    add AX,8
    mov i1,AX
	  jmp f3



first_path:

   ;i1 = -(6*i - 4) = -6*i+4

    shl AX,1
    add AX,4
    mov i1,AX

   ;i2= 2*(i+1)-4 = 2i-2

    sub DX,2
    mov i2,DX

f3: 
	mov AX,i1
	mov BX,i2
module_1:
	neg BX
	js module_1
	mov CX,k
    cmp CX,0
	jl f3_first_path ; K<0

   ;res=max(4,|i2|-3)
   
    sub BX,3
    cmp BX,4
    jg f3_res  ;|i2|-3 > 4

    mov res,4
    jmp stop

f3_res:
    mov res,BX
    
f3_first_path: ;res = |i2|-|i1|
	neg AX
	js f3_first_path
	sub BX,AX
	mov res,BX

stop:
    
    ret
Main ENDP
CODE ENDS
    END Main
