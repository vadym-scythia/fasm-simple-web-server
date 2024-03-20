format ELF64
public _start

; constants names and values for the sys calls functions. Those values are predefined in Linux

socket = 41
bind = 49
listen = 50
accept = 43
read = 0
write = 1
open = 2
exit = 60
close = 3
af_inet = 2
sock_stream = 1
o_rdonly = 0

; Main function. This is actually executable code

section '.text' executable
_start:
mov rdi, af_inet ; pushing (moving) needed by convention values to registers, preparing them to the system call. 
mov rsi, sock_stream ; mov is instruction. rdi, rsi, rdx, rax are registers. sock_stream is value to move to the register.
mov rdx, 0
mov rax, socket
syscall ; system call

mov r12, rax
mov rdi, r12
mov rsi, address
mov rdx, 16
mov rax, bind
syscall

mov rdi, r12
mov rsi, 10
mov rax, listen
syscall

accept_loop: ; label so we can return to it with a jump instruction and make a cycle (like while, for, etc)

mov rdi, r12
mov rsi, 0
mov rdx, 0
mov rax, accept
syscall

mov r13, rax
mov rdi, r13
mov rsi, buffer
mov rdx, 256
mov rax, read
syscall

mov rdi, path
mov rsi, o_rdonly
mov rax, open
syscall

mov r14, rax

mov rdi, rax
mov rsi, buffer2
mov rdx, 256
mov rax, read
syscall

mov rdi, r13
mov rsi, buffer2
mov rdx, 256
mov rax, write
syscall

mov rdi, r13
mov rax, close
syscall

mov rdi, r14
mov rax, close
syscall

jmp accept_loop ; jump instruction to make a cycle

mov rdi, 0
mov rax, exit
syscall

; data structures we are using in our program
section '.data' writeable
address: ; structure named address
dw af_inet ; dw is a data type, means Define Word. 2 bytes
dw 0x901f ; hardcoded port 8080 in hexadecimal and written backwards because of the convention. If you want to change the port you app is listening to: choose port, convert in to hex, change first 2 bytes with last 2 bytes, put here starting from 0x
dd 0
dq 0
buffer: ; buffer with request data
db 256 dup 0 ; db - Define Byte. 8 bits
buffer2: ; buffer with response data
db 256 dup 0
path: ; path to the HTML file we are serving to the clients
db 'index.html', 0