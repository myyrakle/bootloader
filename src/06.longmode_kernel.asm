org 0x8000
 
; 밑의 :gdtr 레이블을 GDT로 등록
xor ax, ax
lgdt [gdtr]  ; gdt 로드 명령

cli ; 인터럽트 막음. 전환중에 인터럽트가 걸리면 죽을수도 있음.

; 32비트 보호모드 스위치 
mov eax, cr0
or eax, 1
mov cr0, eax

; 파이프라이닝으로 남아있을 수 있는 16비트 크기의 명령어 정리
jmp $+2
nop
nop

; 64비트 서브모드 스위치 
mov eax, cr0
or eax, 1<<31
mov cr0, eax

mov eax, cr4
or eax, 1<<5
mov cr4, eax

mov eax, efer
or eax, 1<<8
mov efer, eax

lgdt [gdtr64]  ; gdt 로드 명령
 
; 실질적인 로직인 Entry64 부분으로 점프 
jmp codeDescriptor:Entry64
 
; 64비트 엔트리
[bits 64]
Entry64:
    ; 세그먼트 레지스터 초기화
    mov bx, dataDescriptor
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx
    xor esp, esp
    mov esp, 0x9FFFF
 
    ; es 레지스터에 비디오 디스크립터 저장
    mov ax, videoDescriptor
    mov es, ax
 
    ; 문자 출력
    mov ah, 0x09; 색깔
    mov al, 'P'
    mov [es:0x0000], ax
    mov al, 'R'
    mov [es:0x0002], ax
    mov al, 'O'
    mov [es:0x0004], ax
    mov al, 'T'
    mov [es:0x0006], ax
    mov al, 'E'
    mov [es:0x0008], ax
    mov al, 'C'
    mov [es:0x000A], ax
    mov al, 'T'
    mov [es:0x000C], ax
 
    jmp $


; GDT 정의
gdtr:
    dw gdt_end - gdt - 1 ; GDT의 limit
    dd gdt ; GDT의 베이스 어드레스
gdt:
; NULL 디스크립터
nullDescriptor  equ $-gdt
    dw 0
    dw 0
    db 0
    db 0
    db 0
    db 0
; 코드 디스크립터
codeDescriptor  equ $-gdt
    dw 0xFFFF  ; limit:0xFFFF
    dw 0x0000  ; base 0~15 : 0
    db 0x00    ; base 16~23: 0
    db 0x9A    ; P:1, DPL:0, Code, non-conforming, readable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
; 데이터 디스크립터
dataDescriptor  equ $-gdt
    dw 0xFFFF  ; limit 0xFFFF
    dw 0x0000  ; base 0~15 : 0
    db 0x00    ; base 16~23: 0
    db 0x92    ; P:1, DPL:0, data, readable, writable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
; 비디오 디스크립터
videoDescriptor equ $-gdt
    dw 0xFFFF  ; limit 0xFFFF
    dw 0x8000  ; base 0~15 : 0x8000
    db 0x0B    ; base 16~23: 0x0B
    db 0x92    ; P:1, DPL:0, data, readable, writable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
gdt_end:

; GDT64 정의
gdtr64:
    dw gdt64_end - gdt64 - 1 ; GDT의 limit
    dd gdt64 ; GDT의 베이스 어드레스
gdt64:
; NULL 디스크립터
nullDescriptor64 equ $-gdt64
    dw 0xFFFF
    dw 0
    db 0
    db 0
    db 0
    db 0
; 코드 디스크립터
codeDescriptor64  equ $-gdt64
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10011010b                 ; Access (exec/read).
    db 10101111b                 ; Granularity, 64 bits flag, limit19:16.
    db 0    
; 데이터 디스크립터
dataDescriptor64  equ $-gdt64
    dw 0                         ; Limit (low).
    dw 0                         ; Base (low).
    db 0                         ; Base (middle)
    db 10010010b                 ; Access (read/write).
    db 00000000b                 ; Granularity.
    db 0             
; 비디오 디스크립터
videoDescriptor64 equ $-gdt64
    dw 0xFFFF  ; limit 0xFFFF
    dw 0x8000  ; base 0~15 : 0x8000
    db 0x0B    ; base 16~23: 0x0B
    db 0x92    ; P:1, DPL:0, data, readable, writable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
gdt64_end:

times 512-($-$$) db 0x00
