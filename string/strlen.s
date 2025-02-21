/*
    Calculate the length of a string including the null terminator
*/

.section .text
.globl strlen
.type strlen, @function
strlen:
# strlen(str)
    movq  %rdi, %rsi

    movb   $0, %al
    pushq  %rcx
    movq   $-1, %rcx
    repne  scasb
    popq   %rcx
    subq   %rsi, %rdi
    movq   %rdi, %rax
    movq   %rsi, %rdi

    ret
