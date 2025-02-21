/*
    Multiply 2 decimal values
*/

.section .text
.global dmul
.type dmul, @function
dmul: # dmul(xmm0, xmm1)
    pushq  %rbp
    movq   %rsp, %rbp
    pushq  %rbx

    pextrq  $0, %xmm0, %rax
    pextrq  $0, %xmm1, %rbx
    imul    %rbx
    pinsrq  $0, %rax, %xmm0

    pextrq  $1, %xmm0, %rax
    pextrq  $1, %xmm1, %rbx
    addq    %rbx, %rax
    pinsrq  $1, %rax, %xmm0

    popq  %rbx
    leave
    ret

.macro DMUL xmm1=%xmm1, xmm0=%xmm0
    movaps  \xmm0, %xmm0
    movaps  \xmm1, %xmm1
    call    dmul
.endm
