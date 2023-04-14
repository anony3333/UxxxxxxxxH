#include <stdio.h>
#include <stdlib.h>
#include <athread.h>
#include <sys/time.h>

// 4096*4096
#define DIM_1 4096
#define DIM_0 4096
#define ITERATION 20

#define M (DIM_1+4)
#define N (DIM_0+4)

double input_mpe[M][N], input_spe[M][N];
double tmp_mpe[M][N], tmp_spe[M][N];

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

void stencil_2d9pt_iteration(double value_arg0[M][N], double value_arg1[M][N]);

void mpe_verify()
{
    int i, j, k, iter;
    // MPE 版本计算
    tic();
    for (iter = 0; iter < ITERATION/2; iter++) {
        for (i = 2; i < M-2; i++) {
            for (j = 2; j < N-2; j++) {
                    tmp_mpe[i][j] = 
            0.1*input_mpe[i-2][j] + 0.2*input_mpe[i+2][j] +
            0.3*input_mpe[i-1][j] + 0.4*input_mpe[i+1][j] + 
            0.5*input_mpe[i][j] + 
            0.6*input_mpe[i][j+1] + 0.7*input_mpe[i][j-1] +
            0.8*input_mpe[i][j+2] + 0.9*input_mpe[i][j-2];
            }
        }
        for (i = 2; i < M-2; i++) {
            for (j = 2; j < N-2; j++) {
                    input_mpe[i][j] = 
            0.1*tmp_mpe[i-2][j] + 0.2*tmp_mpe[i+2][j] +
            0.3*tmp_mpe[i-1][j] + 0.4*tmp_mpe[i+1][j] + 
            0.5*tmp_mpe[i][j] + 
            0.6*tmp_mpe[i][j+1] + 0.7*tmp_mpe[i][j-1] +
            0.8*tmp_mpe[i][j+2] + 0.9*tmp_mpe[i][j-2];
            }
        }
        
    }
    double elapsedTime = tok();
    printf("MPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 正确性检查
    int flag = 1;
    for (i = 2; i < M-2; i++) {
        for (j = 2; j < N-2; j++) {
                double error = input_mpe[i][j] - input_spe[i][j];
                if (error > 1e-6 || error < -1e-6) {
                    printf("mpe-->spe: (%d, %d, %d) --> (%lf - %lf = %lf)\n", i, j, k,
                        input_mpe[i][j], input_spe[i][j], error);
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
    int i, j, k;
    athread_init();

    // 初始化输入
    printf("Initializing data...\n");
    for (i = 0; i < M; i++) {
        for (j = 0; j < N; j++) {
                double value = rand() % 50;
                input_mpe[i][j] = value;
                input_spe[i][j] = value;
                tmp_mpe[i][j] = value;
                tmp_spe[i][j] = value;
            }
        }
    

    // 启用从核计算
    printf("spe computing...\n");
    tic();
    stencil_2d9pt_iteration(input_spe, tmp_spe);
    double elapsedTime = tok();
    printf("SPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 检查结果正确性
    printf("mpe computing\n");
    mpe_verify();
    athread_halt();

    exit(EXIT_SUCCESS);
}
