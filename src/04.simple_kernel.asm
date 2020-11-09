org 0x8000
  
; 비디오 메모리 설정
mov ax, 0xB800
mov es, ax
  
; HI 출력
mov ah, 0x09
mov al, 'H'
mov [es:0000], ax
mov al, 'I'
mov [es:0002], ax
  
; 무한루프
jmp $
  
; 꼭 필요한건 아니지만 qemu가 512바이트의 배수 단위로만 읽기 때문에 512바이트로 설정.
times 512-($-$$) db 0x00