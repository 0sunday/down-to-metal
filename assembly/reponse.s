.intel_syntax noprefix
.section .data
addr:
    .word 2         # AF_INET
    .word 0x5000    # port 80 (big endian)
    .long 0         # 0.0.0.0
    .quad 0         # padding 
addrlen: .long 16   # Size of buffer for accept
httpres: .ascii "HTTP/1.0 200 OK\r\n\r\n"
httpres_len = . - httpres    # calculate length

.section .bss
buffer: .space 1024          # buffer for reading HTTP request

.section .text
.global _start
_start:
    # socket(AF_INET, SOCK_STREAM, 0)
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    # save socket fd
    mov r12, rax
   
    # bind(socketfd, &addr, 16)
    mov rax, 49
    mov rdi, r12
    lea rsi, [addr]
    mov rdx, 16
    syscall 
    
    # listen(socketfd, backlog)
    mov rax, 50
    mov rdi, r12
    mov rsi, 0
    syscall
    
    # accept(sockfd, sockaddr, addrlen, flags)
    mov rax, 43
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall
    
    # store clientfd 
    mov r13, rax
    
    # read(clientfd, buffer, 1024)
    mov rax, 0
    mov rdi, r13
    lea rsi, [buffer]
    mov rdx, 1024
    syscall
    
    # send data to connected client
    # use write
    mov rax, 1
    mov rdi, r13    # client's socket
    lea rsi, [httpres]
    mov rdx, httpres_len
    syscall
     
    # close(sockfd) # client connection before socket
    mov rax, 3
    mov rdi, r13
    syscall
    
    # close(sockfd)
    # syscall 3
    mov rax, 3
    mov rdi, r12
    syscall
    
    # exit(0)
    # syscall 60
    mov rax, 60
    xor rdi, rdi
    syscall
