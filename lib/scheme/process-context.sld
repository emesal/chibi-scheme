;; tein override: re-exports from (tein process) which provides
;; sandbox-aware trampolines for all r7rs process-context bindings.

(define-library (scheme process-context)
  (import (tein process))
  (export get-environment-variable get-environment-variables
          command-line exit emergency-exit))
