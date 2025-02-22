/*
    Convert string into int 
*/

.section .text
.global atoi
.type atoi, @function
atoi: # atoi(str)
    movq   $1, %rdx
    movq  %rdi, %rsi
    xor   %rdi, %rdi
    xor   %rax, %rax
    lodsb

    cmpb  $'+', %al
    jne   1f
    lodsb
    jmp   .LPATOI0

    1:
    cmpb  $'-', %al
    jne   .LPATOI0
    movq  $-1, %rdx
    lodsb

    .LPATOI0:
    cmpb  $0, %al
    je    1f

    # Validation 
    cmpb  $'0', %al
    jb    2f
    cmpb  $'9', %al
    ja    2f

    subb  $'0', %al 
    addq  %rax, %rdi

    lodsb
    cmpb  $0, %al
    je    1f

    imul  $10, %rdi
    jmp   .LPATOI0

    1:
    imul  %rdx, %rdi
    movq  %rdi, %rax
    ret

    # Erorr
    2:
    xor %rax, %rax
    movq $-1, %rdx
    ret
