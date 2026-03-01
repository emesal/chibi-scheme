;;; (tein load) — VFS-restricted load
;;;
;;; exports `load` aliased from `tein-load-vfs-internal`, a rust trampoline
;;; registered by the runtime. it accepts only VFS paths (/vfs/...) and
;;; evaluates the embedded content. non-VFS paths return a sandbox violation.
;;;
;;; the internal name avoids overriding chibi's built-in `load`, which the
;;; module loader uses for (include ...) in .sld files. only scopes that
;;; explicitly `(import (tein load))` get the VFS-restricted version.

(define load tein-load-vfs-internal)
