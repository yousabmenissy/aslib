/*
    Subtract 2 decimal values
*/

.section .text
.global dsub
.type dsub, @function
dsub: # dsub(xmm0, xmm1)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    pushq  %rbx

    movq    $10, %rdi
    pextrq  $0, %xmm0, -8(%rbp)
    pextrq  $1, %xmm0, -16(%rbp)
    pextrq  $0, %xmm1, -24(%rbp)
    pextrq  $1, %xmm1, -32(%rbp)

    movq   -24(%rbp), %rax
    movq   -32(%rbp), %rbx
    movq   -8(%rbp), %rsi
    movq   -16(%rbp), %rcx
    cmpq   %rbx, %rcx
    je     1f
    cmovs  -8(%rbp), %rax
    cmovs  -16(%rbp), %rbx
    cmovs  -24(%rbp), %rsi
    cmovs  -32(%rbp), %rcx

    .LPDSUB0:
    imul  %rdi
    incq  %rbx
    cmpq  %rbx, %rcx
    jne   .LPDSUB0

    1:
    movq    -32(%rbp), %rdi
    cmpq    -16(%rbp), %rdi
    js      1f
    subq    %rax, %rsi
    pinsrq  $0, %rsi, %xmm0
    jmp     2f

    1:
    subq    %rsi, %rax
    pinsrq  $0, %rax, %xmm0

    2:
    pinsrq  $1, %rcx, %xmm0
    popq    %rbx

    leave
    ret

.macro DSUB xmm1=%xmm1, xmm0=%xmm0
    movaps  \xmm0, %xmm0
    movaps  \xmm1, %xmm1
    call    dsub
.endm
