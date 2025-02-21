/*
    Return the flag value
*/

.section .text
.global flags
.type flags, @function
flags: # flags(flag, argv, len)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $48, %rsp

    movq  $1, -8(%rbp)
    movq  %rdi, -16(%rbp)
    movq  %rsi, -24(%rbp)
    movq  %rdx, -32(%rbp)
    movq  $-1, -40(%rbp)

    movq  $-1, %rcx

    .LPFLAGS0:
    incq   %rcx
    movq   (%rsi, %rcx, 8), %r8
    cmpq   $0, %r8
    cmove  -40(%rbp), %rax
    je     1f

    movb  (%r8), %al
    cmpb  $'-', %al
    jne   .LPFLAGS0

    movq   %r8, %rsi
    movq   -16(%rbp), %rdi
    movq   -32(%rbp), %rdx
    pushq  %rcx
    call   strcmp
    popq   %rcx
    movq   -24(%rbp), %rsi

    testq  %rax, %rax
    js     .LPFLAGS0
    movq   8(%rsi, %rcx, 8), %rax

    1:
    leave
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rdx
    - rcx
    - r8
*/
