(define-library (tein process)
  (import (scheme base) (chibi))
  (export get-environment-variable get-environment-variables
          command-line exit emergency-exit
          ;; new real implementations (rust trampolines)
          current-process-id system
          ;; deferred (raise "not implemented")
          call-with-process-io
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
          ;; signal constants
          signal/hang-up signal/interrupt signal/quit
          signal/illegal signal/abort signal/fpe
          signal/kill signal/segv signal/pipe
          signal/alarm signal/term
          signal/user1 signal/user2
          signal/child signal/continue signal/stop
          signal/tty-stop signal/tty-input signal/tty-output
          wait/no-hang)
  (include "process.scm"))
