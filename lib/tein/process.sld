(define-library (tein process)
  (import (scheme base) (chibi))
  (export get-environment-variable get-environment-variables
          command-line exit emergency-exit)
  (include "process.scm"))
