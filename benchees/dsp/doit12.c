/* this program is in the public domain */

#include "bench-user.h"
#include <math.h>

BEGIN_BENCH_DOC
BENCH_DOC("name", "dsp79-FFT842")
BENCH_DOC("author", "G. D. Bergland and M. T. Dolan")
BENCH_DOC("year", "1979")
BENCH_DOC("language", "FORTRAN")
BENCH_DOC("notes", "Subroutine FFT842 from DSP Section 1.2")
BENCH_DOC("notes", "Needs separate real and imaginary arrays")
BENCH_DOC("notes", "The backward transform is scaled")
END_BENCH_DOC

int can_do(struct problem *p)
{
     return (SINGLE_PRECISION &&
	     p->rank == 1 &&
	     problem_complex_power_of_two(p, 1) &&
	     p->n[0] <= 32768);
}

void problem_ccopy_from(struct problem *p, bench_complex *in)
{
     BENCH_ASSERT(p->kind == PROBLEM_COMPLEX && p->rank == 1);
     copy_c2ri(in, p->in, ((bench_real *)p->in) + p->n[0],
	       p->n[0]);
}

void problem_ccopy_to(struct problem *p, bench_complex *out)
{
     BENCH_ASSERT(p->kind == PROBLEM_COMPLEX && p->rank == 1);
     copy_ri2c(p->out, ((bench_real *)p->out) + p->n[0], out,
	       p->n[0]);

     if (p->sign == 1) { 	  /* undo the scaling */
	  bench_complex x;
	  c_re(x) = p->size;
	  c_im(x) = 0;

	  cascale(out, p->size, x);
     }
}

extern void F77_FUNC(fft842, FFT842)();

void setup(struct problem *p)
{
     BENCH_ASSERT(can_do(p));
}

void doit(int iter, struct problem *p)
{
     int n = p->n[0];
     int sign = p->sign == -1 ? 0 : 1;
     bench_real *rin = p->in;
     bench_real *iin = rin + n;
     int i;

     for (i = 0; i < iter; ++i) {
	  F77_FUNC(fft842, FFT842)(&sign, &n, rin, iin);
     }
}

void done(struct problem *p)
{
     UNUSED(p);
}
