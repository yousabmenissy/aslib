/*
    Concatinate a variadic number of strings and write it to file
    str... are laid out on the stack from last to first with a null to indicate the end
*/

.section .text
.global print
.type print, @function

print: # print(fd, str...)
    pushq  %rbp
    movq   %rsp, %rbp

    pushq  %rdi
    movq   $0, %r9

    # Calculate the totall length of all strings
    .LPPRINT0:
    movq  16(%rbp, %rdx, 8), %rsi
    cmpq  $0, %rsi
    je    1f

    movq   %rsi, %rdi
    call   strlen
    pushq  %rax       # Each argument length is saved on the stack
    addq   %rax, %r9

    incq  %rdx
    jmp   .LPPRINT0

    1:
    ANONMMAP  size = %r9 # The buffer

    movq   %rsi, %r9
    testq  %rax, %rax
    jns    1f
    leave
    ret

    1:
    movq  %rax, %rdi
    movq  $0, %rdx
    movq  $0, %r8

    .LPPRINT1:
    movq  16(%rbp, %rdx, 8), %rsi # The current argument
    cmpq  $0, %rsi
    je    1f

    movq  -16(%rbp, %r8, 8), %rcx # The length of the current argument
    rep   movsb
    movb  $' ', -1(%rdi)          # Replace null with Space
    decq  %r8
    incq  %rdx

    jmp  .LPPRINT1

    1:
    movq   %rax, %rsi
    movq   %rax, %r8
    movq   %r9, %rdx
    movb   $0, -1(%rsi, %rdx)    # Null terminator
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

