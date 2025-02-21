/*
    Read a single byte from a file
*/

.section .text
.global getc
.type getc, @function

getc: # getc(fd)
    READ    %rdi, -8(%rsp), $1
    testq   %rax, %rax
    cmovns  -8(%rsp), %rax
    ret
