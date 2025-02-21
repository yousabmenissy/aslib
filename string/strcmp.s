/*
    Compare two strings
*/

.section .text
.globl strcmp
.type strcmp, @function
strcmp: # strcmp(str1, str2, len)
    movq  $-1, -8(%rsp)
    movq  $0, %rax
    movq  %rdx, %rcx
    repe  cmpsb

    cmovne  -8(%rsp), %rax
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
*/
