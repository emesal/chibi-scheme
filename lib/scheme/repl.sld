(define-library (scheme repl)
  (import (chibi))
  (export interaction-environment)
  (begin
    (define (interaction-environment)
      (tein-interaction-environment-internal))))
