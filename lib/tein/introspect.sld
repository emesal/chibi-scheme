(define-library (tein introspect)
  (import (scheme base) (scheme write) (scheme eval) (chibi))
  (export available-modules
          module-exports
          procedure-arity
          env-bindings
          imported-modules)
  (include "introspect.scm"))
