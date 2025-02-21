/*
    Convert an int into string and write it to file
*/

.section .text
.global puti
.type puti, @function

puti: # puti(fd, int)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    movq   %rdi, -32(%rbp)

    movq  %rsi, %rdi
    leaq  -24(%rbp), %rsi
    call  itoa

    WRITE  -32(%rbp), -24(%rbp), %rax
    leave
    ret
