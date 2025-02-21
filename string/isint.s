/*
    Determine whether isint is a valid float
*/

.section .text
.global isint
.type isint, @function
isint: # isint(str)
    movq  %rdi, %rsi
    movq  $-1, %rdi
    xor   %rax, %rax
    lodsb

    cmpb  $'-', %al
    jne   1f
    lodsb
    jmp   .LPISINT0

    1:
    cmpb  $'+', %al
    jne   .LPISINT0
    lodsb

    .LPISINT0:
    cmpb  $0, %al
    je    1f

    cmpb   $'0', %al
    cmovb  %rdi, %rax
    jb     1f
    cmpb   $'9', %al
    cmova  %rdi, %rax
    ja     1f

    lodsb
    jmp  .LPISINT0

    1:
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
*/

