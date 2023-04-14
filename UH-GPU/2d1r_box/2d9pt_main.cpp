#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <cuda.h>
#include <cuda_runtime.h>

#define DIM_1 8192
#define DIM_0 8192
#define ITERATION 4

#define M (DIM_1+2)
#define N (DIM_0+2)


struct TwoDMemrefF64 {
  double *ptrToData;
  double *alignedPtrToData;
  long offset;
  long shape[2];
  long stride[2];
};

extern "C" {void _mlir_ciface_stencil_2d9pt_iteration(struct TwoDMemrefF64 *, struct TwoDMemrefF64 *);}

double (*input_cpu)[N];
double (*input_gpu)[N];
double (*tmp_cpu)[N];
double (*tmp_device)[N];

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


void cpu_verify()
{
    int i, j, iter;
    // cpu 版本计算
    tic();
    for (iter = 0; iter < ITERATION/2; iter++) {
        for (i = 1; i < M-1; i++) {
            for (j = 1; j < N-1; j++) {
                tmp_cpu[i][j] = \
                    0.1*input_cpu[i-1][j-1] + 0.1*input_cpu[i+1][j-1] + 
                    0.2*input_cpu[i-1][j] + 0.2*input_cpu[i+1][j] + 
                    0.3*input_cpu[i-1][j+1] + 0.3*input_cpu[i+1][j+1] + 
                    0.4*input_cpu[i][j] + 0.5*input_cpu[i][j+1] + 0.6*input_cpu[i][j-1];
            }
        }
        for (i = 1; i < M-1; i++) {
            for (j = 1; j < N-1; j++) {
                input_cpu[i][j] = \
                    0.1*tmp_cpu[i-1][j-1] + 0.1*tmp_cpu[i+1][j-1] + 
                    0.2*tmp_cpu[i-1][j] + 0.2*tmp_cpu[i+1][j] + 
                    0.3*tmp_cpu[i-1][j+1] + 0.3*tmp_cpu[i+1][j+1] + 
                    0.4*tmp_cpu[i][j] + 0.5*tmp_cpu[i][j+1] + 0.6*tmp_cpu[i][j-1];
            }
        }
    }
    double elapsedTime = tok();
    printf("cpu elapsed Time: %lf (ms)\n", elapsedTime);

    // 正确性检查
    int flag = 1;
    for (i = 1; i < M-1; i++) {
        for (j = 1; j < N-1; j++) {
            double error = input_cpu[i][j] - input_gpu[i][j];
            if (error > 1e-6 || error < -1e-6) {
                printf("cpu-->gpu: (%d, %d) --> (%lf - %lf = %lf)\n", i, j,
                    input_cpu[i][j], input_gpu[i][j], error);
                flag = 0;
                goto exit;
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
    double* input_cpu_ = (double*)malloc(sizeof(double) * M * N );
    input_cpu = (double (*)[N])input_cpu_;

    double* tmp_cpu_ = (double*)malloc(sizeof(double) * M * N );
    tmp_cpu = (double (*)[N])tmp_cpu_;

    double* input_host_ = (double*)malloc(sizeof(double) * M * N );
    input_gpu = (double (*)[N])input_host_;
    
    double* input_device_;
    cudaMalloc(&input_device_, sizeof(double) * M * N );
    double* tmp_device_;
    cudaMalloc(&tmp_device_, sizeof(double) * M * N );

    // 初始化输入
    printf("Initializing data...\n");
    for (i = 0; i < M; i++) {
        for (j = 0; j < N; j++) {
                double value = rand() % 50;
                input_cpu[i][j] = value;
                input_gpu[i][j] = value;
        }
    }

    // copy input data to device
    cudaMemcpy(input_device_, input_host_, sizeof(double) * M * N, cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();

    struct TwoDMemrefF64 A_mem = {input_device_, input_device_, 0, {M, N}, {N, 1}};
    struct TwoDMemrefF64 B_mem = {tmp_device_, tmp_device_, 0, {M, N}, {N, 1}};
    tic();
    _mlir_ciface_stencil_2d9pt_iteration(&A_mem, &B_mem);
    cudaDeviceSynchronize();
    double elapsedTime = tok();

    // copy the result from device to host
    cudaMemcpy(input_host_, input_device_, sizeof(double) * M * N,  cudaMemcpyDeviceToHost);
    printf("device elapsed Time: %lf (ms)\n", elapsedTime);

    // 检查结果正确性
    printf("cpu computing\n");
    cpu_verify();
    return 0;

}
