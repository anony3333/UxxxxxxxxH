#include <athread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <stdint.h>
#ifdef SWStenMPI
#include "utils/mpi_lib.h"
#endif

struct stencil_3d27pt_box_kernel0_arg {
	double *arg0;
	double *arg1;
};
void slave_stencil_3d27pt_box_kernel0(struct stencil_3d27pt_box_kernel0_arg * arg); 
void stencil_3d27pt_box(double value1_arg0[258][258][258], double value1_arg1[258][258][258]) {
    struct stencil_3d27pt_box_kernel0_arg stencil_3d27pt_box_kernel0_param;
stencil_3d27pt_box_kernel0_param.arg0=value1_arg0;
stencil_3d27pt_box_kernel0_param.arg1=value1_arg1;
athread_spawn(stencil_3d27pt_box_kernel0, &stencil_3d27pt_box_kernel0_param);
athread_join();

  }
void stencil_3d27pt_box_iteration(double value2_arg0[258][258][258], double value2_arg1[258][258][258]) {
long value2_0 = 0;
long value2_1 = 1;
long value2_2 = 1;
    long value2_arg2;
for ( value2_arg2 = value2_0; value2_arg2 < value2_1; value2_arg2 += value2_2 ) {
int value2_3 = mpiGetMyRank();
      stencil_3d27pt_box(value2_arg0, value2_arg1);
      exchange_halo_3D_double(value2_arg1, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, value2_3);
      stencil_3d27pt_box(value2_arg1, value2_arg0);
      exchange_halo_3D_double(value2_arg0, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, value2_3);
      
    }
  }
