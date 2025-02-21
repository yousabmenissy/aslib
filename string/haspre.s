/*
    Compare the end of str and prefix
*/

.section .text
.global haspre
.type haspre, @function
haspre: # haspre(prefix, str, len)
    decq  %rdx
    call  strcmp
    ret
/*
    ## Altered Registers ##
    - rdi
    - rsi
    - rcx
*/
