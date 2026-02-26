/*  reader.c -- (tein reader) static library init                */
/*  reader dispatch extensions for #-prefixed syntax             */

#include <chibi/eval.h>

/* forward declarations for tein_shim.c functions */
extern int tein_reader_dispatch_set(sexp ctx, int c, sexp proc);
extern int tein_reader_dispatch_unset(sexp ctx, int c);
extern sexp tein_reader_dispatch_chars(sexp ctx);

/* (set-reader! char proc) — register a reader dispatch handler for #char.
 * rejects reserved r7rs characters with a descriptive error. */
static sexp sexp_tein_reader_set(sexp ctx, sexp self, sexp_sint_t n,
                                 sexp ch_sexp, sexp proc) {
  if (!sexp_charp(ch_sexp))
    return sexp_xtype_exception(ctx, self, "set-reader!: expected character", ch_sexp);
  if (!sexp_procedurep(proc))
    return sexp_xtype_exception(ctx, self, "set-reader!: expected procedure", proc);

  int c = sexp_unbox_character(ch_sexp);
  int result = tein_reader_dispatch_set(ctx, c, proc);
  if (result == 0)
    return SEXP_VOID;
  else if (result == -1)
    return sexp_user_exception(ctx, self,
      "set-reader!: character is reserved by r7rs", ch_sexp);
  else
    return sexp_user_exception(ctx, self,
      "set-reader!: character out of ASCII range", ch_sexp);
}

/* (unset-reader! char) — remove a reader dispatch handler for #char. */
static sexp sexp_tein_reader_unset(sexp ctx, sexp self, sexp_sint_t n,
                                   sexp ch_sexp) {
  if (!sexp_charp(ch_sexp))
    return sexp_xtype_exception(ctx, self, "unset-reader!: expected character", ch_sexp);

  int c = sexp_unbox_character(ch_sexp);
  tein_reader_dispatch_unset(ctx, c);
  return SEXP_VOID;
}

/* (reader-dispatch-chars) — list of characters with active dispatch handlers. */
static sexp sexp_tein_reader_chars(sexp ctx, sexp self, sexp_sint_t n) {
  return tein_reader_dispatch_chars(ctx);
}

sexp sexp_init_library (sexp ctx, sexp self, sexp_sint_t n, sexp env,
                        const char* version, const sexp_abi_identifier_t abi) {
  if (!(sexp_version_compatible(ctx, version, sexp_version)
        && sexp_abi_compatible(ctx, abi, SEXP_ABI_IDENTIFIER)))
    return SEXP_ABI_ERROR;

  sexp_define_foreign(ctx, env, "set-reader!", 2, sexp_tein_reader_set);
  sexp_define_foreign(ctx, env, "unset-reader!", 1, sexp_tein_reader_unset);
  sexp_define_foreign(ctx, env, "reader-dispatch-chars", 0, sexp_tein_reader_chars);

  return SEXP_VOID;
}
