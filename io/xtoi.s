/*
    Convert string number of any base between 2-16 into int
*/

.section .text
.global xtoi
.type xtoi, @function

xtoi: # xtoi(str, base)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp
    pushq  %rbx

    movq  $0x3736353433323130, %rax # 0-7
    movq  %rax, -32(%rbp)
    movq  $0x4645444342413938, %rax # 8-F
    movq  %rax, -24(%rbp)
    movq  $1, -8(%rbp)

    cmpq  $0, %rsi
    jne   2f

    xor   %rax, %rax
    movw  (%rdi), %ax

    movq  $16, %rsi
    cmpw  $0x7830, %ax # ax == '0x'?
    je    2f
    cmpw  $0x5830, %ax # ax == '0X'?
    je    2f

    movq  $2, %rsi
    cmpw  $0x6230, %ax # ax == '0b'?
    je    2f
    cmpw  $0x4230, %ax # ax == '0B'?
    je    2f

    movq  $8, %rsi
    cmpw  $0x6F30, %ax # ax == '0o'?
    je    2f
    cmpw  $0x5130, %ax # ax == '0O'?
    je    2f
    cmpb  $'0', %al    # al == '0'?
    je    1f

    movq  $10, %rsi
    jmp   3f

    1:
    addq  $1, %rdi
    jmp   3f

    2:
    addq  $2, %rdi

    3:
    movq  %rsi, %rbx

    cmpq  $10, %rsi
    jne   2f
    cmpb  $'-', %al     # al == '-'?
    jne   1f
    movq  $-1, -8(%rbp)
    incq  %rdi
    jmp   2f

    1:
    cmpb  $'+', %al # al == '+'?
    jne   2f
    incq  %rdi

    2:
    pushq  %rdi
    call   isbase
    testq  %rax, %rax
    js     3f

    popq   %rdi
    movq   %rdi, %rsi
    movq   $0, %rax
    movq   $-1, %rcx
    repne  scasb
    movq   %rdi, %rax
    subq   $2, %rax

    subq  %rsi, %rdi
    movq  %rdi, %r10
    decq  %r10

    movq  %rax, %rsi
    movq  $1, %r9

    xor  %rax, %rax
    xor  %r8, %r8
    std
    lodsb

    .LPXTOI0:
    leaq   -32(%rbp), %rdi
    movq   $16, %rcx
    cld
    repne  scasb

    leaq  -31(%rbp), %rax
    subq  %rax, %rdi
    movq  %rdi, %rax
    mul   %r9

    addq  %rax, %r8
    std
    lodsb

    imul  %rbx, %r9
    decq  %r10
    cmpq  $0, %r10
    jne   .LPXTOI0

    1:
    movq  %r8, %rax
    imul  -8(%rbp), %rax

    3:
    popq  %rbx
    cld
    leave
    ret
/*
    Altered Registers
    - rdi
    - rsi
    - rcx
    - rdx
    - r8
    - r9
    - r10
*/
