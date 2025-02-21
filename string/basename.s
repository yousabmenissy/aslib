/*
    Return the base file name in path 
*/

.section .text
.global basename
.type basename, @function
basename: # basename(path)
    movq  %rdi, %rsi
    xor   %rax, %rax

    .LPBN0:
    lodsb
    cmpb   $'/', %al
    cmove  %rsi, %rdi

    cmpq  $0, %rax
    jne   .LPBN0
    movq  %rdi, %rax

    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
*/

