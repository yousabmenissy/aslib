/*
    Write a single character into file
*/

.section .text
.global putc
.type putc, @function
putc: # putc(fd, char)
    movb   %sil, -8(%rsp)
    WRITE  %rdi, -8(%rsp), $1
    ret
