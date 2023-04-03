.MODEL FLAT, C
.CODE

PUBLIC C dop_func
dop_func PROC C intervals: dword, n_int: dword, units: dword, n_units: dword, x_min: dword, sum_int: dword
	mov esi, intervals
	mov edi, sum_int
	mov ecx, n_int

start_loop:
	mov eax, [esi]
	add esi, 4h
	mov ebx, [esi]
	sub ebx, eax
	sub eax, x_min

	
	cmp ebx, 0
	jg fix
	add edi, 4h
	jmp fix_2
	fix:
	cmp eax, 0
	jge to_units
	mov ebx, [esi]
	sub ebx, x_min
	mov eax, 0h
	


	to_units:
		push ecx
		push esi
	
		mov ecx, ebx
		mov ebx, 0h
		mov esi, units

	start_loop2:
		push ecx 
		mov ecx, [esi + eax*4]
		start_loop3:
			add ebx, x_min
			add ebx, eax
			loop start_loop3
		pop ecx
		add eax, 1
		loop start_loop2
	    mov [edi], ebx
	    add edi, 4h

	pop esi
	pop ecx

	fix_2:

	loop start_loop
	
	sub edi, 4h
	mov esi, units

	mov ebx, [esi + eax*4]
	add [edi], ebx
ret
dop_func ENDP
END
