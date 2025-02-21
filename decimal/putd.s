/*
    Write a decimal to fd
*/

.section .text
.global putd
.type putd, @function
putd: # putd(xmm0, fd)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    pushq  %rdi
    leaq   -32(%rbp), %rdi
    call   dtoa

    popq   %rdi
    WRITE  %rdi, -32(%rbp), %rax
    leave
    ret

.macro PUTD fd=%rdi, xmm0=%xmm0
    movq    \fd, %rdi
    movaps  \xmm0, %xmm0
    call    putd
.endm
