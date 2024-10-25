[org 0x7c00]
mov bx, variablename

printString:
	mov al, [bx]
	cmp al, 0
	je stack
	mov ah, 0x0e
	int 0x10
	inc bx
	jmp printString

variablename:
	db "PhoenixOS V0.1.0 (The Rebrand)", 0x0a, 0x0d, "Compiled at 15:28 on 25/10/24", 0x0a, 0x0d, 0
	
stack:
	mov bp, 0x8000
	mov sp, bp
	mov bh, 'A'
	push bx
	mov bh, 'B'
	mov ah, 0x0e
	mov al, bh
	int 0x10
	pop bx
	mov ah, 0x0e
	mov al, bh
	int 0x10
	jmp input
	
input:
	mov ah, 0
	int 0x16
	mov ah, 0x0e
	cmp al, 8
	jne type
	cmp al, 0x7F00
	je print
	jne backspace
	
type:
	int 0x10
	cmp al, 13
	je enter
	jne save
	
backspace:
	int 0x10
	mov al,' '
	int 0x10
	mov al, 8
	int 0x10
	mov al, 0
	dec bx
	jmp save
	
enter:
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	jmp save
	
save:
	mov bx, [buffer]
	mov [bx], al
	inc bx
	jmp input

print:
	pusha
	mov bx, testgood
	jmp printString
	popa
	jmp input
	
testgood:
	db "Test Succesful", 0x0a, 0x0d, 0
	
buffer:
 times 10 db 0
	
times 510-($-$$) db 0
db 0x55, 0xaa