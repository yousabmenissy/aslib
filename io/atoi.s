/*
    Convert string into int 
*/

.section .text
.global atoi
.type atoi, @function

atoi: # atoi(str)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $16, %rsp
    movq   $1, -8(%rbp)

    call   isint
    testq  %rax, %rax
    jns    1f
    leave
    ret

    1:
    movq  %rdi, %rsi
    xor   %rdi, %rdi
    xor   %rax, %rax
    lodsb

    cmpb  $'+', %al
    jne   1f
    lodsb
    jmp   .LPATOI0

    1:
    cmpb  $'-', %al     # If negative set NFLAG
    jne   .LPATOI0
    movq  $-1, -8(%rbp)
    lodsb

    .LPATOI0:
    cmpb  $0, %al
    je    1f

    subb  $'0', %al
    addq  %rax, %rdi # rdi will hold the result

    lodsb

    cmpb  $0, %al
    je    1f

    imul  $10, %rdi # Adjust the base
    jmp   .LPATOI0

    1:
    imul  -8(%rbp), %rdi # res *= NFLAG
    movq  %rdi, %rax

    leave
    ret
