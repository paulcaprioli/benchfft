/* this program is in the public domain */

#include "bench-user.h"
#include <math.h>

BEGIN_BENCH_DOC
BENCH_DOC("name", "gpfa")
BENCH_DOC("author", "Clive Temperton")
BENCH_DOC("year", "1992 (?)")
BENCH_DOC("language", "FORTRAN")
BENCH_DOC("bibitem", 
	  "C. Temperton : A Generalized Prime Factor Fft Algorithm "
	  "For Any N = (2**P)(3**Q)(5**R), SIAM J. Sci. Stat. Comp.," 
	  " MAY 1992.")
BENCH_DOC("notes"
	  "We also have a 3D version which appears to be apocryphal and thus "
          "not benchmarked")
END_BENCH_DOC


int can_do(struct problem *p)
{
     return (SINGLE_PRECISION && 
	     p->rank == 1 &&
	     problem_in_place(p) &&
	     check_prime_factors(p->n[0], 5));
}

static bench_real *TRIGS;

extern void F77_FUNC(setgpfa, SETGPFA)();
extern void F77_FUNC(gpfa, GPFA)();

void setup(struct problem *p)
{
     int n;
 
     BENCH_ASSERT(can_do(p));
     n = p->n[0];

     /* N is an overestimate */
     TRIGS = bench_malloc(2 * n * sizeof(bench_real));
     F77_FUNC(setgpfa, SETGPFA)(TRIGS, &n);
}

void doit(int iter, struct problem *p)
{
     int i;
     int n = p->n[0];
     bench_complex *in = p->in;
     bench_real *trigs = TRIGS;
     int inc = 2;
     int jump = 0;
     int lot = 1;
     int isign = p->sign;

     for (i = 0; i < iter; ++i) {
	  F77_FUNC(gpfa, GPFA)(&c_re(in[0]), &c_im(in[0]),
			       trigs, &inc, &jump, &n, &lot, &isign);
     }
}

void done(struct problem *p)
{
     UNUSED(p);
     bench_free(TRIGS);
}