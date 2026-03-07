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
