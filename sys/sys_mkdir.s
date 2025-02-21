/*
    From sys_open.s
    .equ S_IXUSR,       00000100    
    .equ S_IWUSR,       00000200    
    .equ S_IRUSR,       00000400    
    .equ S_IRWXU,       00000700    
    .equ S_IXGRP,       00000010     
    .equ S_IWGRG,       00000020     
    .equ S_IRGRG,       00000040     
    .equ S_IRWXG,       00000070     
    .equ S_IXOTH,       00000001      
    .equ S_IWOTH,       00000002      
    .equ S_IROTH,       00000004      
    .equ S_IRWXO,       00000007      
*/

.macro MKDIR path=(%rdi), mode=%rsi
    leaq  \path, %rdi
    movq  \mode, %rsi
    movq  $83, %rax
    syscall
.endm
