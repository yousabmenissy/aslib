/*
    Convert a decimal value into a string
*/

.section .text
.global dtoa
.type dtoa, @function

dtoa: # dtoa(xmm0, buff)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp
    pushq  %rbx

    movq    $-1, -16(%rbp)
    pextrq  $0, %xmm0, %rax
    pextrq  $1, %xmm0, %rbx
    movq    %rax, -8(%rbp)
    testq   %rax, %rax
    jns     1f
    imulq   -16(%rbp)

    1:
    xor   %rcx, %rcx
    xor   %rdx, %rdx
    movq  $10, %r8

    .LPITOD0:
    cqo
    div    %r8
    addq   $'0', %rdx
    pushq  %rdx
    incq   %rcx
    decq   %rbx

    cmpq   $0, %rbx
    jne    1f
    pushq  $'.'
    incq   %rcx

    1:
    testq  %rbx, %rbx
    jns    .LPITOD0
    cmpq   $0, %rax
    jne    .LPITOD0

    movq   -8(%rbp), %rax
    testq  %rax, %rax
    jns    1f
    pushq  $'-'
    incq   %rcx

    1:
    xor   %rax, %rax
    movq  %rcx, %r10
    movq  $0, %rcx

    .LPITOD1:
    popq  %rax
    movb  %al, (%rdi, %rcx)
    addq  $1, %rcx

    cmpq  %rcx, %r10
    jne   .LPITOD1

    movq  $0, %rax          # The null character
    movb  %al, (%rdi, %rcx)
    addq  $1, %rcx

    movq  %rcx, %rax
    leave
    ret
