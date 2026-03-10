(define-library (scheme eval)
  (import (chibi))
  (export eval environment)
  (begin
    (define (environment . specs)
      (apply tein-environment-internal specs))))
