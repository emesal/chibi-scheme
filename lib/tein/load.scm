;;; (tein load) — VFS-restricted load
;;;
;;; load is a rust trampoline registered by the runtime. it accepts only
;;; VFS paths (/vfs/...) and evaluates the embedded content. non-VFS paths
;;; return a sandbox violation error.
