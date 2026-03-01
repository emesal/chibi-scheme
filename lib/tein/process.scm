;;; (tein process) — process context access
;;;
;;; get-environment-variable, get-environment-variables, command-line,
;;; and exit are rust trampolines registered by the runtime.
;;;
;;; NOT in SAFE_MODULES — command-line leaks host argv. available via
;;; .vfs_all() or .allow_module("tein/process").
;;;
;;; exit is an eval escape hatch: (exit) or (exit obj) immediately returns
;;; to the rust caller with the given value. does not invoke dynamic-wind
;;; cleanup (emergency-exit semantics).
