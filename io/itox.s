/*
    convert int into string with any base between 2-16.
*/

.section .text
.global itox
.type itox, @function

itox: # itox(quad, buffer, base)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    movq   $0x3736353433323130, %rax # 7-0
    movq   %rax, -32(%rbp)
    movq   $0x4645444342413938, %rax # F-8
    movq   %rax, -24(%rbp)

    movq  $-1, %r8

    cmpq   $2, %rdx
    cmovl  %r8, %rax
    jl     1f
    cmpq   $16, %rdx
    cmova  %r8, %rax
    ja     1f

    movq  %rdx, %r8
    movq  %rdi, %rax
    xor   %rcx, %rcx

    .LPITOX0:
    xor    %rdx, %rdx
    div    %r8
    movb   -32(%rbp, %rdx), %dl
    pushq  %rdx
    incq   %rcx

    cmpq  $0, %rax
    jne   .LPITOX0

    xor   %rax, %rax
    movq  %rcx, %r8
    movq  $0, %rcx

    .LPITOX1:
    popq  %rax
    movb  %al, (%rsi, %rcx)
    incq  %rcx
    cmpq  %rcx, %r8
    jne   .LPITOX1

    movq  $0, %rax          # The null character
    incq  %rcx
    movb  %al, (%rsi, %rcx)

    movq  %rcx, %rax

    1:
    leave
    ret
