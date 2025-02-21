/*
    Compare the start of str and postfix
*/

.section .text
.global haspos
.type haspos, @function
haspos: # haspos(postfix, str, len)
    movq  %rdi, -8(%rsp)
    movq  $-1, -16(%rsp)

    movq   %rsi, %rdi
    movq   $-1, %rcx
    movq   $0, %rax
    repne  scasb

    std
    movq  -8(%rsp), %rsi
    addq  %rdx, %rsi
    decq  %rsi
    decq  %rdi
    movq  %rdx, %rcx
    repe  cmpsb

    cmovne  -16(%rsp), %rax
    cld
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
*/
