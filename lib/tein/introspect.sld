(define-library (tein introspect)
  (import (scheme base) (scheme write) (scheme eval) (chibi))
  (export available-modules
          module-exports)
  (include "introspect.scm"))
