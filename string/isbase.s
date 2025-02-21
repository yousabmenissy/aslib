/*
    validate number string where base is between 2-16.
    the only valid characters are 0123456789ABCDEF. sign and prefixes are not allowed
*/

.section .text
.global isbase
.type isbase, @function
isbase: # isbase(str, base)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    movq  %rdi, -8(%rbp)
    movq  %rsi, -16(%rbp)

    movq  $0x3736353433323130, %rax       # 0-7
    movq  $0x4645444342413938, %rdx       # 8-F
    movq  %rax, -32(%rbp)
    movq  %rdx, -24(%rbp)

    movq   $-1, %rdx
    cmpq   $2, %rsi
    cmovb  %rdx, %rax
    jb     3f
    cmpq   $16, %rsi
    cmova  %rdx, %rax
    ja     3f

    call  toupper
    movq  -8(%rbp), %rsi

    .LPISBASE0:
    xor  %rax, %rax
    lodsb

    cmpb   $0, %al
    je     3f
    leaq   -32(%rbp), %rdi
    movq   $16, %rcx
    repne  scasb

    cmovne  %rdx, %rax
    jne     3f

    leaq   -32(%rbp), %rax
    subq   %rax, %rdi
    cmpq   -16(%rbp), %rdi
    cmova  %rdx, %rax
    ja     3f

    jmp  .LPISBASE0

    3:
    leave
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
    - rdx
*/
