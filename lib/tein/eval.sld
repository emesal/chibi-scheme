(define-library (tein eval)
  ;; exports `environment` and `interaction-environment` trampolines registered
  ;; by the runtime via define_fn_variadic. patch H in eval.c makes native
  ;; procedures registered in the top-level env (or null_env in sandboxed
  ;; contexts) importable as first-class library exports.
  ;;
  ;; VFS shadow modules for (scheme eval), (scheme load), and (scheme repl)
  ;; import this library so they can reference the trampolines in their bodies
  ;; without triggering "undefined variable" warnings. closes #97.
  (import (scheme base))
  (export tein-environment-internal
          tein-interaction-environment-internal))
