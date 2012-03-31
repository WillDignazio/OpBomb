;; So long and thanks for the fish.
[BITS 16]
[ORG 0x7C00]

start:
  mov ah, 0 
  mov al, 3
  int 10h

  mov si, opbomb
  call printxt

  mov al, 1
  call print

  mov al, 182
  out 43h, al
  mov ax, 4560 ; Freq. for middle c
  out 42h, al   ; low byte
  mov al, ah    ; high byte
  out 42h, al   ; 
  in al, 61h    ; TUrn on note
  or al, 00000011b  ; Pause
.pause1: 
  mov cx, 65535
.pause2: 
  dec cx
  jne .pause2
  dec bx
  jne .pause1
  in al, 61h ; turn off note
  and al, 11111100b
  out 61h, al
  
  jmp $

;; Print Text
;;	- print a series of charaters, a string or text, to the terminal.
;; 	- move the address of the text to si
;; 	- The first character must be startoftext char (STX)
;; 	- The final character must be endoftext char (ETX)
printxt:
  mov al, [si]		
  cmp al, 02h			; Compare to STX
  jne .error

 .print:
  inc si				; next character
  mov al, [si]		
  cmp al, 03h
  je .done
  call print		
  jmp .print
 .done:		
  ret

 .error: 
  mov si, notxt
  call printxt
  ret


;; Print Character 
;; 	- print a single character to the terminal 
;; 	- move single character scancod to AL
print:
  mov ah, 0Eh			; Write Character and attribute at cursor position
  mov bh, 0				; page number 
  mov bl, 07h			; color (white)
  int 10h
  ret			

opbomb  db  0x02, 'Property of OpComm', 0x0A, 0x0D, 0x03
notxt   db  0x02, 'woops', 0x0A, 0x0D, 0x03

times 510-($-$$) db 0
dw 0xaa55
