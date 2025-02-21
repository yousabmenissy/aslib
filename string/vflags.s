/*
    Similar to flags but accepts multiple names for the same flag
*/

.section .text
.global vflags
.type vflags, @function
vflags: # vflags(flags, argv)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    movq  %rdi, %r10
    movq  $1, -8(%rbp)
    movq  %r10, -16(%rbp)
    movq  %rsi, -24(%rbp)
    movq  $-1, -32(%rbp)

    movq  $-1, %rcx

    .LPVFLAGS0:
    movq  -16(%rbp), %r10

    incq   %rcx
    movq   (%rsi, %rcx, 8), %r8
    cmpq   $0, %r8
    cmove  -32(%rbp), %rax
    je     1f

    movb  (%r8), %al
    cmpb  $'-', %al
    jne   .LPVFLAGS0

    .LPVFLAGS1:
    movq  %r10, %rdi
    cmpq  $0, (%rdi)
    je    .LPVFLAGS0
    call  strlen

    addq   %rax, %r10
    pushq  %rcx
    movq   %r8, %rsi
    movq   %rax, %rdx
    call   strcmp
    popq   %rcx
    movq   -24(%rbp), %rsi
    testq  %rax, %rax
    js     .LPVFLAGS1
    movq   8(%rsi, %rcx, 8), %rax

    1:
    leave
    ret

/*
    ## Usage example ##
    .include "aslib/aslib.s"
    .section .data
    string_flags: 
    .string "-i"
    .string "-I"
    .string "--input"
    .quad 0   # Important! Don't forget the null
    .section .text
    .global _start
    _start:
    movq    %rsp, %rbp
    movq    %rbp, %rbx
    addq    $8, %rbx
    leaq    string_flags(%rip), %rdi
    movq    %rbx, %rsi
    call    vflagb
    testq   %rax, %rax
    js      error_section
*/
