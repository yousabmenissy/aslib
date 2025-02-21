/*
    Add 2 decimal values
*/

.section .text
.global dadd
.type dadd, @function
dadd: # dadd(xmm0, xmm1)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    pushq  %rbx

    movq    $10, %rdi
    pextrq  $0, %xmm0, -8(%rbp)
    pextrq  $1, %xmm0, -16(%rbp)
    pextrq  $0, %xmm1, -24(%rbp)
    pextrq  $1, %xmm1, -32(%rbp)

    movq  -24(%rbp), %rax
    movq  -32(%rbp), %rbx
    movq  -8(%rbp), %rsi
    movq  -16(%rbp), %rcx

    cmpq   %rbx, %rcx
    je     1f
    cmovs  -8(%rbp), %rax
    cmovs  -16(%rbp), %rbx
    cmovs  -24(%rbp), %rsi
    cmovs  -32(%rbp), %rcx

    .LPDADD0:
    imul  %rdi
    incq  %rbx
    cmpq  %rbx, %rcx
    jne   .LPDADD0

    1:
    addq    %rsi, %rax
    pinsrq  $0, %rax, %xmm0
    pinsrq  $1, %rcx, %xmm0

    popq  %rbx
    leave
    ret

.macro DADD xmm0=%xmm0, xmm1=%xmm1
    movaps  \xmm0, %xmm0
    movaps  \xmm1, %xmm1
    call    dadd
.endm
