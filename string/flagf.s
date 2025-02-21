/*
    Get the flag value and convet it into float
*/

.section .text
.global flagf
.type flagf, @function
flagf: # flagf(flag, argv, len)
    pushq  %rbp
    movq   %rsp, %rbp
    subq   $32, %rsp

    movq   $-1, -8(%rbp)   # flag does not exist
    movq   $-2, -24(%rbp)  # flag is not valid
    call   flags
    testq  %rax, %rax
    cmove  -8(%rbp), %rax
    js     1f

    movq   %rax, %rdi
    call   atof
    testq  %rax, %rax
    cmovs  -24(%rbp), %rax

    1:
    leave
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rdx
    - rcx
    - r8
*/
