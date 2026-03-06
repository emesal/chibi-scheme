;;; (tein eval) — eval/environment trampolines
;;;
;;; `tein-environment-internal` and `tein-interaction-environment-internal`
;;; are rust trampolines registered by the runtime via define_fn_variadic.
;;; they are exported from this library so VFS shadow modules (scheme/eval,
;;; scheme/load, scheme/repl) can import them by name.
;;;
;;; all logic lives in the trampolines; no scheme code needed here.
