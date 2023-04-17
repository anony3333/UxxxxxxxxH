module  {
  $mainModuleBegin
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

$shareInsertPoint
void stencil_3d27pt_box(double %arg0[258][258][258], double %arg1[258][258][258]) {
    %0 = 0;$moveToHead<-long
    %1 = 8;$moveToHead<-long
    %2 = 4;$moveToHead<-long
    %3 = 2;$moveToHead<-long
    %4 = 1;$moveToHead<-long
    sw.launch (%arg2 = %arg0 : !sw<"memref<258x258x258xf64">, %arg3 = %arg1 : !sw<"memref<258x258x258xf64">) cacheRead(double %arg4[18][18][18]) cacheWrite(double %arg5[16][16][16])  {
      %5 = athread_get_id(-1);$moveToHead<-long
      %6 = 64;$moveToHead<-int
      %7 = %5 / %1;$moveToHead<-long
      %8 = %7 * %1;$moveToHead<-long
      %9 = %6 - %8;$moveToHead<-long
      %10 = %7 / %2;$moveToHead<-long
      %11 = %10 * %2;$moveToHead<-long
      %12 = %1 - %11;$moveToHead<-long
      %13 = %10 / %3;$moveToHead<-long
      %14 = %13 * %3;$moveToHead<-long
      %15 = %2 - %14;$moveToHead<-long
      %16 = 128;$moveToHead<-long
      %17 = %15 * %16;$moveToHead<-long
      %18 = %17 + %4;$moveToHead<-long
      %19 = 129;$moveToHead<-long
      %20 = %17 + %19;$moveToHead<-long
      %21 = 16;$moveToHead<-long
      long %arg6;
for ( %arg6 = %18; %arg6 < %20; %arg6 += %21 ) {
        %22 = 64;$moveToHead<-long
        %23 = %12 * %22;$moveToHead<-long
        %24 = %23 + %4;$moveToHead<-long
        %25 = 65;$moveToHead<-long
        %26 = %23 + %25;$moveToHead<-long
        long %arg7;
for ( %arg7 = %24; %arg7 < %26; %arg7 += %21 ) {
          %27 = 32;$moveToHead<-long
          %28 = %9 * %27;$moveToHead<-long
          %29 = %28 + %4;$moveToHead<-long
          %30 = 33;$moveToHead<-long
          %31 = %28 + %30;$moveToHead<-long
          long %arg8;
for ( %arg8 = %29; %arg8 < %31; %arg8 += %21 ) {
            %32 = 1;$moveToHead<-long
            %33 = %arg8 - %32;$moveToHead<-long
            %34 = %arg7 - %32;$moveToHead<-long
            %35 = %arg6 - %32;$moveToHead<-long
            DMA_get(%arg0[%33+z_iter][%34][%35], %arg4[z_iter][0][0], 18, 324*sizeof(double), 240*sizeof(double), 18*sizeof(double));
            long %arg9;
for ( %arg9 = %0; %arg9 < %21; %arg9 += %4 ) {
              long %arg10;
for ( %arg10 = %0; %arg10 < %21; %arg10 += %4 ) {
                long %arg11;
for ( %arg11 = %0; %arg11 < %21; %arg11 += %4 ) {
                  %36 = 1.000000e-01;$moveToHead<-double
                  %37 = %arg4[%arg9][%arg10][%arg11];$moveToHead<-double
                  %38 = %36 * %37;$moveToHead<-double
                  %39 = 2.000000e-01;$moveToHead<-double
                  %40 = %arg11 + %4;$moveToHead<-long
                  %41 = %arg4[%arg9][%arg10][%40];$moveToHead<-double
                  %42 = %39 * %41;$moveToHead<-double
                  %43 = %38 + %42;$moveToHead<-double
                  %44 = 3.000000e-01;$moveToHead<-double
                  %45 = %arg11 + %3;$moveToHead<-long
                  %46 = %arg4[%arg9][%arg10][%45];$moveToHead<-double
                  %47 = %44 * %46;$moveToHead<-double
                  %48 = %43 + %47;$moveToHead<-double
                  %49 = 4.000000e-01;$moveToHead<-double
                  %50 = %arg10 + %4;$moveToHead<-long
                  %51 = %arg4[%arg9][%50][%arg11];$moveToHead<-double
                  %52 = %49 * %51;$moveToHead<-double
                  %53 = %48 + %52;$moveToHead<-double
                  %54 = 5.000000e-01;$moveToHead<-double
                  %55 = %arg4[%arg9][%50][%40];$moveToHead<-double
                  %56 = %54 * %55;$moveToHead<-double
                  %57 = %53 + %56;$moveToHead<-double
                  %58 = 6.000000e-01;$moveToHead<-double
                  %59 = %arg4[%arg9][%50][%45];$moveToHead<-double
                  %60 = %58 * %59;$moveToHead<-double
                  %61 = %57 + %60;$moveToHead<-double
                  %62 = 7.000000e-01;$moveToHead<-double
                  %63 = %arg10 + %3;$moveToHead<-long
                  %64 = %arg4[%arg9][%63][%arg11];$moveToHead<-double
                  %65 = %62 * %64;$moveToHead<-double
                  %66 = %61 + %65;$moveToHead<-double
                  %67 = 8.000000e-01;$moveToHead<-double
                  %68 = %arg4[%arg9][%63][%40];$moveToHead<-double
                  %69 = %67 * %68;$moveToHead<-double
                  %70 = %66 + %69;$moveToHead<-double
                  %71 = 9.000000e-01;$moveToHead<-double
                  %72 = %arg4[%arg9][%63][%45];$moveToHead<-double
                  %73 = %71 * %72;$moveToHead<-double
                  %74 = %70 + %73;$moveToHead<-double
                  %75 = %arg9 + %4;$moveToHead<-long
                  %76 = %arg4[%75][%arg10][%arg11];$moveToHead<-double
                  %77 = %36 * %76;$moveToHead<-double
                  %78 = %74 + %77;$moveToHead<-double
                  %79 = %arg4[%75][%arg10][%40];$moveToHead<-double
                  %80 = %39 * %79;$moveToHead<-double
                  %81 = %78 + %80;$moveToHead<-double
                  %82 = %arg4[%75][%arg10][%45];$moveToHead<-double
                  %83 = %44 * %82;$moveToHead<-double
                  %84 = %81 + %83;$moveToHead<-double
                  %85 = %arg4[%75][%50][%arg11];$moveToHead<-double
                  %86 = %49 * %85;$moveToHead<-double
                  %87 = %84 + %86;$moveToHead<-double
                  %88 = %arg4[%75][%50][%40];$moveToHead<-double
                  %89 = %54 * %88;$moveToHead<-double
                  %90 = %87 + %89;$moveToHead<-double
                  %91 = %arg4[%75][%50][%45];$moveToHead<-double
                  %92 = %58 * %91;$moveToHead<-double
                  %93 = %90 + %92;$moveToHead<-double
                  %94 = %arg4[%75][%63][%arg11];$moveToHead<-double
                  %95 = %62 * %94;$moveToHead<-double
                  %96 = %93 + %95;$moveToHead<-double
                  %97 = %arg4[%75][%63][%40];$moveToHead<-double
                  %98 = %67 * %97;$moveToHead<-double
                  %99 = %96 + %98;$moveToHead<-double
                  %100 = %arg4[%75][%63][%45];$moveToHead<-double
                  %101 = %71 * %100;$moveToHead<-double
                  %102 = %99 + %101;$moveToHead<-double
                  %103 = %arg9 + %3;$moveToHead<-long
                  %104 = %arg4[%103][%arg10][%arg11];$moveToHead<-double
                  %105 = %36 * %104;$moveToHead<-double
                  %106 = %102 + %105;$moveToHead<-double
                  %107 = %arg4[%103][%arg10][%40];$moveToHead<-double
                  %108 = %39 * %107;$moveToHead<-double
                  %109 = %106 + %108;$moveToHead<-double
                  %110 = %arg4[%103][%arg10][%45];$moveToHead<-double
                  %111 = %44 * %110;$moveToHead<-double
                  %112 = %109 + %111;$moveToHead<-double
                  %113 = %arg4[%103][%50][%arg11];$moveToHead<-double
                  %114 = %49 * %113;$moveToHead<-double
                  %115 = %112 + %114;$moveToHead<-double
                  %116 = %arg4[%103][%50][%40];$moveToHead<-double
                  %117 = %54 * %116;$moveToHead<-double
                  %118 = %115 + %117;$moveToHead<-double
                  %119 = %arg4[%103][%50][%45];$moveToHead<-double
                  %120 = %58 * %119;$moveToHead<-double
                  %121 = %118 + %120;$moveToHead<-double
                  %122 = %arg4[%103][%63][%arg11];$moveToHead<-double
                  %123 = %62 * %122;$moveToHead<-double
                  %124 = %121 + %123;$moveToHead<-double
                  %125 = %arg4[%103][%63][%40];$moveToHead<-double
                  %126 = %67 * %125;$moveToHead<-double
                  %127 = %124 + %126;$moveToHead<-double
                  %128 = %arg4[%103][%63][%45];$moveToHead<-double
                  %129 = %71 * %128;$moveToHead<-double
                  %130 = %127 + %129;$moveToHead<-double
                  %arg5[%arg9][%arg10][%arg11] = %130;
                  
                }
                
              }
              
            }
            DMA_put(%arg5[z_iter][0][0], %arg1[%arg8+z_iter][%arg7][%arg6], 16, 256*sizeof(double), 242*sizeof(double), 16*sizeof(double));
            
          }
          
        }
        
      }
      
    }
  }
$mainModuleEnd

  $mainModuleBegin
void stencil_3d27pt_box_iteration(double %arg0[258][258][258], double %arg1[258][258][258]) {
    %0 = 0;$moveToHead<-long
    %1 = 1;$moveToHead<-long
    long %arg2;
for ( %arg2 = %0; %arg2 < %1; %arg2 += %1 ) {
      stencil_3d27pt_box(%arg0, %arg1);
      stencil_3d27pt_box(%arg1, %arg0);
      
    }
  }
$mainModuleEnd

}
