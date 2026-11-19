// CLASwiftLAPACK.c
// Built with ACCELERATE_NEW_LAPACK and ACCELERATE_LAPACK_ILP64 (see Package.swift).

#include "CLASwiftLAPACK.h"
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

void laswift_dggsvd(const char *jobu, const char *jobv, const char *jobq, const laswift_int *m,
                    const laswift_int *n, const laswift_int *p, laswift_int *k, laswift_int *l, double *a,
                    const laswift_int *lda, double *b, const laswift_int *ldb, double *alpha, double *beta,
                    double *u, const laswift_int *ldu, double *v, const laswift_int *ldv, double *q,
                    const laswift_int *ldq, double *work, laswift_int *iwork, laswift_int *info) {
    dggsvd_(jobu, jobv, jobq, CI(m), CI(n), CI(p), MI(k), MI(l), a, CI(lda), b, CI(ldb), alpha, beta, u, CI(ldu),
            v, CI(ldv), q, CI(ldq), work, MI(iwork), MI(info));
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
