;;; (tein load) — VFS-restricted load
;;;
;;; `load` is exported as a rename of `tein-load-vfs-internal`, a rust
;;; trampoline registered by the runtime. it accepts only VFS paths
;;; (/vfs/...) and evaluates the embedded content. non-VFS paths return
;;; a sandbox violation error.
;;;
;;; the rename is declared directly in load.sld's export clause, so no
;;; scheme code is needed here. the internal name avoids overriding
;;; chibi's built-in `load`, which the module loader uses for (include ...)
;;; in .sld files.
