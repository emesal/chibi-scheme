;;; (tein file) — safe file IO with FsPolicy enforcement
;;;
;;; file-exists?, delete-file, open-input-file, open-binary-input-file,
;;; open-output-file, open-binary-output-file are rust trampolines registered
;;; directly in the context env by register_file_module() in context.rs.
;;; they enforce FsPolicy for all code — no import required to get enforcement.
;;;
;;; policy (at the trampoline level):
;;;   - unsandboxed: allow all (delegate to chibi original)
;;;   - sandboxed + policy: check prefix, then delegate
;;;   - sandboxed + no policy: deny (sandbox violation)
;;;
;;; the 4 higher-order wrappers below call open-input-file / open-output-file
;;; which resolve to the trampolines in the context env at call time.
;;; policy enforcement flows through the single open-* call site.

(define (call-with-input-file filename proc)
  (let ((port (open-input-file filename)))
    (dynamic-wind
      (lambda () #f)
      (lambda () (proc port))
      (lambda () (close-input-port port)))))

(define (call-with-output-file filename proc)
  (let ((port (open-output-file filename)))
    (dynamic-wind
      (lambda () #f)
      (lambda () (proc port))
      (lambda () (close-output-port port)))))

(define (with-input-from-file filename thunk)
  (let ((port (open-input-file filename)))
    (dynamic-wind
      (lambda () #f)
      (lambda ()
        (parameterize ((current-input-port port))
          (thunk)))
      (lambda () (close-input-port port)))))

(define (with-output-to-file filename thunk)
  (let ((port (open-output-file filename)))
    (dynamic-wind
      (lambda () #f)
      (lambda ()
        (parameterize ((current-output-port port))
          (thunk)))
      (lambda () (close-output-port port)))))
