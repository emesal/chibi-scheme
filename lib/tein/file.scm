;;; (tein file) — safe file operations through FsPolicy
;;;
;;; open-input-file, open-output-file, open-binary-input-file,
;;; open-binary-output-file are re-exported from the environment (already
;;; policy-wrapped by the rust runtime when sandboxed).
;;;
;;; file-exists? and delete-file are rust trampolines registered via
;;; define_fn_variadic that check FsPolicy independently.
;;;
;;; the higher-order wrappers below compose over the open-* procs,
;;; inheriting their policy safety.

(define (call-with-input-file path proc)
  (let ((port (open-input-file path)))
    (dynamic-wind
      (lambda () #f)
      (lambda () (proc port))
      (lambda () (close-input-port port)))))

(define (call-with-output-file path proc)
  (let ((port (open-output-file path)))
    (dynamic-wind
      (lambda () #f)
      (lambda () (proc port))
      (lambda () (close-output-port port)))))

(define (with-input-from-file path thunk)
  (let ((port (open-input-file path)))
    (dynamic-wind
      (lambda () #f)
      (lambda ()
        (parameterize ((current-input-port port))
          (thunk)))
      (lambda () (close-input-port port)))))

(define (with-output-to-file path thunk)
  (let ((port (open-output-file path)))
    (dynamic-wind
      (lambda () #f)
      (lambda ()
        (parameterize ((current-output-port port))
          (thunk)))
      (lambda () (close-output-port port)))))
