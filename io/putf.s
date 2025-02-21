/*
    Convert a float into string and write it to file
*/

.section .text
.global putf
.type putf, @function

putf: # putf(double, fd, points)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $48, %rsp
    movq   %rdi, -48(%rbp)

    leaq  -40(%rbp), %rdi
    call  ftoa

    WRITE  -48(%rbp), -40(%rbp), %rax
    leave
    ret

