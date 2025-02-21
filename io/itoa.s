/*
    convert int into string
*/

.section .text
.global itoa
.type itoa, @function

itoa: # itoa(int, buff)
    movq  %rdi, %r9

    testq  %rdi, %rdi
    jns    1f

    movq   %rdi, %rax
    movq   $-1, %r9
    imulq  %r9
    movq   %rax, %r9

    1:
    xor   %rcx, %rcx
    xor   %rdx, %rdx
    movq  $10, %r8
    movq  %r9, %rax

    .LPITOA0:
    cqo
    div    %r8
    addq   $'0', %rdx
    pushq  %rdx
    incq   %rcx

    cmpq  $0, %rax
    jne   .LPITOA0

    testq  %rdi, %rdi
    jns    1f
    pushq  $'-'
    incq   %rcx

    1:
    xor   %rax, %rax
    movq  %rcx, %r10
    movq  $0, %rcx

    .LPITOA1:
    popq  %rax
    movb  %al, (%rsi, %rcx)
    addq  $1, %rcx

    cmpq  %rcx, %r10
    jne   .LPITOA1

    movq  $0, %rax          # The null character
    movb  %al, (%rsi, %rcx)
    addq  $1, %rcx

    movq  %rcx, %rax
    ret
