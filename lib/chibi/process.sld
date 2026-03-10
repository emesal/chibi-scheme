;; tein override: re-exports from (tein process) which provides
;; rust implementations of process operations.

(define-library (chibi process)
  (import (tein process))
  (export
    exit emergency-exit
    get-environment-variable get-environment-variables command-line
    current-process-id system call-with-process-io
    sleep alarm %fork fork kill execute
    waitpid system?
    process-command-line process-running?
    set-signal-action!
    make-signal-set signal-set? signal-set-contains?
    signal-set-fill! signal-set-add! signal-set-delete!
    current-signal-mask parent-process-id
    signal-mask-block! signal-mask-unblock! signal-mask-set!
    process->bytevector process->string process->sexp
    process->string-list
    process->output+error process->output+error+status
    signal/hang-up signal/interrupt signal/quit
    signal/illegal signal/abort signal/fpe
    signal/kill signal/segv signal/pipe
    signal/alarm signal/term
    signal/user1 signal/user2
    signal/child signal/continue signal/stop
    signal/tty-stop signal/tty-input signal/tty-output
    wait/no-hang))
