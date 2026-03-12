(define-library (tein introspect)
  (import (scheme base) (scheme write) (scheme eval) (chibi))
  (export available-modules
          imported-modules
          module-exports
          env-bindings
          binding-info
          procedure-arity
          describe-environment
          describe-environment/text
          introspect-docs)
  (include "introspect.scm"))
