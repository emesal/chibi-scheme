(define-library (tein test)
  (import (scheme base) (scheme write))
  (export test-equal test-true test-false test-error)
  (include "test.scm"))
