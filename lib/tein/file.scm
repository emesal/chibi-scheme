;;; (tein file) — safe file IO with FsPolicy enforcement
;;;
;;; open-input-file, open-binary-input-file, open-output-file,
;;; open-binary-output-file are chibi opcodes (core env). policy enforcement
;;; happens at the C level in eval.c (patches F, G) via tein_fs_check_access.
;;; the FS policy gate is armed for sandboxed contexts; unsandboxed = allow all.
;;;
;;; file-exists? and delete-file are rust trampolines registered by
;;; register_file_module() in context.rs — they check IS_SANDBOXED + FsPolicy.
;;;
;;; the 4 higher-order wrappers below call open-input-file / open-output-file.
;;; policy enforcement flows through the C-level opcode check.

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
