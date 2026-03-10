;; (tein filesystem) — native rust implementations are registered by the
;; tein rust layer (register_module_tein_filesystem) before this library
;; is first imported. chibi resolves the native fn exports via env
;; parent-chain lookup (localp=0). deferred functions raise "not
;; implemented" errors at call time, not import time.

;; constants — defined here since #[tein_const] emits scheme defines.
;; values match POSIX O_* / LOCK_* flags (informational only — the
;; low-level `open` function that uses these is deferred).
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
