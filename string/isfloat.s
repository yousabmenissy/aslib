/*
    Determine whether str is a valid float
*/

.section .text
.global isfloat
.type isfloat, @function
isfloat: # isfloat(str)
    movq  %rdi, %rsi
    movq  $-1, %rdi
    xor   %rax, %rax
    xor   %rcx, %rcx
    lodsb

    cmpb  $'-', %al
    jne   1f
    lodsb
    jmp   2f

    1:
    cmpb  $'+', %al
    jne   2f
    lodsb

    2:
    cmpb  $'.', %al
    jne   .LPISFLT0
    lodsb
    movq  $-1, %rcx

    .LPISFLT0:
    cmpb  $0, %al
    je    2f

    cmpb   $'.', %al
    jne    1f
    testq  %rcx, %rcx
    cmovs  %rdi, %rcx
    js     2f
    movq   $-1, %rcx
    lodsb
    jmp    .LPISFLT0

    1:
    cmpb   $'0', %al
    cmovb  %rdi, %rax
    jb     1f
    cmpb   $'9', %al
    cmova  %rdi, %rax
    ja     1f

    lodsb
    jmp  .LPISFLT0

    2:
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
*/
