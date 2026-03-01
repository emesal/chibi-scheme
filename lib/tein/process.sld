(define-library (tein process)
  (import (scheme base))
  (export get-environment-variable get-environment-variables
          command-line exit)
  (include "process.scm"))
