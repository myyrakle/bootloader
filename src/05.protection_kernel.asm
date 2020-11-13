org 0x8000
 
; 밑의 :gdtr 레이블을 GDT로 등록
xor ax, ax
lgdt [gdtr] 
cli
mov eax, cr0
or eax, 1
mov cr0, eax
 
jmp $+2
nop
nop
 
jmp 0x08:Entry32
 
;*********************************************
;   32비트 엔트리
;*********************************************
[bits 32]
Entry32:
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
    mov ax, 0x18
    mov es, ax
 
    ; 문자 출력
    mov ah, 0x09
    mov al, 'P'
    mov [es:0x0000], ax
    mov al, 'r'
    mov [es:0x0002], ax
    mov al, 'o'
    mov [es:0x0004], ax
    mov al, 't'
    mov [es:0x0006], ax
    mov al, 'e'
    mov [es:0x0008], ax
    mov al, 'c'
    mov [es:0x000A], ax
    mov al, 't'
    mov [es:0x000C], ax
 
    jmp $
 
;*********************************************
;   GDT 영역
;*********************************************
gdtr:
    dw gdt_end - gdt - 1   ; GDT의 limit
    dd gdt ; GDT의 베이스 어드레스
gdt:
; NULL 디스크립터
nullDescriptor  equ 0x00
    dw 0
    dw 0
    db 0
    db 0
    db 0
    db 0
; 코드 디스크립터
codeDescriptor  equ 0x08
    dw 0xFFFF  ; limit:0xFFFF
    dw 0x0000  ; base 0~15 : 0
    db 0x00    ; base 16~23: 0
    db 0x9A    ; P:1, DPL:0, Code, non-conforming, readable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
; 데이터 디스크립터
dataDescriptor  equ 0x10
    dw 0xFFFF  ; limit 0xFFFF
    dw 0x0000  ; base 0~15 : 0
    db 0x00    ; base 16~23: 0
    db 0x92    ; P:1, DPL:0, data, readable, writable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
; 비디오 디스크립터
videoDescriptor equ 0x18
    dw 0xFFFF  ; limit 0xFFFF
    dw 0x8000  ; base 0~15 : 0x8000
    db 0x0B    ; base 16~23: 0x0B
    db 0x92    ; P:1, DPL:0, data, readable, writable
    db 0xCF    ; G:1, D:1, limit:0xF
    db 0x00    ; base 24~32: 0
gdt_end:
   
times 512-($-$$) db 0x00