/*
    Divide 2 decimal values
*/

.section .text
.global ddiv
.type ddiv, @function
ddiv: # ddiv(xmm0, xmm1)
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

    .LPDDIV0:
    imul  %rdi
    incq  %rbx
    cmpq  %rbx, %rcx
    jne   .LPDDIV0

    1:
    movq  -32(%rbp), %rdi
    cmpq  -16(%rbp), %rdi
    jns   1f
    idiv  %rsi
    movq  %rax, -24(%rbp)
    movq  %rdx, -16(%rbp)
    jmp   2f

    1:
    movq  %rax, %rcx
    movq  %rsi, %rax
    idiv  %rcx
    movq  %rax, -24(%rbp)
    movq  %rdx, -16(%rbp)

    2:
    cmpq  $0, %rdx
    je    1f

    pextrq  $0, %xmm0, %rdi
    xor     %rcx, %rcx
    movq    $10, %r8

    .LPDDIV1:
    incq  %rcx
    movq  -16(%rbp), %rax
    imul  %r8
    idiv  %rdi

    movq   %rdx, -16(%rbp)
    pushq  %rax
    movq   -24(%rbp), %rax
    imulq  %r8
    movq   %rax, -24(%rbp)
    popq   %rax
    addq   %rax, -24(%rbp)
    incq   -32(%rbp)

    cmpq  $9, %rcx
    je    1f
    cmpq  $0, -16(%rbp)
    jne   .LPDDIV1

    1:
    pinsrq  $0, -24(%rbp), %xmm0
    pinsrq  $1, -32(%rbp), %xmm0

    popq  %rbx
    leave
    ret

.macro DDIV xmm1=%xmm1, xmm0=%xmm0
    movaps  \xmm0, %xmm0
    movaps  \xmm1, %xmm1
    call    ddiv
.endm
