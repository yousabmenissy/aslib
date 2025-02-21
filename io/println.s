/*
    concatinate a variadic number of strings, append new line and write it to file
    str... are laid out on the stack from last to first with a null to indicate the end
*/

.section .text
.global println
.type println, @function
println: # println(fd, str...)
    pushq  %rbp
    movq   %rsp, %rbp

    pushq  %rdi
    movq   $0, %r9

    # Calculate the totall length of all strings
    .LPPRINTLN0:
    movq  16(%rbp, %rdx, 8), %rsi
    cmpq  $0, %rsi
    je    1f

    movq   %rsi, %rdi
    call   strlen
    pushq  %rax
    addq   %rax, %r9    # Result in r9

    incq  %rdx
    jmp   .LPPRINTLN0

    1:
    ANONMMAP  size=%r9
    movq      %rsi, %r9
    testq     %rax, %rax
    jns       1f
    leave
    ret

    1:
    movq  %rax, %rdi
    movq  $0, %rdx
    movq  $0, %r8

    .LPPRINTLN1:
    movq  16(%rbp, %rdx, 8), %rsi # The current argument
    cmpq  $0, %rsi
    je    1f

    movq  -16(%rbp, %r8, 8), %rcx # The length of the current argument
    rep   movsb
    movb  $' ', -1(%rdi)          # Replace null with Space
    decq  %r8
    incq  %rdx

    jmp  .LPPRINTLN1

    1:
    movq   %rax, %rsi
    movq   %rax, %r8
    movq   %r9, %rdx
    movb   $'\n', -1(%rsi, %rdx) # New line
    movb   $0, (%rsi, %rdx)      # Null
    WRITE  -8(%rbp), (%rsi), %r9

    MUNMAP  (%r8), %r9
    leave
    ret
/*
    Altered Registers
    - rdi
    - rsi
    - rdx
    - rcx
    - r8
    - r9
    - r10
*/
