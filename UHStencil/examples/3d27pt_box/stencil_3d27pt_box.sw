module  {
  $moduleBegin
#include <slave.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
#include <simd.h>
#include "utils/dma_lib.h"


$delete {
    $shareBegin
struct stencil_3d27pt_box_kernel0_arg {
	double *arg0;
	double *arg1;
};
$shareEnd
void slave_stencil_3d27pt_box_kernel0(struct stencil_3d27pt_box_kernel0_arg * arg); $speDeclare
void stencil_3d27pt_box_kernel0(struct stencil_3d27pt_box_kernel0_arg * arg)
$moveInToRegionBegin
double %arg2[6][10][66]; // cacheRead
double %arg3[4][8][64]; // cacheWrite
double (*%arg0)[258][258] = (double (*)[258][258])(arg->arg0);
double (*%arg1)[258][258] = (double (*)[258][258])(arg->arg1);
$moveInToRegionEnd
 {
      %0 = athread_get_id(-1);$moveToHead<-long
      %1 = 64;$moveToHead<-long
      %2 = 64;$moveToHead<-long
      %3 = 0;$moveToHead<-long
      %4 = 1;$moveToHead<-long
      %5 = 32;$moveToHead<-long
      %6 = 0;$moveToHead<-long
      %7 = 1;$moveToHead<-long
      %8 = 4;$moveToHead<-long
      %9 = 0;$moveToHead<-long
      %10 = 4;$moveToHead<-long
      %11 = 1;$moveToHead<-long
      %12 = 0;$moveToHead<-long
      %13 = 8;$moveToHead<-long
      %14 = 1;$moveToHead<-long
      %15 = 0;$moveToHead<-long
      %16 = 64;$moveToHead<-long
      %17 = 1;$moveToHead<-long
      %18 = 0;$moveToHead<-long
      long %arg4;
for ( %arg4 = %0; %arg4 < %2; %arg4 += %1 ) {
        %19 = 1;$moveToHead<-long
        long %arg5;
for ( %arg5 = %3; %arg5 < %5; %arg5 += %4 ) {
          %20 = 1;$moveToHead<-long
          long %arg6;
for ( %arg6 = %6; %arg6 < %8; %arg6 += %7 ) {
            %21 = 4;$moveToHead<-long
            %22 = %arg4 * %21;$moveToHead<-long
            %23 = 8;$moveToHead<-long
            %24 = %arg5 * %23;$moveToHead<-long
            %25 = 64;$moveToHead<-long
            %26 = %arg6 * %25;$moveToHead<-long
            DMA_get(%arg0[%22+z_iter][%24][%26], %arg2[z_iter][0][0], 6, 660*sizeof(double), 192*sizeof(double), 66*sizeof(double));
            %27 = 1;$moveToHead<-long
            long %arg7;
for ( %arg7 = %9; %arg7 < %10; %arg7 += %11 ) {
              long %arg8;
for ( %arg8 = %12; %arg8 < %13; %arg8 += %14 ) {
                long %arg9;
for ( %arg9 = %15; %arg9 < %16; %arg9 += %17 ) {
                  %40 = %19 + %arg7;$moveToHead<-long
                  %41 = %20 + %arg8;$moveToHead<-long
                  %42 = %27 + %arg9;$moveToHead<-long
                  %43 = 1.000000e-01;$moveToHead<-double
                  %44 = -1;$moveToHead<-long
                  %45 = %40 + %44;$moveToHead<-long
                  %46 = -1;$moveToHead<-long
                  %47 = %41 + %46;$moveToHead<-long
                  %48 = -1;$moveToHead<-long
                  %49 = %42 + %48;$moveToHead<-long
                  %50 = %arg2[%45][%47][%49];$moveToHead<-double
                  %51 = %43 * %50;$moveToHead<-double
                  %52 = 2.000000e-01;$moveToHead<-double
                  %53 = -1;$moveToHead<-long
                  %54 = %40 + %53;$moveToHead<-long
                  %55 = -1;$moveToHead<-long
                  %56 = %41 + %55;$moveToHead<-long
                  %57 = 0;$moveToHead<-long
                  %58 = %42 + %57;$moveToHead<-long
                  %59 = %arg2[%54][%56][%58];$moveToHead<-double
                  %60 = %52 * %59;$moveToHead<-double
                  %61 = %51 + %60;$moveToHead<-double
                  %62 = 3.000000e-01;$moveToHead<-double
                  %63 = -1;$moveToHead<-long
                  %64 = %40 + %63;$moveToHead<-long
                  %65 = -1;$moveToHead<-long
                  %66 = %41 + %65;$moveToHead<-long
                  %67 = 1;$moveToHead<-long
                  %68 = %42 + %67;$moveToHead<-long
                  %69 = %arg2[%64][%66][%68];$moveToHead<-double
                  %70 = %62 * %69;$moveToHead<-double
                  %71 = %61 + %70;$moveToHead<-double
                  %72 = 4.000000e-01;$moveToHead<-double
                  %73 = -1;$moveToHead<-long
                  %74 = %40 + %73;$moveToHead<-long
                  %75 = 0;$moveToHead<-long
                  %76 = %41 + %75;$moveToHead<-long
                  %77 = -1;$moveToHead<-long
                  %78 = %42 + %77;$moveToHead<-long
                  %79 = %arg2[%74][%76][%78];$moveToHead<-double
                  %80 = %72 * %79;$moveToHead<-double
                  %81 = %71 + %80;$moveToHead<-double
                  %82 = 5.000000e-01;$moveToHead<-double
                  %83 = -1;$moveToHead<-long
                  %84 = %40 + %83;$moveToHead<-long
                  %85 = 0;$moveToHead<-long
                  %86 = %41 + %85;$moveToHead<-long
                  %87 = 0;$moveToHead<-long
                  %88 = %42 + %87;$moveToHead<-long
                  %89 = %arg2[%84][%86][%88];$moveToHead<-double
                  %90 = %82 * %89;$moveToHead<-double
                  %91 = %81 + %90;$moveToHead<-double
                  %92 = 6.000000e-01;$moveToHead<-double
                  %93 = -1;$moveToHead<-long
                  %94 = %40 + %93;$moveToHead<-long
                  %95 = 0;$moveToHead<-long
                  %96 = %41 + %95;$moveToHead<-long
                  %97 = 1;$moveToHead<-long
                  %98 = %42 + %97;$moveToHead<-long
                  %99 = %arg2[%94][%96][%98];$moveToHead<-double
                  %100 = %92 * %99;$moveToHead<-double
                  %101 = %91 + %100;$moveToHead<-double
                  %102 = 7.000000e-01;$moveToHead<-double
                  %103 = -1;$moveToHead<-long
                  %104 = %40 + %103;$moveToHead<-long
                  %105 = 1;$moveToHead<-long
                  %106 = %41 + %105;$moveToHead<-long
                  %107 = -1;$moveToHead<-long
                  %108 = %42 + %107;$moveToHead<-long
                  %109 = %arg2[%104][%106][%108];$moveToHead<-double
                  %110 = %102 * %109;$moveToHead<-double
                  %111 = %101 + %110;$moveToHead<-double
                  %112 = 8.000000e-01;$moveToHead<-double
                  %113 = -1;$moveToHead<-long
                  %114 = %40 + %113;$moveToHead<-long
                  %115 = 1;$moveToHead<-long
                  %116 = %41 + %115;$moveToHead<-long
                  %117 = 0;$moveToHead<-long
                  %118 = %42 + %117;$moveToHead<-long
                  %119 = %arg2[%114][%116][%118];$moveToHead<-double
                  %120 = %112 * %119;$moveToHead<-double
                  %121 = %111 + %120;$moveToHead<-double
                  %122 = 9.000000e-01;$moveToHead<-double
                  %123 = -1;$moveToHead<-long
                  %124 = %40 + %123;$moveToHead<-long
                  %125 = 1;$moveToHead<-long
                  %126 = %41 + %125;$moveToHead<-long
                  %127 = 1;$moveToHead<-long
                  %128 = %42 + %127;$moveToHead<-long
                  %129 = %arg2[%124][%126][%128];$moveToHead<-double
                  %130 = %122 * %129;$moveToHead<-double
                  %131 = %121 + %130;$moveToHead<-double
                  %132 = 1.000000e-01;$moveToHead<-double
                  %133 = 0;$moveToHead<-long
                  %134 = %40 + %133;$moveToHead<-long
                  %135 = -1;$moveToHead<-long
                  %136 = %41 + %135;$moveToHead<-long
                  %137 = -1;$moveToHead<-long
                  %138 = %42 + %137;$moveToHead<-long
                  %139 = %arg2[%134][%136][%138];$moveToHead<-double
                  %140 = %132 * %139;$moveToHead<-double
                  %141 = %131 + %140;$moveToHead<-double
                  %142 = 2.000000e-01;$moveToHead<-double
                  %143 = 0;$moveToHead<-long
                  %144 = %40 + %143;$moveToHead<-long
                  %145 = -1;$moveToHead<-long
                  %146 = %41 + %145;$moveToHead<-long
                  %147 = 0;$moveToHead<-long
                  %148 = %42 + %147;$moveToHead<-long
                  %149 = %arg2[%144][%146][%148];$moveToHead<-double
                  %150 = %142 * %149;$moveToHead<-double
                  %151 = %141 + %150;$moveToHead<-double
                  %152 = 3.000000e-01;$moveToHead<-double
                  %153 = 0;$moveToHead<-long
                  %154 = %40 + %153;$moveToHead<-long
                  %155 = -1;$moveToHead<-long
                  %156 = %41 + %155;$moveToHead<-long
                  %157 = 1;$moveToHead<-long
                  %158 = %42 + %157;$moveToHead<-long
                  %159 = %arg2[%154][%156][%158];$moveToHead<-double
                  %160 = %152 * %159;$moveToHead<-double
                  %161 = %151 + %160;$moveToHead<-double
                  %162 = 4.000000e-01;$moveToHead<-double
                  %163 = 0;$moveToHead<-long
                  %164 = %40 + %163;$moveToHead<-long
                  %165 = 0;$moveToHead<-long
                  %166 = %41 + %165;$moveToHead<-long
                  %167 = -1;$moveToHead<-long
                  %168 = %42 + %167;$moveToHead<-long
                  %169 = %arg2[%164][%166][%168];$moveToHead<-double
                  %170 = %162 * %169;$moveToHead<-double
                  %171 = %161 + %170;$moveToHead<-double
                  %172 = 5.000000e-01;$moveToHead<-double
                  %173 = 0;$moveToHead<-long
                  %174 = %40 + %173;$moveToHead<-long
                  %175 = 0;$moveToHead<-long
                  %176 = %41 + %175;$moveToHead<-long
                  %177 = 0;$moveToHead<-long
                  %178 = %42 + %177;$moveToHead<-long
                  %179 = %arg2[%174][%176][%178];$moveToHead<-double
                  %180 = %172 * %179;$moveToHead<-double
                  %181 = %171 + %180;$moveToHead<-double
                  %182 = 6.000000e-01;$moveToHead<-double
                  %183 = 0;$moveToHead<-long
                  %184 = %40 + %183;$moveToHead<-long
                  %185 = 0;$moveToHead<-long
                  %186 = %41 + %185;$moveToHead<-long
                  %187 = 1;$moveToHead<-long
                  %188 = %42 + %187;$moveToHead<-long
                  %189 = %arg2[%184][%186][%188];$moveToHead<-double
                  %190 = %182 * %189;$moveToHead<-double
                  %191 = %181 + %190;$moveToHead<-double
                  %192 = 7.000000e-01;$moveToHead<-double
                  %193 = 0;$moveToHead<-long
                  %194 = %40 + %193;$moveToHead<-long
                  %195 = 1;$moveToHead<-long
                  %196 = %41 + %195;$moveToHead<-long
                  %197 = -1;$moveToHead<-long
                  %198 = %42 + %197;$moveToHead<-long
                  %199 = %arg2[%194][%196][%198];$moveToHead<-double
                  %200 = %192 * %199;$moveToHead<-double
                  %201 = %191 + %200;$moveToHead<-double
                  %202 = 8.000000e-01;$moveToHead<-double
                  %203 = 0;$moveToHead<-long
                  %204 = %40 + %203;$moveToHead<-long
                  %205 = 1;$moveToHead<-long
                  %206 = %41 + %205;$moveToHead<-long
                  %207 = 0;$moveToHead<-long
                  %208 = %42 + %207;$moveToHead<-long
                  %209 = %arg2[%204][%206][%208];$moveToHead<-double
                  %210 = %202 * %209;$moveToHead<-double
                  %211 = %201 + %210;$moveToHead<-double
                  %212 = 9.000000e-01;$moveToHead<-double
                  %213 = 0;$moveToHead<-long
                  %214 = %40 + %213;$moveToHead<-long
                  %215 = 1;$moveToHead<-long
                  %216 = %41 + %215;$moveToHead<-long
                  %217 = 1;$moveToHead<-long
                  %218 = %42 + %217;$moveToHead<-long
                  %219 = %arg2[%214][%216][%218];$moveToHead<-double
                  %220 = %212 * %219;$moveToHead<-double
                  %221 = %211 + %220;$moveToHead<-double
                  %222 = 1.000000e-01;$moveToHead<-double
                  %223 = 1;$moveToHead<-long
                  %224 = %40 + %223;$moveToHead<-long
                  %225 = -1;$moveToHead<-long
                  %226 = %41 + %225;$moveToHead<-long
                  %227 = -1;$moveToHead<-long
                  %228 = %42 + %227;$moveToHead<-long
                  %229 = %arg2[%224][%226][%228];$moveToHead<-double
                  %230 = %222 * %229;$moveToHead<-double
                  %231 = %221 + %230;$moveToHead<-double
                  %232 = 2.000000e-01;$moveToHead<-double
                  %233 = 1;$moveToHead<-long
                  %234 = %40 + %233;$moveToHead<-long
                  %235 = -1;$moveToHead<-long
                  %236 = %41 + %235;$moveToHead<-long
                  %237 = 0;$moveToHead<-long
                  %238 = %42 + %237;$moveToHead<-long
                  %239 = %arg2[%234][%236][%238];$moveToHead<-double
                  %240 = %232 * %239;$moveToHead<-double
                  %241 = %231 + %240;$moveToHead<-double
                  %242 = 3.000000e-01;$moveToHead<-double
                  %243 = 1;$moveToHead<-long
                  %244 = %40 + %243;$moveToHead<-long
                  %245 = -1;$moveToHead<-long
                  %246 = %41 + %245;$moveToHead<-long
                  %247 = 1;$moveToHead<-long
                  %248 = %42 + %247;$moveToHead<-long
                  %249 = %arg2[%244][%246][%248];$moveToHead<-double
                  %250 = %242 * %249;$moveToHead<-double
                  %251 = %241 + %250;$moveToHead<-double
                  %252 = 4.000000e-01;$moveToHead<-double
                  %253 = 1;$moveToHead<-long
                  %254 = %40 + %253;$moveToHead<-long
                  %255 = 0;$moveToHead<-long
                  %256 = %41 + %255;$moveToHead<-long
                  %257 = -1;$moveToHead<-long
                  %258 = %42 + %257;$moveToHead<-long
                  %259 = %arg2[%254][%256][%258];$moveToHead<-double
                  %260 = %252 * %259;$moveToHead<-double
                  %261 = %251 + %260;$moveToHead<-double
                  %262 = 5.000000e-01;$moveToHead<-double
                  %263 = 1;$moveToHead<-long
                  %264 = %40 + %263;$moveToHead<-long
                  %265 = 0;$moveToHead<-long
                  %266 = %41 + %265;$moveToHead<-long
                  %267 = 0;$moveToHead<-long
                  %268 = %42 + %267;$moveToHead<-long
                  %269 = %arg2[%264][%266][%268];$moveToHead<-double
                  %270 = %262 * %269;$moveToHead<-double
                  %271 = %261 + %270;$moveToHead<-double
                  %272 = 6.000000e-01;$moveToHead<-double
                  %273 = 1;$moveToHead<-long
                  %274 = %40 + %273;$moveToHead<-long
                  %275 = 0;$moveToHead<-long
                  %276 = %41 + %275;$moveToHead<-long
                  %277 = 1;$moveToHead<-long
                  %278 = %42 + %277;$moveToHead<-long
                  %279 = %arg2[%274][%276][%278];$moveToHead<-double
                  %280 = %272 * %279;$moveToHead<-double
                  %281 = %271 + %280;$moveToHead<-double
                  %282 = 7.000000e-01;$moveToHead<-double
                  %283 = 1;$moveToHead<-long
                  %284 = %40 + %283;$moveToHead<-long
                  %285 = 1;$moveToHead<-long
                  %286 = %41 + %285;$moveToHead<-long
                  %287 = -1;$moveToHead<-long
                  %288 = %42 + %287;$moveToHead<-long
                  %289 = %arg2[%284][%286][%288];$moveToHead<-double
                  %290 = %282 * %289;$moveToHead<-double
                  %291 = %281 + %290;$moveToHead<-double
                  %292 = 8.000000e-01;$moveToHead<-double
                  %293 = 1;$moveToHead<-long
                  %294 = %40 + %293;$moveToHead<-long
                  %295 = 1;$moveToHead<-long
                  %296 = %41 + %295;$moveToHead<-long
                  %297 = 0;$moveToHead<-long
                  %298 = %42 + %297;$moveToHead<-long
                  %299 = %arg2[%294][%296][%298];$moveToHead<-double
                  %300 = %292 * %299;$moveToHead<-double
                  %301 = %291 + %300;$moveToHead<-double
                  %302 = 9.000000e-01;$moveToHead<-double
                  %303 = 1;$moveToHead<-long
                  %304 = %40 + %303;$moveToHead<-long
                  %305 = 1;$moveToHead<-long
                  %306 = %41 + %305;$moveToHead<-long
                  %307 = 1;$moveToHead<-long
                  %308 = %42 + %307;$moveToHead<-long
                  %309 = %arg2[%304][%306][%308];$moveToHead<-double
                  %310 = %302 * %309;$moveToHead<-double
                  %311 = %301 + %310;$moveToHead<-double
                  %312 = 0;$moveToHead<-long
                  %313 = 1;$moveToHead<-long
                  %314 = %40 - %313;$moveToHead<-long
                  %315 = %314 + %312;$moveToHead<-long
                  %316 = 1;$moveToHead<-long
                  %317 = %41 - %316;$moveToHead<-long
                  %318 = 1;$moveToHead<-long
                  %319 = %42 - %318;$moveToHead<-long
                  %arg3[%315][%317][%319] = %311;
                  
                }
                
              }
              
            }
            %28 = 1;$moveToHead<-long
            %29 = 4;$moveToHead<-long
            %30 = %arg4 * %29;$moveToHead<-long
            %31 = %30 + %28;$moveToHead<-long
            %32 = 1;$moveToHead<-long
            %33 = 8;$moveToHead<-long
            %34 = %arg5 * %33;$moveToHead<-long
            %35 = %34 + %32;$moveToHead<-long
            %36 = 1;$moveToHead<-long
            %37 = 64;$moveToHead<-long
            %38 = %arg6 * %37;$moveToHead<-long
            %39 = %38 + %36;$moveToHead<-long
            DMA_put(%arg3[z_iter][0][0], %arg1[%31+z_iter][%35][%39], 4, 512*sizeof(double), 194*sizeof(double), 64*sizeof(double));
            
          }
          
        }
        
      }
    }
  } $delete
$moduleEnd

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
    struct stencil_3d27pt_box_kernel0_arg stencil_3d27pt_box_kernel0_param;
stencil_3d27pt_box_kernel0_param.arg0=%arg0;
stencil_3d27pt_box_kernel0_param.arg1=%arg1;
athread_spawn(stencil_3d27pt_box_kernel0, &stencil_3d27pt_box_kernel0_param);
athread_join();

  }
$mainModuleEnd

  $mainModuleBegin
void stencil_3d27pt_box_iteration(double %arg0[258][258][258], double %arg1[258][258][258]) {
    %0 = 0;$moveToHead<-long
    %1 = 1;$moveToHead<-long
    %2 = 1;$moveToHead<-long
    long %arg2;
for ( %arg2 = %0; %arg2 < %1; %arg2 += %2 ) {
      %3 = mpiGetMyRank();$moveToHead<-int
      stencil_3d27pt_box(%arg0, %arg1);
      exchange_halo_3D_double(%arg1, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, %3);
      stencil_3d27pt_box(%arg1, %arg0);
      exchange_halo_3D_double(%arg0, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, %3);
      
    }
  }
$mainModuleEnd

}
