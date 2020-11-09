; 프로그램 시작주소 설정
; 주소접근을 편리하게 하기 위함
org	0x7C00   
   
; 비디오 메모리 설정
; 0xB800는 비디오 메모리 주소(텍스트 출력용)
mov ax, 0xB800
mov	es, ax

;배경 지우기
mov ax, 0x00
mov bx, 0
mov cx, 80*25*2
CLS:
    mov [es:bx], ax
    add bx, 1
    loop CLS

;하드 섹터 읽기
READ:
    ; 커널 주소 로드
    mov ax, 0x0800 
    mov es, ax 
    mov bx, 0
 
    ; 바이오스 콜 명령 인자 설정
    mov ah, 2 ; 읽기 명령
    mov al, 1 ; 읽을 섹터 수
    mov ch, 0 ; 실린더 번호
    mov cl, 2 ; 섹터 번호
    mov dh, 0 ; 헤드 번호
    mov dl, 0x80 ; 드라이브 번호, 0x00=A:, 0x80=C:
 
    ; 바이오스 콜 명령 실행 (커널 소스 읽어옴)
    int 0x13 

    ; 실패해서 carry가 1일 경우 재시도
    jc READ 
  
; 바이오스 콜로 커널이 올라왔으니, 그 위치로 점프
jmp 0x8000
   
; 부트로더 기본 종결사
times 510-($-$$) db 0x00
dw 0xaa55
