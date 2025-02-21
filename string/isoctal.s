/*
    Determine whether isint is a valid octal
*/

.section .text
.global isoctal
.type isoctal, @function
isoctal: # isoctal(str)
    movq  %rdi, %rsi
    movq  $-1, %rdi
    xor   %rax, %rax

    lodsb
    cmpb  $'0', %al   # Has to start with 0
    jne   2f

    lodsb

    .LPISO0:
    cmpb   $'0', %al
    cmovb  %rdi, %rax
    jb     2f
    cmpb   $'7', %al
    cmova  %rdi, %rax
    ja     2f

    lodsb
    cmpb  $0, %al
    je    2f

    jmp  .LPISO0

    2:
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
*/
