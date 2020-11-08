; 프로그램 시작주소 설정
; 주소접근을 편리하게 하기 위함
org	0x7C00   
   
;비디오 메모리
mov	ax, 0xB800;
mov	es, ax;
   
;글자를 출력한다
mov	ah, 0x09
mov	al, 'H'
mov	[es:0000], ax
mov	al, 'i'
mov	[es:0002], ax
   
jmp	$
   
times 510-($-$$) db 0x00
dw 0xaa55
