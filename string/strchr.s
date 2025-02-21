/*
    Find the first occurence of a character in a string.
*/

.section .text
.global strchr
.type strchr, @function
strchr: # strchr(str, char)
    movq   %rdi, -8(%rsp)
    movb   $0, %al
    movq   $-1, %rcx
    repne  scasb

    movq    %rdi, %rcx
    subq    -8(%rsp), %rcx
    movq    -8(%rsp), %rdi
    movb    %sil, %al
    repne   scasb
    movq    $-1, %rcx
    cmovne  %rcx, %rax
    jne     1f

    decq  %rdi
    movq  %rdi, %rax

    1:
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
*/
