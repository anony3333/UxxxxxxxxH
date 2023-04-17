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

void stencil_3d27pt_box(double value0_arg0[258][258][258], double value0_arg1[258][258][258]) {
    sw.launch (value0_arg2 = value0_arg0 : !sw<"memref<258x258x258xf64">, value0_arg3 = value0_arg1 : !sw<"memref<258x258x258xf64">) cacheRead(double value0_arg4[6][10][66]) cacheWrite(double value0_arg5[4][8][64])  {
long value0_0 = athread_get_id(-1);
long value0_1 = 64;
long value0_2 = 64;
long value0_3 = 0;
long value0_4 = 1;
long value0_5 = 32;
long value0_6 = 0;
long value0_7 = 1;
long value0_8 = 4;
long value0_9 = 0;
long value0_10 = 4;
long value0_11 = 1;
long value0_12 = 0;
long value0_13 = 8;
long value0_14 = 1;
long value0_15 = 0;
long value0_16 = 64;
long value0_17 = 1;
long value0_18 = 0;
      long value0_arg6;
for ( value0_arg6 = value0_0; value0_arg6 < value0_2; value0_arg6 += value0_1 ) {
long value0_19 = 1;
        long value0_arg7;
for ( value0_arg7 = value0_3; value0_arg7 < value0_5; value0_arg7 += value0_4 ) {
long value0_20 = 1;
          long value0_arg8;
for ( value0_arg8 = value0_6; value0_arg8 < value0_8; value0_arg8 += value0_7 ) {
long value0_21 = 4;
long value0_22 = value0_arg6 * value0_21;
long value0_23 = 8;
long value0_24 = value0_arg7 * value0_23;
long value0_25 = 64;
long value0_26 = value0_arg8 * value0_25;
            DMA_get(value0_arg2[value0_22+z_iter][value0_24][value0_26], value0_arg4[z_iter][0][0], 6, 660*sizeof(double), 192*sizeof(double), 66*sizeof(double));
long value0_27 = 1;
            long value0_arg9;
for ( value0_arg9 = value0_9; value0_arg9 < value0_10; value0_arg9 += value0_11 ) {
              long value0_arg10;
for ( value0_arg10 = value0_12; value0_arg10 < value0_13; value0_arg10 += value0_14 ) {
                long value0_arg11;
for ( value0_arg11 = value0_15; value0_arg11 < value0_16; value0_arg11 += value0_17 ) {
long value0_40 = value0_19 + value0_arg9;
long value0_41 = value0_20 + value0_arg10;
long value0_42 = value0_27 + value0_arg11;
double value0_43 = 1.000000e-01;
long value0_44 = -1;
long value0_45 = value0_40 + value0_44;
long value0_46 = -1;
long value0_47 = value0_41 + value0_46;
long value0_48 = -1;
long value0_49 = value0_42 + value0_48;
double value0_50 = value0_arg4[value0_45][value0_47][value0_49];
double value0_51 = value0_43 * value0_50;
double value0_52 = 2.000000e-01;
long value0_53 = -1;
long value0_54 = value0_40 + value0_53;
long value0_55 = -1;
long value0_56 = value0_41 + value0_55;
long value0_57 = 0;
long value0_58 = value0_42 + value0_57;
double value0_59 = value0_arg4[value0_54][value0_56][value0_58];
double value0_60 = value0_52 * value0_59;
double value0_61 = value0_51 + value0_60;
double value0_62 = 3.000000e-01;
long value0_63 = -1;
long value0_64 = value0_40 + value0_63;
long value0_65 = -1;
long value0_66 = value0_41 + value0_65;
long value0_67 = 1;
long value0_68 = value0_42 + value0_67;
double value0_69 = value0_arg4[value0_64][value0_66][value0_68];
double value0_70 = value0_62 * value0_69;
double value0_71 = value0_61 + value0_70;
double value0_72 = 4.000000e-01;
long value0_73 = -1;
long value0_74 = value0_40 + value0_73;
long value0_75 = 0;
long value0_76 = value0_41 + value0_75;
long value0_77 = -1;
long value0_78 = value0_42 + value0_77;
double value0_79 = value0_arg4[value0_74][value0_76][value0_78];
double value0_80 = value0_72 * value0_79;
double value0_81 = value0_71 + value0_80;
double value0_82 = 5.000000e-01;
long value0_83 = -1;
long value0_84 = value0_40 + value0_83;
long value0_85 = 0;
long value0_86 = value0_41 + value0_85;
long value0_87 = 0;
long value0_88 = value0_42 + value0_87;
double value0_89 = value0_arg4[value0_84][value0_86][value0_88];
double value0_90 = value0_82 * value0_89;
double value0_91 = value0_81 + value0_90;
double value0_92 = 6.000000e-01;
long value0_93 = -1;
long value0_94 = value0_40 + value0_93;
long value0_95 = 0;
long value0_96 = value0_41 + value0_95;
long value0_97 = 1;
long value0_98 = value0_42 + value0_97;
double value0_99 = value0_arg4[value0_94][value0_96][value0_98];
double value0_100 = value0_92 * value0_99;
double value0_101 = value0_91 + value0_100;
double value0_102 = 7.000000e-01;
long value0_103 = -1;
long value0_104 = value0_40 + value0_103;
long value0_105 = 1;
long value0_106 = value0_41 + value0_105;
long value0_107 = -1;
long value0_108 = value0_42 + value0_107;
double value0_109 = value0_arg4[value0_104][value0_106][value0_108];
double value0_110 = value0_102 * value0_109;
double value0_111 = value0_101 + value0_110;
double value0_112 = 8.000000e-01;
long value0_113 = -1;
long value0_114 = value0_40 + value0_113;
long value0_115 = 1;
long value0_116 = value0_41 + value0_115;
long value0_117 = 0;
long value0_118 = value0_42 + value0_117;
double value0_119 = value0_arg4[value0_114][value0_116][value0_118];
double value0_120 = value0_112 * value0_119;
double value0_121 = value0_111 + value0_120;
double value0_122 = 9.000000e-01;
long value0_123 = -1;
long value0_124 = value0_40 + value0_123;
long value0_125 = 1;
long value0_126 = value0_41 + value0_125;
long value0_127 = 1;
long value0_128 = value0_42 + value0_127;
double value0_129 = value0_arg4[value0_124][value0_126][value0_128];
double value0_130 = value0_122 * value0_129;
double value0_131 = value0_121 + value0_130;
double value0_132 = 1.000000e-01;
long value0_133 = 0;
long value0_134 = value0_40 + value0_133;
long value0_135 = -1;
long value0_136 = value0_41 + value0_135;
long value0_137 = -1;
long value0_138 = value0_42 + value0_137;
double value0_139 = value0_arg4[value0_134][value0_136][value0_138];
double value0_140 = value0_132 * value0_139;
double value0_141 = value0_131 + value0_140;
double value0_142 = 2.000000e-01;
long value0_143 = 0;
long value0_144 = value0_40 + value0_143;
long value0_145 = -1;
long value0_146 = value0_41 + value0_145;
long value0_147 = 0;
long value0_148 = value0_42 + value0_147;
double value0_149 = value0_arg4[value0_144][value0_146][value0_148];
double value0_150 = value0_142 * value0_149;
double value0_151 = value0_141 + value0_150;
double value0_152 = 3.000000e-01;
long value0_153 = 0;
long value0_154 = value0_40 + value0_153;
long value0_155 = -1;
long value0_156 = value0_41 + value0_155;
long value0_157 = 1;
long value0_158 = value0_42 + value0_157;
double value0_159 = value0_arg4[value0_154][value0_156][value0_158];
double value0_160 = value0_152 * value0_159;
double value0_161 = value0_151 + value0_160;
double value0_162 = 4.000000e-01;
long value0_163 = 0;
long value0_164 = value0_40 + value0_163;
long value0_165 = 0;
long value0_166 = value0_41 + value0_165;
long value0_167 = -1;
long value0_168 = value0_42 + value0_167;
double value0_169 = value0_arg4[value0_164][value0_166][value0_168];
double value0_170 = value0_162 * value0_169;
double value0_171 = value0_161 + value0_170;
double value0_172 = 5.000000e-01;
long value0_173 = 0;
long value0_174 = value0_40 + value0_173;
long value0_175 = 0;
long value0_176 = value0_41 + value0_175;
long value0_177 = 0;
long value0_178 = value0_42 + value0_177;
double value0_179 = value0_arg4[value0_174][value0_176][value0_178];
double value0_180 = value0_172 * value0_179;
double value0_181 = value0_171 + value0_180;
double value0_182 = 6.000000e-01;
long value0_183 = 0;
long value0_184 = value0_40 + value0_183;
long value0_185 = 0;
long value0_186 = value0_41 + value0_185;
long value0_187 = 1;
long value0_188 = value0_42 + value0_187;
double value0_189 = value0_arg4[value0_184][value0_186][value0_188];
double value0_190 = value0_182 * value0_189;
double value0_191 = value0_181 + value0_190;
double value0_192 = 7.000000e-01;
long value0_193 = 0;
long value0_194 = value0_40 + value0_193;
long value0_195 = 1;
long value0_196 = value0_41 + value0_195;
long value0_197 = -1;
long value0_198 = value0_42 + value0_197;
double value0_199 = value0_arg4[value0_194][value0_196][value0_198];
double value0_200 = value0_192 * value0_199;
double value0_201 = value0_191 + value0_200;
double value0_202 = 8.000000e-01;
long value0_203 = 0;
long value0_204 = value0_40 + value0_203;
long value0_205 = 1;
long value0_206 = value0_41 + value0_205;
long value0_207 = 0;
long value0_208 = value0_42 + value0_207;
double value0_209 = value0_arg4[value0_204][value0_206][value0_208];
double value0_210 = value0_202 * value0_209;
double value0_211 = value0_201 + value0_210;
double value0_212 = 9.000000e-01;
long value0_213 = 0;
long value0_214 = value0_40 + value0_213;
long value0_215 = 1;
long value0_216 = value0_41 + value0_215;
long value0_217 = 1;
long value0_218 = value0_42 + value0_217;
double value0_219 = value0_arg4[value0_214][value0_216][value0_218];
double value0_220 = value0_212 * value0_219;
double value0_221 = value0_211 + value0_220;
double value0_222 = 1.000000e-01;
long value0_223 = 1;
long value0_224 = value0_40 + value0_223;
long value0_225 = -1;
long value0_226 = value0_41 + value0_225;
long value0_227 = -1;
long value0_228 = value0_42 + value0_227;
double value0_229 = value0_arg4[value0_224][value0_226][value0_228];
double value0_230 = value0_222 * value0_229;
double value0_231 = value0_221 + value0_230;
double value0_232 = 2.000000e-01;
long value0_233 = 1;
long value0_234 = value0_40 + value0_233;
long value0_235 = -1;
long value0_236 = value0_41 + value0_235;
long value0_237 = 0;
long value0_238 = value0_42 + value0_237;
double value0_239 = value0_arg4[value0_234][value0_236][value0_238];
double value0_240 = value0_232 * value0_239;
double value0_241 = value0_231 + value0_240;
double value0_242 = 3.000000e-01;
long value0_243 = 1;
long value0_244 = value0_40 + value0_243;
long value0_245 = -1;
long value0_246 = value0_41 + value0_245;
long value0_247 = 1;
long value0_248 = value0_42 + value0_247;
double value0_249 = value0_arg4[value0_244][value0_246][value0_248];
double value0_250 = value0_242 * value0_249;
double value0_251 = value0_241 + value0_250;
double value0_252 = 4.000000e-01;
long value0_253 = 1;
long value0_254 = value0_40 + value0_253;
long value0_255 = 0;
long value0_256 = value0_41 + value0_255;
long value0_257 = -1;
long value0_258 = value0_42 + value0_257;
double value0_259 = value0_arg4[value0_254][value0_256][value0_258];
double value0_260 = value0_252 * value0_259;
double value0_261 = value0_251 + value0_260;
double value0_262 = 5.000000e-01;
long value0_263 = 1;
long value0_264 = value0_40 + value0_263;
long value0_265 = 0;
long value0_266 = value0_41 + value0_265;
long value0_267 = 0;
long value0_268 = value0_42 + value0_267;
double value0_269 = value0_arg4[value0_264][value0_266][value0_268];
double value0_270 = value0_262 * value0_269;
double value0_271 = value0_261 + value0_270;
double value0_272 = 6.000000e-01;
long value0_273 = 1;
long value0_274 = value0_40 + value0_273;
long value0_275 = 0;
long value0_276 = value0_41 + value0_275;
long value0_277 = 1;
long value0_278 = value0_42 + value0_277;
double value0_279 = value0_arg4[value0_274][value0_276][value0_278];
double value0_280 = value0_272 * value0_279;
double value0_281 = value0_271 + value0_280;
double value0_282 = 7.000000e-01;
long value0_283 = 1;
long value0_284 = value0_40 + value0_283;
long value0_285 = 1;
long value0_286 = value0_41 + value0_285;
long value0_287 = -1;
long value0_288 = value0_42 + value0_287;
double value0_289 = value0_arg4[value0_284][value0_286][value0_288];
double value0_290 = value0_282 * value0_289;
double value0_291 = value0_281 + value0_290;
double value0_292 = 8.000000e-01;
long value0_293 = 1;
long value0_294 = value0_40 + value0_293;
long value0_295 = 1;
long value0_296 = value0_41 + value0_295;
long value0_297 = 0;
long value0_298 = value0_42 + value0_297;
double value0_299 = value0_arg4[value0_294][value0_296][value0_298];
double value0_300 = value0_292 * value0_299;
double value0_301 = value0_291 + value0_300;
double value0_302 = 9.000000e-01;
long value0_303 = 1;
long value0_304 = value0_40 + value0_303;
long value0_305 = 1;
long value0_306 = value0_41 + value0_305;
long value0_307 = 1;
long value0_308 = value0_42 + value0_307;
double value0_309 = value0_arg4[value0_304][value0_306][value0_308];
double value0_310 = value0_302 * value0_309;
double value0_311 = value0_301 + value0_310;
long value0_312 = 0;
long value0_313 = 1;
long value0_314 = value0_40 - value0_313;
long value0_315 = value0_314 + value0_312;
long value0_316 = 1;
long value0_317 = value0_41 - value0_316;
long value0_318 = 1;
long value0_319 = value0_42 - value0_318;
                  value0_arg5[value0_315][value0_317][value0_319] = value0_311;
                  
                }
                
              }
              
            }
long value0_28 = 1;
long value0_29 = 4;
long value0_30 = value0_arg6 * value0_29;
long value0_31 = value0_30 + value0_28;
long value0_32 = 1;
long value0_33 = 8;
long value0_34 = value0_arg7 * value0_33;
long value0_35 = value0_34 + value0_32;
long value0_36 = 1;
long value0_37 = 64;
long value0_38 = value0_arg8 * value0_37;
long value0_39 = value0_38 + value0_36;
            DMA_put(value0_arg5[z_iter][0][0], value0_arg3[value0_31+z_iter][value0_35][value0_39], 4, 512*sizeof(double), 194*sizeof(double), 64*sizeof(double));
            
          }
          
        }
        
      }
      
    }
  }
void stencil_3d27pt_box_iteration(double value1_arg0[258][258][258], double value1_arg1[258][258][258]) {
long value1_0 = 0;
long value1_1 = 1;
long value1_2 = 1;
    long value1_arg2;
for ( value1_arg2 = value1_0; value1_arg2 < value1_1; value1_arg2 += value1_2 ) {
int value1_3 = mpiGetMyRank();
      stencil_3d27pt_box(value1_arg0, value1_arg1);
      exchange_halo_3D_double(value1_arg1, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, value1_3);
      stencil_3d27pt_box(value1_arg1, value1_arg0);
      exchange_halo_3D_double(value1_arg0, 258, 258, 258, 8, 4, 4, 1, 1, 1, 1, 1, 1, value1_3);
      
    }
  }
