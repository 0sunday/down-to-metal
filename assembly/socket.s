# Socket creation + bind
# Assemble: as -msyntax=intel -mnaked-reg socket.s -o socket.o
# Link: ld socket.o -o socket

.intel_syntax noprefix

.section .data
addr:
    .word 2         # AF_INET
    .word 0x5000    # port 80 (network byte order)
    .long 0         # 0.0.0.0 (any address)
    .quad 0         # padding

.section .text
.global _start

_start:
    # socket(AF_INET, SOCK_STREAM, 0)
    # syscall 41
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    mov rdx, 0
    syscall
    
    # Save socket fd
    mov r12, rax
    
    # bind(sockfd, &addr, 16)
    # syscall 49
    mov rax, 49
    mov rdi, r12
    lea rsi, [addr]
    mov rdx, 16
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
