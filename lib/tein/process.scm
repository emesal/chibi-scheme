;;; (tein process) — process context access
;;;
;;; get-environment-variable, get-environment-variables, command-line,
;;; and exit are rust trampolines registered by the runtime.
;;;
;;; exit and emergency-exit: both have emergency-exit semantics — they
;;; immediately return control to the rust host without running dynamic-wind
;;; "after" thunks. r7rs exit should run those cleaners; that requires an
;;; unwind continuation around evaluate(), which tein does not yet establish.
;;; tracked in GH #101. a future standalone interpreter host can wrap
;;; evaluate() to provide correct r7rs exit semantics.
;;;
;;; in sandboxed contexts, get-environment-variable returns #f,
;;; get-environment-variables returns '(), and command-line returns '("tein").
