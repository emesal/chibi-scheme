;; tein override: re-exports env var access from (tein process)
;; which provides sandbox-aware trampolines.

(define-library (srfi 98)
  (import (only (tein process)
                get-environment-variable
                get-environment-variables))
  (export get-environment-variable get-environment-variables))
