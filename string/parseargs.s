/*
    Map argv into memory without the flags
*/

.section .text
.global parseargs
.type parseargs, @function
parseargs: #  parseargs(argc, argv, string_flags, bool_flags)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $64, %rsp

    movq  %rdi, -8(%rbp)      # Does not change
    movq  %rsi, -16(%rbp)     # Does not change
    movq  %rdx, -24(%rbp)     # Does not change
    movq  %rcx, -32(%rbp)     # Does not change
    movq  %rdx, -40(%rbp)
    movq  %rcx, -48(%rbp)

    .LSPARGS0:
    movq  $8, %rcx
    movq  %rdi, %rax
    mulq  %rcx

    subq  %rax, %rsp
    movq  %rsp, %r8

    xor  %rcx, %rcx

    .LPPARGS0:
    movq  (%rsi), %rax
    movq  %rax, (%r8, %rcx, 8)
    incq  %rcx
    addq  $8, %rsi
    cmpq  $0, (%rsi)
    jne   .LPPARGS0

    movq  $-1, %rcx
    .LSPARGS1:
    xor   %rax, %rax
    movq  $-1, %rsi

    incq    %rcx
    cmpq    -8(%rbp), %rcx
    cmovae  %rsi, %rcx
    jae     .LSPARGS2

    movq  (%r8, %rcx, 8), %rsi
    movq  %rsi, -16(%rbp)
    movb  (%rsi), %al
    cmpb  $'-', %al
    jne   .LSPARGS1

    cmpq  $0, -24(%rbp)
    je    1f

    movq  -24(%rbp), %rax
    movq  %rax, -40(%rbp)

    .LPPARGS1:
    xor   %rax, %rax
    movq  -40(%rbp), %rdi
    cmpq  $0, (%rdi)
    je    1f

    pushq  %rdi
    call   strlen
    popq   %rdi
    addq   %rax, -40(%rbp)
    movq   %rax, %rdx

    movq   -16(%rbp), %rsi
    pushq  %rdi
    pushq  %rsi
    pushq  %rcx
    call   strcmp
    popq   %rcx
    popq   %rsi
    popq   %rdi
    testq  %rax, %rax
    js     .LPPARGS1

    movq  $0, (%r8, %rcx, 8)
    incq  %rcx
    movq  $0, (%r8, %rcx, 8)
    jmp   .LSPARGS1

    1:
    movq  -32(%rbp), %rax
    movq  %rax, -48(%rbp)
    .LPPARGS2:
    xor   %rax, %rax

    cmpq  $0, -48(%rbp)
    je    .LSPARGS1
    movq  -48(%rbp), %rdi
    cmpq  $0, (%rdi)
    je    .LSPARGS1

    pushq  %rdi
    call   strlen
    popq   %rdi
    addq   %rax, -48(%rbp)
    movq   %rax, %rdx
    movq   -16(%rbp), %rsi

    pushq  %rdi
    pushq  %rsi
    pushq  %rcx
    call   strcmp
    popq   %rcx
    popq   %rsi
    popq   %rdi

    testq  %rax, %rax
    js     .LPPARGS2

    movq  $0, (%r8, %rcx, 8)
    jmp   .LSPARGS1

    .LSPARGS2:
    movq      %r8, -56(%rbp)
    ANONMMAP  # Anonymous memory mapping
    testq     %rax, %rax
    js        .LSPARGS2

    movq  -56(%rbp), %r8
    movq  %rax, %r9
    movq  $-1, %rcx
    movq  $-1, %rdx

    .LPPARGS3:
    incq  %rcx
    cmpq  -8(%rbp), %rcx
    je    .LSPARGS3

    movq  (%r8, %rcx, 8), %rax
    cmpq  $0, %rax
    je    .LPPARGS3

    incq  %rdx
    movq  %rax, (%r9, %rdx, 8)
    jmp   .LPPARGS3

    .LSPARGS3:
    movq  %r9, %rax

    leave
    ret

/*
    ## Usage example ## 
    .include "aslib/aslib.s"
    .section .data
    string_flags:
    .string "-i"
    .string "--input"
    .string "-o"
    .string "-output"
    .quad 0
    bool_flags:
    .string "-h"
    .string "--help"
    .string "-l"
    .string "-L"
    .string "--list"
    .quad 0
    .section .text
    .global _start
    _start:
    movq    %rsp, %rbp
    movq    %rbp, %rbx
    addq    $8, %rbx 
    movq    (%rbp), %rdi
    movq    %rbx, %rsi
    leaq    string_flags(%rip), %rdx
    leaq    bool_flags(%rip), %rcx
    call    parseargs
    testq   %rax, %rax
    js      error_section
*/
