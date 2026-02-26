/*  macro.c -- (tein macro) static library init                  */
/*  macro expansion hook for intercepting/transforming expansions */

#include <chibi/eval.h>

/* forward declarations for tein_shim.c functions */
extern void tein_macro_expand_hook_set(sexp ctx, sexp proc);
extern sexp tein_macro_expand_hook_get(void);
extern void tein_macro_expand_hook_clear(sexp ctx);

/* (set-macro-expand-hook! proc) — set the thread-local macro expansion hook.
 * the hook receives (name unexpanded expanded env) after each macro expansion
 * and returns the form to use (return expanded unchanged for observation). */
static sexp sexp_tein_macro_hook_set(sexp ctx, sexp self, sexp_sint_t n,
                                     sexp proc) {
  if (!sexp_procedurep(proc))
    return sexp_xtype_exception(ctx, self,
      "set-macro-expand-hook!: expected procedure", proc);

  tein_macro_expand_hook_set(ctx, proc);
  return SEXP_VOID;
}

/* (unset-macro-expand-hook!) — clear the thread-local macro expansion hook. */
static sexp sexp_tein_macro_hook_unset(sexp ctx, sexp self, sexp_sint_t n) {
  tein_macro_expand_hook_clear(ctx);
  return SEXP_VOID;
}

/* (macro-expand-hook) — returns the current hook procedure or #f if none. */
static sexp sexp_tein_macro_hook_get(sexp ctx, sexp self, sexp_sint_t n) {
  return tein_macro_expand_hook_get();
}

sexp sexp_init_library (sexp ctx, sexp self, sexp_sint_t n, sexp env,
                        const char* version, const sexp_abi_identifier_t abi) {
  if (!(sexp_version_compatible(ctx, version, sexp_version)
        && sexp_abi_compatible(ctx, abi, SEXP_ABI_IDENTIFIER)))
    return SEXP_ABI_ERROR;

  sexp_define_foreign(ctx, env, "set-macro-expand-hook!", 1, sexp_tein_macro_hook_set);
  sexp_define_foreign(ctx, env, "unset-macro-expand-hook!", 0, sexp_tein_macro_hook_unset);
  sexp_define_foreign(ctx, env, "macro-expand-hook", 0, sexp_tein_macro_hook_get);

  return SEXP_VOID;
}
