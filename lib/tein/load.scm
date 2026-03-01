;;; (tein load) — VFS-restricted load
;;;
;;; exports `load` which is aliased from `tein-load-vfs-internal`, a rust
;;; trampoline registered by the runtime. it accepts only VFS paths (/vfs/...)
;;; and evaluates the embedded content. non-VFS paths return a sandbox
;;; violation error.
;;;
;;; NOTE: the internal name `tein-load-vfs-internal` is used to avoid overriding
;;; chibi's built-in `load` at the global level (which the module loader uses
;;; for (include ...) in .sld files). the alias is set in load.sld via (begin ...).
