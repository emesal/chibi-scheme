;;; (tein file) — safe file existence and deletion
;;;
;;; file-exists? and delete-file are rust trampolines registered by the
;;; runtime via define_fn_variadic. they check IS_SANDBOXED + FsPolicy:
;;; - unsandboxed context: allow all paths
;;; - sandboxed context without file_read/file_write: deny all
;;; - sandboxed context with policy: check against configured prefixes
;;;
;;; open-input-file, open-output-file, and the higher-order wrappers
;;; (call-with-input-file, with-input-from-file, etc.) are available from
;;; the standard environment and do not need to be re-exported here — the
;;; io policy wrapping is applied directly by the context builder.
