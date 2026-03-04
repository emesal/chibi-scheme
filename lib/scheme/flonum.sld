;;; (scheme flonum) — r7rs flonum library, backed by (srfi 144).
;;; re-exports all srfi/144 bindings; renames comparison procedures to the
;;; r7rs names (fl= fl< fl> fl<= fl>=) from srfi/144's fl=? fl<? etc.

(define-library (scheme flonum)
  (import (srfi 144))
  (export
   ;; constants
   fl-e fl-1/e fl-e-2 fl-e-pi/4 fl-log2-e fl-log10-e fl-log-2
   fl-1/log-2 fl-log-3 fl-log-pi fl-log-10 fl-1/log-10 fl-pi
   fl-1/pi fl-2pi fl-2/pi fl-pi/2 fl-pi/4 fl-pi-squared fl-degree
   fl-sqrt-pi fl-2/sqrt-pi fl-sqrt-2 fl-sqrt-3 fl-sqrt-5 fl-sqrt-10
   fl-1/sqrt-2 fl-cbrt-2 fl-cbrt-3 fl-4thrt-2 fl-phi fl-log-phi
   fl-1/log-phi fl-euler fl-e-euler fl-sin-1 fl-cos-1 fl-gamma-1/2
   fl-gamma-1/3 fl-gamma-2/3 fl-greatest fl-least fl-epsilon
   fl-integer-exponent-zero fl-integer-exponent-nan fl-fast-+*

   ;; type
   flonum flonum?

   ;; r7rs comparison names (srfi/144 uses fl=? fl<? etc — we rename here)
   (rename fl=?  fl=)
   (rename fl<?  fl<)
   (rename fl>?  fl>)
   (rename fl<=? fl<=)
   (rename fl>=? fl>=)

   ;; also export the srfi/144 names for compatibility
   fl=? fl<? fl>? fl<=? fl>=?

   ;; predicates
   flodd? fleven? flunordered? flinteger? flzero? flpositive? flnegative?
   sign-bit flfinite? flinfinite? flnan? flnormalized? fldenormalized?

   ;; arithmetic
   fl+ fl- fl* fl/ fl+* flmax flmin flabsdiff
   flnumerator fldenominator

   ;; constructors / decomposition
   fladjacent flcopysign flsgn make-flonum flinteger-fraction
   flexponent flinteger-exponent flnormalized-fraction-exponent

   ;; rounding
   flabs flposdiff flfloor flceiling flround fltruncate

   ;; transcendentals
   flexp flexp2 flexp-1 flsquare flsqrt flcbrt flhypot flexpt fllog fllog1+
   fllog2 fllog10 flsin flcos fltan flasin flacos flatan
   flsinh flcosh fltanh flasinh flacosh flatanh flremquo
   flgamma flloggamma flfirst-bessel flsecond-bessel flerf flerfc

   ;; division
   flfloor/ flfloor-quotient flfloor-remainder
   flceiling/ flceiling-quotient flceiling-remainder
   fltruncate/ fltruncate-quotient fltruncate-remainder
   flround/ flround-quotient flround-remainder
   fleuclidean/ fleuclidean-quotient fleuclidean-remainder
   flbalanced/ flbalanced-quotient flbalanced-remainder))
