;;; (tein process) — process context access
;;;
;;; get-environment-variable, get-environment-variables, command-line,
;;; and emergency-exit are rust trampolines registered by the runtime.
;;;
;;; exit: r7rs-compliant — unwinds dynamic-wind "after" thunks via
;;; travel-to-point!, flushes current output and error ports (r7rs requires
;;; flush, not close), then delegates to emergency-exit (rust trampoline).
;;;
;;; emergency-exit: immediate halt — no dynamic-wind cleanup, no port
;;; flushing. r7rs semantics.
;;;
;;; in sandboxed contexts, get-environment-variable returns #f,
;;; get-environment-variables returns '(), and command-line returns '("tein").

;;; walk %dk chain to find the actual root point.
;;; root-point from init-7.scm is NOT the same object as the actual %dk root
;;; in tein's context (tein's env setup creates a fresh root with #f thunks).
(define (%find-root point)
  (let ((parent (vector-ref point 3)))
    (if parent (%find-root parent) point)))

(define %exit-root (%find-root (%dk)))

(define (exit . args)
  ;; unwind dynamic-wind "after" thunks (innermost first)
  (travel-to-point! (%dk) %exit-root)
  (%dk %exit-root)
  ;; flush ports (r7rs: "flushes all open output ports ... then exits").
  ;; do NOT close — closing may raise on custom ports with fallible writes,
  ;; which would prevent emergency-exit from ever being called.
  (flush-output-port (current-output-port))
  (flush-output-port (current-error-port))
  ;; delegate to rust trampoline for actual VM halt
  (apply emergency-exit args))

;; --- deferred: not implemented ---
;; these functions exist so (chibi process) can re-export them.
;; calling any of them raises a clear error at call time, not import time.

(define (call-with-process-io . args) (error "not implemented" "call-with-process-io"))
(define (sleep . args) (error "not implemented" "sleep"))
(define (alarm . args) (error "not implemented" "alarm"))
(define (%fork . args) (error "not implemented" "%fork"))
(define (fork . args) (error "not implemented" "fork"))
(define (kill . args) (error "not implemented" "kill"))
(define (execute . args) (error "not implemented" "execute"))
(define (waitpid . args) (error "not implemented" "waitpid"))
(define (system? . args) (error "not implemented" "system?"))
(define (process-command-line . args) (error "not implemented" "process-command-line"))
(define (process-running? . args) (error "not implemented" "process-running?"))
(define (set-signal-action! . args) (error "not implemented" "set-signal-action!"))
(define (make-signal-set . args) (error "not implemented" "make-signal-set"))
(define (signal-set? . args) (error "not implemented" "signal-set?"))
(define (signal-set-contains? . args) (error "not implemented" "signal-set-contains?"))
(define (signal-set-fill! . args) (error "not implemented" "signal-set-fill!"))
(define (signal-set-add! . args) (error "not implemented" "signal-set-add!"))
(define (signal-set-delete! . args) (error "not implemented" "signal-set-delete!"))
(define (current-signal-mask . args) (error "not implemented" "current-signal-mask"))
(define (parent-process-id . args) (error "not implemented" "parent-process-id"))
(define (signal-mask-block! . args) (error "not implemented" "signal-mask-block!"))
(define (signal-mask-unblock! . args) (error "not implemented" "signal-mask-unblock!"))
(define (signal-mask-set! . args) (error "not implemented" "signal-mask-set!"))
(define (process->bytevector . args) (error "not implemented" "process->bytevector"))
(define (process->string . args) (error "not implemented" "process->string"))
(define (process->sexp . args) (error "not implemented" "process->sexp"))
(define (process->string-list . args) (error "not implemented" "process->string-list"))
(define (process->output+error . args) (error "not implemented" "process->output+error"))
(define (process->output+error+status . args) (error "not implemented" "process->output+error+status"))

;; signal constants (standard POSIX values)
(define signal/hang-up 1)
(define signal/interrupt 2)
(define signal/quit 3)
(define signal/illegal 4)
(define signal/abort 6)
(define signal/fpe 8)
(define signal/kill 9)
(define signal/segv 11)
(define signal/pipe 13)
(define signal/alarm 14)
(define signal/term 15)
(define signal/user1 10)
(define signal/user2 12)
(define signal/child 17)
(define signal/continue 18)
(define signal/stop 19)
(define signal/tty-stop 20)
(define signal/tty-input 21)
(define signal/tty-output 22)
(define wait/no-hang 1)
