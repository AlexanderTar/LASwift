// CLASwiftLAPACK.c
// Built with ACCELERATE_NEW_LAPACK and ACCELERATE_LAPACK_ILP64 (see Package.swift).

#include "CLASwiftLAPACK.h"

#if defined(__APPLE__)
#include <Accelerate/Accelerate.h>

_Static_assert(sizeof(laswift_int) == sizeof(__LAPACK_int), "laswift_int must match __LAPACK_int");

#define CI(p) ((const __LAPACK_int *)(p))
#define MI(p) ((__LAPACK_int *)(p))

void laswift_dgetrf(const laswift_int *m, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *ipiv, laswift_int *info) {
    dgetrf_(CI(m), CI(n), a, CI(lda), MI(ipiv), MI(info));
}

void laswift_dgetri(const laswift_int *n, double *a, const laswift_int *lda, const laswift_int *ipiv,
                    double *work, const laswift_int *lwork, laswift_int *info) {
    dgetri_(CI(n), a, CI(lda), CI(ipiv), work, CI(lwork), MI(info));
}

void laswift_dgeev(const char *jobvl, const char *jobvr, const laswift_int *n, double *a,
                   const laswift_int *lda, double *wr, double *wi, double *vl, const laswift_int *ldvl,
                   double *vr, const laswift_int *ldvr, double *work, const laswift_int *lwork,
                   laswift_int *info) {
    dgeev_(jobvl, jobvr, CI(n), a, CI(lda), wr, wi, vl, CI(ldvl), vr, CI(ldvr), work, CI(lwork), MI(info));
}

void laswift_dgesdd(const char *jobz, const laswift_int *m, const laswift_int *n, double *a,
                    const laswift_int *lda, double *s, double *u, const laswift_int *ldu, double *vt,
                    const laswift_int *ldvt, double *work, const laswift_int *lwork, laswift_int *iwork,
                    laswift_int *info) {
    dgesdd_(jobz, CI(m), CI(n), a, CI(lda), s, u, CI(ldu), vt, CI(ldvt), work, CI(lwork), MI(iwork), MI(info));
}

void laswift_dggsvd3(const char *jobu, const char *jobv, const char *jobq, const laswift_int *m,
                    const laswift_int *n, const laswift_int *p, laswift_int *k, laswift_int *l, double *a,
                    const laswift_int *lda, double *b, const laswift_int *ldb, double *alpha, double *beta,
                    double *u, const laswift_int *ldu, double *v, const laswift_int *ldv, double *q,
                    const laswift_int *ldq, double *work, const laswift_int *lwork, laswift_int *iwork,
                     laswift_int *info) {
    dggsvd3_(jobu, jobv, jobq, CI(m), CI(n), CI(p), MI(k), MI(l), a, CI(lda), b, CI(ldb), alpha, beta, u, CI(ldu),
            v, CI(ldv), q, CI(ldq), work, CI(lwork), MI(iwork), MI(info));
}

void laswift_dpotrf(const char *uplo, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *info) {
    dpotrf_(uplo, CI(n), a, CI(lda), MI(info));
}

void laswift_dgels(const char *trans, const laswift_int *m, const laswift_int *n, const laswift_int *nrhs,
                   double *a, const laswift_int *lda, double *b, const laswift_int *ldb, double *work,
                   const laswift_int *lwork, laswift_int *info) {
    dgels_(trans, CI(m), CI(n), CI(nrhs), a, CI(lda), b, CI(ldb), work, CI(lwork), MI(info));
}

void laswift_dlarnv(const laswift_int *idist, laswift_int *iseed, const laswift_int *n, double *x) {
    dlarnv_(CI(idist), MI(iseed), CI(n), x);
}

void laswift_cblas_dcopy(laswift_int n, const double *x, laswift_int incx, double *y, laswift_int incy) {
    cblas_dcopy((__LAPACK_int)n, x, (__LAPACK_int)incx, y, (__LAPACK_int)incy);
}

void laswift_cblas_dgemm_rowmajor(laswift_int m, laswift_int n, laswift_int k, const double *a,
                                  const double *b, double *c) {
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, (__LAPACK_int)m, (__LAPACK_int)n, (__LAPACK_int)k,
                1.0, a, (__LAPACK_int)k, b, (__LAPACK_int)n, 0.0, c, (__LAPACK_int)n);
}

#else  // !__APPLE__: reference LAPACK / OpenBLAS with the standard 32-bit Fortran integer (LP64).

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int f_int;

// gfortran-built LAPACK takes a hidden length argument for every CHARACTER argument, appended
// after the regular ones (what LAPACK's own lapack.h does with LAPACK_FORTRAN_STRLEN_END).
// Every job/uplo/trans argument LASwift passes is a single character, so each length is 1.

extern void dgetrf_(const f_int *, const f_int *, double *, const f_int *, f_int *, f_int *);
extern void dgetri_(const f_int *, double *, const f_int *, const f_int *, double *, const f_int *, f_int *);
extern void dgeev_(const char *, const char *, const f_int *, double *, const f_int *, double *, double *,
                   double *, const f_int *, double *, const f_int *, double *, const f_int *, f_int *,
                   size_t, size_t);
extern void dgesdd_(const char *, const f_int *, const f_int *, double *, const f_int *, double *, double *,
                    const f_int *, double *, const f_int *, double *, const f_int *, f_int *, f_int *, size_t);
extern void dggsvd3_(const char *, const char *, const char *, const f_int *, const f_int *, const f_int *,
                     f_int *, f_int *, double *, const f_int *, double *, const f_int *, double *, double *,
                     double *, const f_int *, double *, const f_int *, double *, const f_int *, double *,
                     const f_int *, f_int *, f_int *, size_t, size_t, size_t);
extern void dpotrf_(const char *, const f_int *, double *, const f_int *, f_int *, size_t);
extern void dgels_(const char *, const f_int *, const f_int *, const f_int *, double *, const f_int *, double *,
                   const f_int *, double *, const f_int *, f_int *, size_t);
extern void dlarnv_(const f_int *, f_int *, const f_int *, double *);
extern void cblas_dcopy(const f_int, const double *, const f_int, double *, const f_int);
// CBLAS enum values (CblasRowMajor = 101, CblasNoTrans = 111) are fixed by the CBLAS standard.
extern void cblas_dgemm(int, int, int, const f_int, const f_int, const f_int, const double, const double *,
                        const f_int, const double *, const f_int, const double, double *, const f_int);

// Narrow a 64-bit LASwift integer to LAPACK's 32-bit one; sizes beyond INT_MAX cannot be
// expressed in the LP64 interface, so they are a precondition failure rather than silent truncation.
static f_int nw(laswift_int v) {
    if (v > INT_MAX || v < INT_MIN) {
        fprintf(stderr, "LASwift: dimension %ld exceeds the 32-bit LAPACK interface on this platform\n", v);
        abort();
    }
    return (f_int)v;
}
#define S(name) f_int name##_ = nw(*name)

static f_int *narrow_array(const laswift_int *src, laswift_int n) {
    f_int *dst = malloc(sizeof(f_int) * (size_t)(n > 0 ? n : 1));
    if (!dst) abort();
    for (laswift_int i = 0; i < n; i++) dst[i] = src ? nw(src[i]) : 0;
    return dst;
}
static void widen_array(laswift_int *dst, const f_int *src, laswift_int n) {
    for (laswift_int i = 0; i < n; i++) dst[i] = src[i];
}

void laswift_dgetrf(const laswift_int *m, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *ipiv, laswift_int *info) {
    S(m); S(n); S(lda); f_int info_ = 0;
    laswift_int k = *m < *n ? *m : *n;
    f_int *ip = narrow_array(NULL, k);
    dgetrf_(&m_, &n_, a, &lda_, ip, &info_);
    widen_array(ipiv, ip, k); free(ip); *info = info_;
}

void laswift_dgetri(const laswift_int *n, double *a, const laswift_int *lda, const laswift_int *ipiv,
                    double *work, const laswift_int *lwork, laswift_int *info) {
    S(n); S(lda); S(lwork); f_int info_ = 0;
    f_int *ip = narrow_array(ipiv, *n);
    dgetri_(&n_, a, &lda_, ip, work, &lwork_, &info_);
    free(ip); *info = info_;
}

void laswift_dgeev(const char *jobvl, const char *jobvr, const laswift_int *n, double *a,
                   const laswift_int *lda, double *wr, double *wi, double *vl, const laswift_int *ldvl,
                   double *vr, const laswift_int *ldvr, double *work, const laswift_int *lwork,
                   laswift_int *info) {
    S(n); S(lda); S(ldvl); S(ldvr); S(lwork); f_int info_ = 0;
    dgeev_(jobvl, jobvr, &n_, a, &lda_, wr, wi, vl, &ldvl_, vr, &ldvr_, work, &lwork_, &info_, 1, 1);
    *info = info_;
}

void laswift_dgesdd(const char *jobz, const laswift_int *m, const laswift_int *n, double *a,
                    const laswift_int *lda, double *s, double *u, const laswift_int *ldu, double *vt,
                    const laswift_int *ldvt, double *work, const laswift_int *lwork, laswift_int *iwork,
                    laswift_int *info) {
    S(m); S(n); S(lda); S(ldu); S(ldvt); S(lwork); f_int info_ = 0;
    // iwork is LAPACK scratch of length 8*min(m,n); nothing is read back from it.
    f_int *iw = narrow_array(NULL, 8 * (*m < *n ? *m : *n));
    dgesdd_(jobz, &m_, &n_, a, &lda_, s, u, &ldu_, vt, &ldvt_, work, &lwork_, iw, &info_, 1);
    free(iw); *info = info_;
}

void laswift_dggsvd3(const char *jobu, const char *jobv, const char *jobq, const laswift_int *m,
                    const laswift_int *n, const laswift_int *p, laswift_int *k, laswift_int *l, double *a,
                    const laswift_int *lda, double *b, const laswift_int *ldb, double *alpha, double *beta,
                    double *u, const laswift_int *ldu, double *v, const laswift_int *ldv, double *q,
                    const laswift_int *ldq, double *work, const laswift_int *lwork, laswift_int *iwork,
                     laswift_int *info) {
    S(m); S(n); S(p); S(lda); S(ldb); S(ldu); S(ldv); S(ldq); S(lwork);
    f_int k_ = 0, l_ = 0, info_ = 0;
    // iwork (length n) returns the sorting permutation, so it is copied back.
    f_int *iw = narrow_array(NULL, *n);
    dggsvd3_(jobu, jobv, jobq, &m_, &n_, &p_, &k_, &l_, a, &lda_, b, &ldb_, alpha, beta, u, &ldu_, v, &ldv_,
             q, &ldq_, work, &lwork_, iw, &info_, 1, 1, 1);
    if (*lwork != -1) widen_array(iwork, iw, *n);
    free(iw); *k = k_; *l = l_; *info = info_;
}

void laswift_dpotrf(const char *uplo, const laswift_int *n, double *a, const laswift_int *lda,
                    laswift_int *info) {
    S(n); S(lda); f_int info_ = 0;
    dpotrf_(uplo, &n_, a, &lda_, &info_, 1);
    *info = info_;
}

void laswift_dgels(const char *trans, const laswift_int *m, const laswift_int *n, const laswift_int *nrhs,
                   double *a, const laswift_int *lda, double *b, const laswift_int *ldb, double *work,
                   const laswift_int *lwork, laswift_int *info) {
    S(m); S(n); S(nrhs); S(lda); S(ldb); S(lwork); f_int info_ = 0;
    dgels_(trans, &m_, &n_, &nrhs_, a, &lda_, b, &ldb_, work, &lwork_, &info_, 1);
    *info = info_;
}

void laswift_dlarnv(const laswift_int *idist, laswift_int *iseed, const laswift_int *n, double *x) {
    S(idist); S(n);
    f_int seed[4];
    for (int i = 0; i < 4; i++) seed[i] = nw(iseed[i]);
    dlarnv_(&idist_, seed, &n_, x);
    for (int i = 0; i < 4; i++) iseed[i] = seed[i];
}

void laswift_cblas_dcopy(laswift_int n, const double *x, laswift_int incx, double *y, laswift_int incy) {
    cblas_dcopy(nw(n), x, nw(incx), y, nw(incy));
}

void laswift_cblas_dgemm_rowmajor(laswift_int m, laswift_int n, laswift_int k, const double *a,
                                  const double *b, double *c) {
    cblas_dgemm(101, 111, 111, nw(m), nw(n), nw(k), 1.0, a, nw(k), b, nw(n), 0.0, c, nw(n));
}

#endif
