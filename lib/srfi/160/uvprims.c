/*  uvprims.c -- uniform vector primitives for srfi/160         */
/*  hand-written equivalent of uvprims.stub (chibi-ffi output)  */
/*  Copyright (c) 2009-2020 Alex Shinn.  All rights reserved.  */
/*  BSD-style license: http://synthcode.com/license.txt         */

#include <stdint.h>
#include <chibi/eval.h>

/* ---- predicates ---- */

static sexp sexp_uvector_length_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv) {
  if (!sexp_uvectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  return sexp_make_fixnum(sexp_uvector_length(uv));
}

/* type predicates — one per element type */
#define DEF_UVEC_PRED(name, tag) \
  static sexp sexp_##name##p_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv) { \
    return sexp_make_boolean(sexp_uvectorp(uv) && sexp_uvector_type(uv) == (tag)); \
  }

DEF_UVEC_PRED(u1vector,  SEXP_U1)
DEF_UVEC_PRED(s8vector,  SEXP_S8)
DEF_UVEC_PRED(u16vector, SEXP_U16)
DEF_UVEC_PRED(s16vector, SEXP_S16)
DEF_UVEC_PRED(u32vector, SEXP_U32)
DEF_UVEC_PRED(s32vector, SEXP_S32)
DEF_UVEC_PRED(u64vector, SEXP_U64)
DEF_UVEC_PRED(s64vector, SEXP_S64)
DEF_UVEC_PRED(f8vector,  SEXP_F8)
DEF_UVEC_PRED(f16vector, SEXP_F16)
DEF_UVEC_PRED(f32vector, SEXP_F32)
DEF_UVEC_PRED(f64vector, SEXP_F64)
DEF_UVEC_PRED(c64vector, SEXP_C64)
DEF_UVEC_PRED(c128vector,SEXP_C128)

#undef DEF_UVEC_PRED

/* ---- u1 (bit vector) ---- */

static sexp sexp_u1vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_u1vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_fixnum(sexp_bit_ref(uv, idx));
}

static sexp sexp_u1vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_u1vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (!sexp_fixnump(v) || sexp_unbox_fixnum(v) < 0 || sexp_unbox_fixnum(v) >= 2)
    return sexp_user_exception(ctx, self, "value must be 0 or 1", v);
  sexp_bit_set(uv, idx, sexp_unbox_fixnum(v));
  return SEXP_VOID;
}

/* ---- s8 ---- */

static sexp sexp_s8vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_s8vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_fixnum(((signed char*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_s8vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx, val;
  if (!sexp_s8vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  if (!sexp_fixnump(v))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  idx = sexp_unbox_fixnum(i);
  val = sexp_unbox_fixnum(v);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (val < -128 || val > 127)
    return sexp_user_exception(ctx, self, "value out of range for s8", v);
  ((signed char*)sexp_uvector_data(uv))[idx] = (signed char)val;
  return SEXP_VOID;
}

/* ---- u16 ---- */

static sexp sexp_u16vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_u16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_fixnum(((unsigned short*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_u16vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx, val;
  if (!sexp_u16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  if (!sexp_fixnump(v))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  idx = sexp_unbox_fixnum(i);
  val = sexp_unbox_fixnum(v);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (val < 0 || val > 65535)
    return sexp_user_exception(ctx, self, "value out of range for u16", v);
  ((unsigned short*)sexp_uvector_data(uv))[idx] = (unsigned short)val;
  return SEXP_VOID;
}

/* ---- s16 ---- */

static sexp sexp_s16vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_s16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_fixnum(((short*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_s16vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx, val;
  if (!sexp_s16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  if (!sexp_fixnump(v))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  idx = sexp_unbox_fixnum(i);
  val = sexp_unbox_fixnum(v);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (val < -32768 || val > 32767)
    return sexp_user_exception(ctx, self, "value out of range for s16", v);
  ((short*)sexp_uvector_data(uv))[idx] = (short)val;
  return SEXP_VOID;
}

/* ---- u32 ---- */

static sexp sexp_u32vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_u32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_integer(ctx, ((uint32_t*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_u32vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  uint32_t val;
  if (!sexp_u32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (sexp_fixnump(v)) {
    sexp_sint_t sv = sexp_unbox_fixnum(v);
    if (sv < 0) return sexp_user_exception(ctx, self, "value out of range for u32", v);
    val = (uint32_t)sv;
#if SEXP_USE_BIGNUMS
  } else if (sexp_bignump(v)) {
    val = (uint32_t)sexp_bignum_data(v)[0];
#endif
  } else {
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  }
  ((uint32_t*)sexp_uvector_data(uv))[idx] = val;
  return SEXP_VOID;
}

/* ---- s32 ---- */

static sexp sexp_s32vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_s32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_integer(ctx, ((int32_t*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_s32vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  int32_t val;
  if (!sexp_s32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (sexp_fixnump(v)) {
    sexp_sint_t sv = sexp_unbox_fixnum(v);
    if (sv < -2147483648LL || sv > 2147483647LL)
      return sexp_user_exception(ctx, self, "value out of range for s32", v);
    val = (int32_t)sv;
#if SEXP_USE_BIGNUMS
  } else if (sexp_bignump(v)) {
    val = (int32_t)(sexp_bignum_sign(v) * (sexp_sint_t)sexp_bignum_data(v)[0]);
#endif
  } else {
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  }
  ((int32_t*)sexp_uvector_data(uv))[idx] = val;
  return SEXP_VOID;
}

/* ---- u64 ---- */

static sexp sexp_u64vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_u64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_integer(ctx, (sexp_sint_t)((uint64_t*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_u64vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  uint64_t val;
  if (!sexp_u64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (sexp_fixnump(v)) {
    sexp_sint_t sv = sexp_unbox_fixnum(v);
    if (sv < 0) return sexp_user_exception(ctx, self, "value out of range for u64", v);
    val = (uint64_t)sv;
#if SEXP_USE_BIGNUMS
  } else if (sexp_bignump(v)) {
    val = (uint64_t)sexp_bignum_data(v)[0];
#endif
  } else {
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  }
  ((uint64_t*)sexp_uvector_data(uv))[idx] = val;
  return SEXP_VOID;
}

/* ---- s64 ---- */

static sexp sexp_s64vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_s64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_integer(ctx, ((int64_t*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_s64vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  int64_t val;
  if (!sexp_s64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  if (sexp_fixnump(v)) {
    val = (int64_t)sexp_unbox_fixnum(v);
#if SEXP_USE_BIGNUMS
  } else if (sexp_bignump(v)) {
    val = (int64_t)(sexp_bignum_sign(v) * (sexp_sint_t)sexp_bignum_data(v)[0]);
#endif
  } else {
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, v);
  }
  ((int64_t*)sexp_uvector_data(uv))[idx] = val;
  return SEXP_VOID;
}

/* ---- f8 (quarter-precision float stored as unsigned byte) ---- */

static sexp sexp_f8vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_f8vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_flonum(ctx, sexp_quarter_to_double(((unsigned char*)sexp_uvector_data(uv))[idx]));
}

static sexp sexp_f8vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_f8vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((unsigned char*)sexp_uvector_data(uv))[idx] = sexp_double_to_quarter(sexp_to_double(ctx, v));
  return SEXP_VOID;
}

/* ---- f16 (half-precision float stored as unsigned short) ---- */

static sexp sexp_f16vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_f16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_flonum(ctx, sexp_half_to_double(((unsigned short*)sexp_uvector_data(uv))[idx]));
}

static sexp sexp_f16vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_f16vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((unsigned short*)sexp_uvector_data(uv))[idx] = sexp_double_to_half(sexp_to_double(ctx, v));
  return SEXP_VOID;
}

/* ---- f32 ---- */

static sexp sexp_f32vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_f32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_flonum(ctx, ((float*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_f32vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_f32vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((float*)sexp_uvector_data(uv))[idx] = (float)sexp_to_double(ctx, v);
  return SEXP_VOID;
}

/* ---- f64 ---- */

static sexp sexp_f64vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  if (!sexp_f64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  return sexp_make_flonum(ctx, ((double*)sexp_uvector_data(uv))[idx]);
}

static sexp sexp_f64vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_f64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((double*)sexp_uvector_data(uv))[idx] = sexp_to_double(ctx, v);
  return SEXP_VOID;
}

/* ---- c64 (complex, two f32) ---- */

static sexp sexp_c64vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  sexp_gc_var3(real, imag, res);
  if (!sexp_c64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  sexp_gc_preserve3(ctx, real, imag, res);
  real = sexp_make_flonum(ctx, ((float*)sexp_uvector_data(uv))[idx * 2]);
  imag = sexp_make_flonum(ctx, ((float*)sexp_uvector_data(uv))[idx * 2 + 1]);
  res = sexp_make_complex(ctx, real, imag);
  sexp_gc_release3(ctx);
  return res;
}

static sexp sexp_c64vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_c64vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((float*)sexp_uvector_data(uv))[idx * 2]     = (float)sexp_to_double(ctx, sexp_real_part(v));
  ((float*)sexp_uvector_data(uv))[idx * 2 + 1] = (float)sexp_to_double(ctx, sexp_imag_part(v));
  return SEXP_VOID;
}

/* ---- c128 (complex, two f64) ---- */

static sexp sexp_c128vector_ref_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i) {
  sexp_sint_t idx;
  sexp_gc_var3(real, imag, res);
  if (!sexp_c128vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  sexp_gc_preserve3(ctx, real, imag, res);
  real = sexp_make_flonum(ctx, ((double*)sexp_uvector_data(uv))[idx * 2]);
  imag = sexp_make_flonum(ctx, ((double*)sexp_uvector_data(uv))[idx * 2 + 1]);
  res = sexp_make_complex(ctx, real, imag);
  sexp_gc_release3(ctx);
  return res;
}

static sexp sexp_c128vector_set_op(sexp ctx, sexp self, sexp_sint_t n, sexp uv, sexp i, sexp v) {
  sexp_sint_t idx;
  if (!sexp_c128vectorp(uv))
    return sexp_type_exception(ctx, self, SEXP_UNIFORM_VECTOR, uv);
  if (sexp_immutablep(uv))
    return sexp_user_exception(ctx, self, "vector is immutable", uv);
  if (!sexp_fixnump(i))
    return sexp_type_exception(ctx, self, SEXP_FIXNUM, i);
  idx = sexp_unbox_fixnum(i);
  if (idx < 0 || idx >= (sexp_sint_t)sexp_uvector_length(uv))
    return sexp_user_exception(ctx, self, "index out of bounds", i);
  ((double*)sexp_uvector_data(uv))[idx * 2]     = sexp_to_double(ctx, sexp_real_part(v));
  ((double*)sexp_uvector_data(uv))[idx * 2 + 1] = sexp_to_double(ctx, sexp_imag_part(v));
  return SEXP_VOID;
}

/* ---- init ---- */

sexp sexp_init_library(sexp ctx, sexp self, sexp_sint_t n, sexp env,
                       const char* version, const sexp_abi_identifier_t abi) {
  sexp_gc_var1(name);
  if (!(sexp_version_compatible(ctx, version, sexp_version)
        && sexp_abi_compatible(ctx, abi, SEXP_ABI_IDENTIFIER)))
    return SEXP_ABI_ERROR;
  sexp_gc_preserve1(ctx, name);

  /* type constants — expose as scheme integers */
#define DEF_CONST(nm) \
  name = sexp_intern(ctx, #nm, -1); \
  sexp_env_define(ctx, env, name, sexp_make_fixnum(nm));

  DEF_CONST(SEXP_U1)
  DEF_CONST(SEXP_S8)
  DEF_CONST(SEXP_U8)
  DEF_CONST(SEXP_S16)
  DEF_CONST(SEXP_U16)
  DEF_CONST(SEXP_S32)
  DEF_CONST(SEXP_U32)
  DEF_CONST(SEXP_S64)
  DEF_CONST(SEXP_U64)
  DEF_CONST(SEXP_F32)
  DEF_CONST(SEXP_F64)
  DEF_CONST(SEXP_C64)
  DEF_CONST(SEXP_C128)
  DEF_CONST(SEXP_F8)
  DEF_CONST(SEXP_F16)
#undef DEF_CONST

  sexp_define_foreign(ctx, env, "uvector-length",   1, sexp_uvector_length_op);

  sexp_define_foreign(ctx, env, "u1vector?",        1, sexp_u1vectorp_op);
  sexp_define_foreign(ctx, env, "s8vector?",        1, sexp_s8vectorp_op);
  sexp_define_foreign(ctx, env, "u16vector?",       1, sexp_u16vectorp_op);
  sexp_define_foreign(ctx, env, "s16vector?",       1, sexp_s16vectorp_op);
  sexp_define_foreign(ctx, env, "u32vector?",       1, sexp_u32vectorp_op);
  sexp_define_foreign(ctx, env, "s32vector?",       1, sexp_s32vectorp_op);
  sexp_define_foreign(ctx, env, "u64vector?",       1, sexp_u64vectorp_op);
  sexp_define_foreign(ctx, env, "s64vector?",       1, sexp_s64vectorp_op);
  sexp_define_foreign(ctx, env, "f8vector?",        1, sexp_f8vectorp_op);
  sexp_define_foreign(ctx, env, "f16vector?",       1, sexp_f16vectorp_op);
  sexp_define_foreign(ctx, env, "f32vector?",       1, sexp_f32vectorp_op);
  sexp_define_foreign(ctx, env, "f64vector?",       1, sexp_f64vectorp_op);
  sexp_define_foreign(ctx, env, "c64vector?",       1, sexp_c64vectorp_op);
  sexp_define_foreign(ctx, env, "c128vector?",      1, sexp_c128vectorp_op);

  sexp_define_foreign(ctx, env, "u1vector-ref",     2, sexp_u1vector_ref_op);
  sexp_define_foreign(ctx, env, "u1vector-set!",    3, sexp_u1vector_set_op);
  sexp_define_foreign(ctx, env, "s8vector-ref",     2, sexp_s8vector_ref_op);
  sexp_define_foreign(ctx, env, "s8vector-set!",    3, sexp_s8vector_set_op);
  sexp_define_foreign(ctx, env, "u16vector-ref",    2, sexp_u16vector_ref_op);
  sexp_define_foreign(ctx, env, "u16vector-set!",   3, sexp_u16vector_set_op);
  sexp_define_foreign(ctx, env, "s16vector-ref",    2, sexp_s16vector_ref_op);
  sexp_define_foreign(ctx, env, "s16vector-set!",   3, sexp_s16vector_set_op);
  sexp_define_foreign(ctx, env, "u32vector-ref",    2, sexp_u32vector_ref_op);
  sexp_define_foreign(ctx, env, "u32vector-set!",   3, sexp_u32vector_set_op);
  sexp_define_foreign(ctx, env, "s32vector-ref",    2, sexp_s32vector_ref_op);
  sexp_define_foreign(ctx, env, "s32vector-set!",   3, sexp_s32vector_set_op);
  sexp_define_foreign(ctx, env, "u64vector-ref",    2, sexp_u64vector_ref_op);
  sexp_define_foreign(ctx, env, "u64vector-set!",   3, sexp_u64vector_set_op);
  sexp_define_foreign(ctx, env, "s64vector-ref",    2, sexp_s64vector_ref_op);
  sexp_define_foreign(ctx, env, "s64vector-set!",   3, sexp_s64vector_set_op);
  sexp_define_foreign(ctx, env, "f8vector-ref",     2, sexp_f8vector_ref_op);
  sexp_define_foreign(ctx, env, "f8vector-set!",    3, sexp_f8vector_set_op);
  sexp_define_foreign(ctx, env, "f16vector-ref",    2, sexp_f16vector_ref_op);
  sexp_define_foreign(ctx, env, "f16vector-set!",   3, sexp_f16vector_set_op);
  sexp_define_foreign(ctx, env, "f32vector-ref",    2, sexp_f32vector_ref_op);
  sexp_define_foreign(ctx, env, "f32vector-set!",   3, sexp_f32vector_set_op);
  sexp_define_foreign(ctx, env, "f64vector-ref",    2, sexp_f64vector_ref_op);
  sexp_define_foreign(ctx, env, "f64vector-set!",   3, sexp_f64vector_set_op);
  sexp_define_foreign(ctx, env, "c64vector-ref",    2, sexp_c64vector_ref_op);
  sexp_define_foreign(ctx, env, "c64vector-set!",   3, sexp_c64vector_set_op);
  sexp_define_foreign(ctx, env, "c128vector-ref",   2, sexp_c128vector_ref_op);
  sexp_define_foreign(ctx, env, "c128vector-set!",  3, sexp_c128vector_set_op);

  sexp_gc_release1(ctx);
  return SEXP_VOID;
}
