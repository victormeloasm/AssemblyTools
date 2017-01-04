; Desenvolvido por Víctor Duarte Melo em 03/01/2017 ;
; Shutdown.com. Use no MS-DOS como shutdown -s para desligar e shutdown -r para reiniciar. ;
; Compilando é: "tasm /l /zi shutdown.asm ;
; Tlink /t shutdown.obj ;
; ESSE PROGRAMA SÓ RODA NO MS-DOS!!! SE ESTIVER NO WINDOWS 98 COLOQUE PARA REINICIAR EM MODO MS-DOS
; ATENTION: THIS PROGRAM ONLY WORKS ON MS-DOS MODE, IF YOU ARE AT WINDOWS 9.X REBOOT IN MS-DOS MODE BEFORE...
; HOW TO COMPILE: "tasm /l /zi shutdown.asm
; HOW TO LINK: "tlink /t shutdown.obj
; You must have installer TURBO ASSEMBLER at you machine! And it's a .COM file, not .EXE
 
.model tiny ;it's a .COM file
.code
org 100h 
start: jmp begin

msg db 13,10,"Type shutdown -s to shutdown or shutdown -r to reboot MS-DOS.",13,10,'$' ;declare the string of help to msg label

begin proc near
mov dl,ds:[83h] ;Get the parameters for commandline MS-DOS, 82h=-, 83h=r or s, 81h=space and 80h=lenght of the parameter 
cmp  dl,'s' ;compare if 's' 
jz shutdown ;then jump to shutdown instructions
cmp dl,'r' ;compare if 'r'
je reboot ; then jump to reboot instructions
jmp help ;if wrong parameters, show the help message of the use of program, so jump to Help instructions
shutdown: ;code to shutdown the MS-DOS using the interruption 15h, used also for old cassetes
;Connect to APM API
mov ax,5301h
xor bx,bx
int 15h
;Try to set APM version (to 1.2)
mov ax,530Eh
xor bx,bx
mov cx,0102h
int 15h
;Turn off the system
mov ax,5307h
mov bx,0001h
mov cx,0003h
int 15h
;return to MS-DOS if fail
mov ah,4ch
int 21h
reboot: ;reboot instructions
db 0eah 
dw 0000h
dw 0ffffh ;in debugger you probably will see "jmp far ptr 0FFFFh:0" for these HEX codes. 
;If fail return to MS-DOS
mov ah,4ch
int 21h
help:
;loads the msg to dx and using the service 09h of interrupt 21h show the string of help
lea dx,msg
mov ah,09
int 21h
;return to MS-DOS after show the message
mov ah,4ch
int 21h
;end the routines and the program
endp begin
end start
