(define-library (tein toml)
  (import (scheme base))
  (export toml-parse toml-stringify)
  (include "toml.scm"))
