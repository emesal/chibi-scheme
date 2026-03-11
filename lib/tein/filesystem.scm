;;; (tein filesystem) — filesystem operations for tein embedding
;;;
;;; real implementations (file-exists?, delete-file, file-directory?, etc.) are
;;; rust trampolines registered via define_fn_variadic into the top-level env
;;; before this library is first imported. chibi resolves them via eval.c patch H
;;; (native proc import fallback from top-level env). the scheme-level stubs
;;; below are overwritten by the native fns at import time.
;;;
;;; deferred functions raise "not implemented" errors at call time, not import
;;; time — consumers can import the module and use real functions without hitting
;;; errors from the deferred ones.

;; --- constants ---
;; POSIX O_* / LOCK_* flags. informational only — the low-level `open`
;; function that uses these is deferred.
(define open/read 0)
(define open/write 1)
(define open/read-write 2)
(define open/create #x40)
(define open/exclusive #x80)
(define open/truncate #x200)
(define open/append #x400)
(define open/non-block #x800)
(define lock/shared 1)
(define lock/exclusive 2)
(define lock/non-blocking 4)
(define lock/unlock 8)

;; --- deferred: not implemented ---
;; these exist so (chibi filesystem) and (scheme file) can re-export them.
;; calling any of them raises a clear error at call time.

(define (duplicate-file-descriptor . args) (error "not implemented" "duplicate-file-descriptor"))
(define (duplicate-file-descriptor-to . args) (error "not implemented" "duplicate-file-descriptor-to"))
(define (close-file-descriptor . args) (error "not implemented" "close-file-descriptor"))
(define (renumber-file-descriptor . args) (error "not implemented" "renumber-file-descriptor"))
(define (open-input-file-descriptor . args) (error "not implemented" "open-input-file-descriptor"))
(define (open-output-file-descriptor . args) (error "not implemented" "open-output-file-descriptor"))
(define (link-file . args) (error "not implemented" "link-file"))
(define (symbolic-link-file . args) (error "not implemented" "symbolic-link-file"))
(define (read-link . args) (error "not implemented" "read-link"))
(define (directory-fold . args) (error "not implemented" "directory-fold"))
(define (directory-fold-tree . args) (error "not implemented" "directory-fold-tree"))
(define (delete-file-hierarchy . args) (error "not implemented" "delete-file-hierarchy"))
(define (create-directory* . args) (error "not implemented" "create-directory*"))
(define (change-directory . args) (error "not implemented" "change-directory"))
(define (with-directory . args) (error "not implemented" "with-directory"))
(define (open . args) (error "not implemented" "open"))
(define (open-pipe . args) (error "not implemented" "open-pipe"))
(define (make-fifo . args) (error "not implemented" "make-fifo"))
(define (open-output-file/append . args) (error "not implemented" "open-output-file/append"))
(define (file-status . args) (error "not implemented" "file-status"))
(define (file-link-status . args) (error "not implemented" "file-link-status"))
(define (file-device . args) (error "not implemented" "file-device"))
(define (file-inode . args) (error "not implemented" "file-inode"))
(define (file-mode . args) (error "not implemented" "file-mode"))
(define (file-num-links . args) (error "not implemented" "file-num-links"))
(define (file-owner . args) (error "not implemented" "file-owner"))
(define (file-group . args) (error "not implemented" "file-group"))
(define (file-represented-device . args) (error "not implemented" "file-represented-device"))
(define (file-block-size . args) (error "not implemented" "file-block-size"))
(define (file-num-blocks . args) (error "not implemented" "file-num-blocks"))
(define (file-access-time . args) (error "not implemented" "file-access-time"))
(define (file-change-time . args) (error "not implemented" "file-change-time"))
(define (file-modification-time . args) (error "not implemented" "file-modification-time"))
(define (file-modification-time/safe . args) (error "not implemented" "file-modification-time/safe"))
(define (file-character? . args) (error "not implemented" "file-character?"))
(define (file-block? . args) (error "not implemented" "file-block?"))
(define (file-fifo? . args) (error "not implemented" "file-fifo?"))
(define (file-socket? . args) (error "not implemented" "file-socket?"))
(define (get-file-descriptor-flags . args) (error "not implemented" "get-file-descriptor-flags"))
(define (set-file-descriptor-flags! . args) (error "not implemented" "set-file-descriptor-flags!"))
(define (get-file-descriptor-status . args) (error "not implemented" "get-file-descriptor-status"))
(define (set-file-descriptor-status! . args) (error "not implemented" "set-file-descriptor-status!"))
(define (file-lock . args) (error "not implemented" "file-lock"))
(define (file-truncate . args) (error "not implemented" "file-truncate"))
(define (file-is-readable? . args) (error "not implemented" "file-is-readable?"))
(define (file-is-writable? . args) (error "not implemented" "file-is-writable?"))
(define (file-is-executable? . args) (error "not implemented" "file-is-executable?"))
(define (file-permissions . args) (error "not implemented" "file-permissions"))
(define (set-file-permissions! . args) (error "not implemented" "set-file-permissions!"))
(define (chmod . args) (error "not implemented" "chmod"))
(define (chown . args) (error "not implemented" "chown"))
(define (is-a-tty? . args) (error "not implemented" "is-a-tty?"))
