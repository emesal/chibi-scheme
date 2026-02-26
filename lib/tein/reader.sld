(define-library (tein reader)
  (import (scheme base))
  (export set-reader! unset-reader! reader-dispatch-chars)
  (include "reader.scm"))
