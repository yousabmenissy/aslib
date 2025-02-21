/*
    Similar to flagf but accepts multiple names for the same flag
*/

.section .text
.global vflagf
.type vflagf, @function
vflagf: # vflagf(flags, argv)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    movq   $-1, -8(%rbp)   # flag does not exist
    movq   $-2, -24(%rbp)  # flag is not valid
    call   vflags
    testq  %rax, %rax
    cmove  -8(%rbp), %rax
    js     1f

    movq   %rax, -16(%rbp)
    movq   %rax, %rdi
    movq   $10, %rsi
    call   isbase
    testq  %rax, %rax
    cmove  -24(%rbp), %rax
    js     1f

    movq  -16(%rbp), %rdi
    call  atof

    1:
    leave
    ret
