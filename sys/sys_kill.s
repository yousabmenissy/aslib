.equ SIGHUP,    1       # Hang up controlling terminal or process
.equ SIGINT,    2       # Interrupt from keyboard, Control-C
.equ SIGQUIT,   3       # Quit from keyboard, Control-\
.equ SIGILL,    4       # Illegal instruction
.equ SIGTRAP,   5       # Breakpoint for debugging
.equ SIGABRT,   6       # Abnormal termination
.equ SIGIOT,    6       # Equivalent to SIGABRT
.equ SIGBUS,    7       # Bus error
.equ SIGFPE,    8       # Floating-point exception
.equ SIGKILL,   9       # Forced-process termination
.equ SIGUSR1,   10      # Available to processes
.equ SIGSEGV,   11      # Invalid memory reference
.equ SIGUSR2,   12      # Available to processes
.equ SIGPIPE,   13      # Write to pipe with no readers
.equ SIGALRM,   14      # Real-timer clock
.equ SIGTERM,   15      # Process termination
.equ SIGSTKFLT, 16      # Coprocessor stack error
.equ SIGCHLD,   17      # Child process stopped or terminated or got a signal if traced
.equ SIGCONT,   18      # Resume execution, if stopped
.equ SIGSTOP,   19      # Stop process execution, Ctrl-Z
.equ SIGTSTP,   20      # Stop process issued from tty
.equ SIGTTIN,   21      # Background process requires input
.equ SIGTTOU,   22      # Background process requires output
.equ SIGURG,    23      # Urgent condition on socket
.equ SIGXCPU,   24      # CPU time limit exceeded
.equ SIGXFSZ,   25      # File size limit exceeded
.equ SIGVTALRM, 26      # Virtual timer clock
.equ SIGPROF,   27      # Profile timer clock
.equ SIGWINCH,  28      # Window resizing
.equ SIGIO,     29      # I/O now possible
.equ SIGPOLL,   29      # Equivalent to SIGIO
.equ SIGPWR,    30      # Power supply failure
.equ SIGSYS,    31      # Bad system call
.equ SIGUNUSED, 31      # Equivalent to SIGSYS

.macro KILL pid=%rdi, sig=%rsi
    movq  \pid, %rdi
    movq  \sig, %rsi
    movq  $62, %rax
    syscall
.endm
