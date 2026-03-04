;; (tein time) — sandbox-safe r7rs time procedures.
;; native implementations are registered by the tein rust layer at context
;; initialisation time, replacing the stubs defined in time.scm.

(define-library (tein time)
  (import (scheme base))
  (export
    current-second
    current-jiffy
    jiffies-per-second
    timezone-offset-seconds)
  (include "time.scm"))
