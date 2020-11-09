; 프로그램 시작주소 설정
; 주소접근을 편리하게 하기 위함
org	0x7C00   
   
; 비디오 메모리 설정
; 0xB800는 비디오 메모리 주소(텍스트 출력용)
mov ax, 0xB800
mov	es, ax

;배경 지우기
mov ax, [Background]
mov bx, 0
mov cx, 80*25*2
CLS:
    mov [es:bx], ax
    add bx, 1
    loop CLS

; 글자 색 설정
mov	ah, 0x04

; 글자 H 출력
mov	al, 'H'
mov	[es:0000], ax

; 글자 i 출력
mov	al, 'i'
mov	[es:0002], ax

; 무한루프
jmp	$
   
; 부트로더 기본 종결사
times 510-($-$$) db 0x00
dw 0xaa55
