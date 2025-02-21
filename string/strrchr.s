/*
    Find the last occurence of a character in a string.
*/

.section .text
.global strrchr
.type strrchr, @function
strrchr: # strrchr(str, char)
    movb  %sil, %cl
    movq  %rdi, %rsi
    movq  $-1, %rdx
    movq  $-1, %rdi
    xor   %rax, %rax

    .LPSTRRC0:
    incq  %rdx
    movb  (%rsi, %rdx), %al
    cmpb  %cl, %al
    jne   1f
    leaq  (%rsi, %rdx), %rdi

    1:
    cmpb  $0, %al
    jne   .LPSTRRC0
    movq  %rdi, %rax
    ret
