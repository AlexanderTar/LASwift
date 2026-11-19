// CLASwiftLAPACK.h
//
// Thin C wrappers over the LAPACK routines LASwift uses.
//
// Why a C target: Accelerate's new LAPACK headers (non-deprecated) are only
// enabled by compiling with -DACCELERATE_NEW_LAPACK. SwiftPM refuses
// `unsafeFlags` (needed for `-Xcc -D...` on a Swift target) in packages used
// as versioned dependencies, but a C target's `cSettings` `.define` is allowed.
// The header stays free of Accelerate so Swift imports it with plain C types.

#ifndef CLASWIFTLAPACK_H
#define CLASWIFTLAPACK_H

// Matches Accelerate's __LAPACK_int when built with ACCELERATE_LAPACK_ILP64
// (a 64-bit `long`; on arm64_32 Accelerate falls back to a 32-bit int, the same
// size as `long` there). Swift imports this as `Int`.
typedef long laswift_int;

void laswift_dgetrf(const laswift_int *m, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *ipiv, laswift_int *info);
void laswift_dgetri(const laswift_int *n, double *a, const laswift_int *lda, const laswift_int *ipiv,
                    double *work, const laswift_int *lwork, laswift_int *info);
void laswift_dgeev(const char *jobvl, const char *jobvr, const laswift_int *n, double *a,
                   const laswift_int *lda, double *wr, double *wi, double *vl, const laswift_int *ldvl,
                   double *vr, const laswift_int *ldvr, double *work, const laswift_int *lwork,
                   laswift_int *info);
void laswift_dgesdd(const char *jobz, const laswift_int *m, const laswift_int *n, double *a,
                    const laswift_int *lda, double *s, double *u, const laswift_int *ldu, double *vt,
                    const laswift_int *ldvt, double *work, const laswift_int *lwork, laswift_int *iwork,
                    laswift_int *info);
void laswift_dggsvd(const char *jobu, const char *jobv, const char *jobq, const laswift_int *m,
                    const laswift_int *n, const laswift_int *p, laswift_int *k, laswift_int *l, double *a,
                    const laswift_int *lda, double *b, const laswift_int *ldb, double *alpha, double *beta,
                    double *u, const laswift_int *ldu, double *v, const laswift_int *ldv, double *q,
                    const laswift_int *ldq, double *work, laswift_int *iwork, laswift_int *info);
void laswift_dpotrf(const char *uplo, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *info);
void laswift_dgels(const char *trans, const laswift_int *m, const laswift_int *n, const laswift_int *nrhs,
                   double *a, const laswift_int *lda, double *b, const laswift_int *ldb, double *work,
                   const laswift_int *lwork, laswift_int *info);
void laswift_dlarnv(const laswift_int *idist, laswift_int *iseed, const laswift_int *n, double *x);

// CBLAS dcopy (strided vector copy), wrapped for the same reason: the non-deprecated
// CBLAS declarations need the same defines.
void laswift_cblas_dcopy(laswift_int n, const double *x, laswift_int incx, double *y, laswift_int incy);

#endif
