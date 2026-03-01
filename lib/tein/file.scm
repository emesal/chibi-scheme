;;; (tein file) — safe file IO with FsPolicy enforcement
;;;
;;; file-exists? and delete-file are rust trampolines registered directly
;;; in the top-level env by register_file_module() in context.rs.
;;;
;;; open-input-file, open-binary-input-file, open-output-file,
;;; open-binary-output-file are rust trampolines registered under internal
;;; tein-file-open-*-file names to avoid library-env UNDEF clobber on import.
;;; the public scheme wrappers below call through to those internal names.
;;;
;;; policy (applies at the trampoline level):
;;;   - unsandboxed: allow all (delegate to chibi original)
;;;   - sandboxed + policy: check prefix, then delegate
;;;   - sandboxed + no policy: deny (sandbox violation)
;;;
;;; the 4 higher-order wrappers delegate to the open-* primitives below —
;;; policy enforcement happens at open-* (single point of check).

(define (open-input-file filename)
  (tein-file-open-input-file filename))

(define (open-binary-input-file filename)
  (tein-file-open-binary-input-file filename))

(define (open-output-file filename)
  (tein-file-open-output-file filename))

(define (open-binary-output-file filename)
  (tein-file-open-binary-output-file filename))

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
