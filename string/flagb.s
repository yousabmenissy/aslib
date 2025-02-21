/*
    Find whether boolean flag is present
*/

.section .text
.global flagb
.type flagb, @function
flagb: # flagb(flag, argv, len)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $48, %rsp

    movq  %rdi, -16(%rbp)
    movq  %rsi, -24(%rbp)
    movq  %rdx, -32(%rbp)
    movq  $-1, -40(%rbp)

    movq  $-1, %rcx

    .LPFLAGB0:
    incq   %rcx
    movq   (%rsi, %rcx, 8), %r8
    cmpq   $0, %r8
    cmove  -40(%rbp), %rax
    je     1f

    movb  (%r8), %al
    cmpb  $'-', %al
    jne   .LPFLAGB0

    pushq  %rcx
    movq   %r8, %rsi
    movq   -16(%rbp), %rdi
    movq   -32(%rbp), %rdx
    call   strcmp
    popq   %rcx
    movq   -24(%rbp), %rsi

    testq  %rax, %rax
    js     .LPFLAGB0
    movq   $0, %rax

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

