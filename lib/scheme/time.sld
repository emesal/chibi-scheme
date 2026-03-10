;; tein override: re-exports from (tein time) which provides
;; rust implementations of r7rs time primitives.

(define-library (scheme time)
  (import (tein time))
  (export current-second current-jiffy jiffies-per-second))
