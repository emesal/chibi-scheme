(define-library (scheme load)
  (import (tein load) (chibi))
  (export load environment)
  (begin
    (define (environment . specs)
      (apply tein-environment-internal specs))))
