#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda.h>
#include <cuda_runtime.h>

// 256*256*256
#define DIM_2 256
#define DIM_1 256
#define DIM_0 256
#define ITERATION 2

#define M (DIM_2+2)
#define N (DIM_1+2)
#define Q (DIM_0+2)


struct ThreeDMemrefF64 {
  double *ptrToData;
  double *alignedPtrToData;
  long offset;
  long shape[3];
  long stride[3];
};

extern "C" {void _mlir_ciface_stencil_3d27pt_box_iteration(struct ThreeDMemrefF64 *, struct ThreeDMemrefF64 *);}

// double input_mpe[M][N][Q], input_spe[M][N][Q];
// double tmp_mpe[M][N][Q], tmp_spe[M][N][Q];
double (*input_mpe)[N][Q];
double (*input_spe)[N][Q];
double (*tmp_mpe)[N][Q];
double (*tmp_spe)[N][Q];

// 计时辅助函数
struct timeval begin, end;

void tic()
{
    gettimeofday(&begin, NULL);
}

// 返回tic到tok之间的毫秒数
double tok()
{
    gettimeofday(&end, NULL);
    double elapsedTime = (end.tv_sec - begin.tv_sec)*1e3 + \
            (end.tv_usec - begin.tv_usec)*1e-3;
    return elapsedTime;
}


void mpe_verify()
{
    int i, j, k, iter;
    // MPE 版本计算
    tic();
    for (iter = 0; iter < ITERATION/2; iter++) {
        for (i = 1; i < M-1; i++) {
            for (j = 1; j < N-1; j++) {
                for (k = 1; k < Q-1; k++) {
                    tmp_mpe[i][j][k] =\
            0.1*input_mpe[i-1][j-1][k-1] + 0.2*input_mpe[i-1][j-1][k] + 0.3*input_mpe[i-1][j-1][k+1]
            + 0.4*input_mpe[i-1][j][k-1] + 0.5*input_mpe[i-1][j][k] + 0.6*input_mpe[i-1][j][k+1]
            + 0.7*input_mpe[i-1][j+1][k-1] + 0.8*input_mpe[i-1][j+1][k] + 0.9*input_mpe[i-1][j+1][k+1]
            
            // panel 1
            + 0.1*input_mpe[i][j-1][k-1] + 0.2*input_mpe[i][j-1][k] + 0.3*input_mpe[i][j-1][k+1]
            + 0.4*input_mpe[i][j][k-1] + 0.5*input_mpe[i][j][k] + 0.6*input_mpe[i][j][k+1]
            + 0.7*input_mpe[i][j+1][k-1] + 0.8*input_mpe[i][j+1][k] + 0.9*input_mpe[i][j+1][k+1]

            // panel 2
            + 0.1*input_mpe[i+1][j-1][k-1] + 0.2*input_mpe[i+1][j-1][k] + 0.3*input_mpe[i+1][j-1][k+1]
            + 0.4*input_mpe[i+1][j][k-1] + 0.5*input_mpe[i+1][j][k] + 0.6*input_mpe[i+1][j][k+1]
            + 0.7*input_mpe[i+1][j+1][k-1] + 0.8*input_mpe[i+1][j+1][k] + 0.9*input_mpe[i+1][j+1][k+1];
 
                }
            }
        }
        for (i = 1; i < M-1; i++) {
            for (j = 1; j < N-1; j++) {
                for (k = 1; k < Q-1; k++) {
                    input_mpe[i][j][k] =\
                         // panel 0
            0.1*tmp_mpe[i-1][j-1][k-1] + 0.2*tmp_mpe[i-1][j-1][k] + 0.3*tmp_mpe[i-1][j-1][k+1]
            + 0.4*tmp_mpe[i-1][j][k-1] + 0.5*tmp_mpe[i-1][j][k] + 0.6*tmp_mpe[i-1][j][k+1]
            + 0.7*tmp_mpe[i-1][j+1][k-1] + 0.8*tmp_mpe[i-1][j+1][k] + 0.9*tmp_mpe[i-1][j+1][k+1]
            
            // panel 1
            + 0.1*tmp_mpe[i][j-1][k-1] + 0.2*tmp_mpe[i][j-1][k] + 0.3*tmp_mpe[i][j-1][k+1]
            + 0.4*tmp_mpe[i][j][k-1] + 0.5*tmp_mpe[i][j][k] + 0.6*tmp_mpe[i][j][k+1]
            + 0.7*tmp_mpe[i][j+1][k-1] + 0.8*tmp_mpe[i][j+1][k] + 0.9*tmp_mpe[i][j+1][k+1]

            // panel 2
            + 0.1*tmp_mpe[i+1][j-1][k-1] + 0.2*tmp_mpe[i+1][j-1][k] + 0.3*tmp_mpe[i+1][j-1][k+1]
            + 0.4*tmp_mpe[i+1][j][k-1] + 0.5*tmp_mpe[i+1][j][k] + 0.6*tmp_mpe[i+1][j][k+1]
            + 0.7*tmp_mpe[i+1][j+1][k-1] + 0.8*tmp_mpe[i+1][j+1][k] + 0.9*tmp_mpe[i+1][j+1][k+1];
                }
            }
        }
    }
    double elapsedTime = tok();
    printf("MPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 正确性检查
    int flag = 1;
    for (i = 1; i < M-1; i++) {
        for (j = 1; j < N-1; j++) {
            for (k = 1; k < Q-1; k++) {
                double error = input_mpe[i][j][k] - input_spe[i][j][k];
                if (error > 1e-6 || error < -1e-6) {
                    flag = 0;
                    printf("(%d, %d, %d)-->(%lf - %lf = %lf)\n", i, j, k, 
                            input_mpe[i][j][k], input_spe[i][j][k], error);
                    goto exit;
                }
            }
        }
    }

exit:
    if (flag) 
        printf("Verfiy Success\n");
    else 
        printf("Verify Failed\n");
}

int main(int argc, char *argv[])
{

    CUcontext cuContext;
    CUdevice cuDevice;
    CUmodule cuModule;

    cuInit(0);
    cuDeviceGet(&cuDevice, 0);
    cuCtxCreate(&cuContext, 0, cuDevice);

    int i, j, k;
    double* input_mpe_;
    double* input_spe_;
    double* tmp_mpe_;
    double* tmp_spe_;
    cudaMallocHost(&input_mpe_, sizeof(double) * M * N * Q );
    cudaMallocHost(&input_spe_, sizeof(double) * M * N * Q );
    cudaMallocHost(&tmp_mpe_, sizeof(double) * M * N * Q );
    cudaMallocHost(&tmp_spe_, sizeof(double) * M * N * Q );
    
    input_mpe = (double (*)[N][Q])input_mpe_;
    input_spe = (double (*)[N][Q])input_spe_;
    tmp_mpe = (double (*)[N][Q])tmp_mpe_;
    tmp_spe = (double (*)[N][Q])tmp_spe_;

    // 初始化输入
    printf("Initializing data...\n");
    for (i = 0; i < M; i++) {
        for (j = 0; j < N; j++) {
            for (k = 0; k < Q; k++) {
                double value = rand() * 1.0 / RAND_MAX;
                input_mpe[i][j][k] = value;
                input_spe[i][j][k] = value;
                tmp_mpe[i][j][k] = value;
                tmp_spe[i][j][k] = value;
            }
        }
    }

    struct ThreeDMemrefF64 A_mem = {input_spe_, input_spe_, 0, {M, N, Q}, {N*Q, Q, 1}};
    struct ThreeDMemrefF64 B_mem = {tmp_spe_, tmp_spe_, 0, {M, N, Q}, {N*Q, Q, 1}};
    tic();
    _mlir_ciface_stencil_3d27pt_box_iteration(&A_mem, &B_mem);
    double elapsedTime = tok();
    printf("SPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 检查结果正确性
    printf("mpe computing\n");
    mpe_verify();
    return 0;

}
