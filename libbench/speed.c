/*
 * Copyright (c) 2001 Matteo Frigo
 * Copyright (c) 2001 Steven G. Johnson
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Id: speed.c,v 1.2 2001-07-05 16:49:43 athena Exp $ */

#include "config.h"
#include "bench.h"

void speed(const char *param)
{
     double *t;
     int iter, k;
     struct problem *p;

     t = bench_malloc(time_repeat * sizeof(double));

     p = problem_parse(param);

     BENCH_ASSERT(can_do(p));
     
     setup(p);

     for (iter = 1; ; iter *= 2) {
	  for (k = 0; k < time_repeat; ++k) {
	       timer_start();
	       doit(iter, p);
	       t[k] = timer_stop();
	  }
	  
	  if (t[0] >= time_min)
	       break;
     }

     done(p);

     for (k = 0; k < time_repeat; ++k) {
	  t[k] /= iter;
     }

     report(p, t, time_repeat);

     problem_destroy(p);
     bench_free(t);
     return;
}