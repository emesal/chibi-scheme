(define-library (tein load)
  (import (scheme base))
  (export load)
  (begin
    ;; re-export tein-load-vfs-internal as load.
    ;; the rust runtime registers tein-load-vfs-internal as a global binding.
    ;; we alias it here so that (import (tein load)) brings `load` into scope
    ;; without overriding chibi's built-in `load` at the top level (which the
    ;; module loader uses for (include ...) directives in .sld files).
    (define load tein-load-vfs-internal)))
