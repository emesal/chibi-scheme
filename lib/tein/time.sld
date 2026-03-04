;; (tein time) — sandbox-safe r7rs time procedures.
;; native fns are registered by the rust layer (register_module_time) before
;; first import; chibi resolves them via env parent-chain lookup. time.scm
;; provides only jiffies-per-second, which cannot be a native fn.

(define-library (tein time)
  (import (scheme base))
  (export
    current-second
    current-jiffy
    jiffies-per-second
    timezone-offset-seconds)
  (include "time.scm"))
