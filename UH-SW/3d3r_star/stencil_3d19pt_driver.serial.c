#include <stdio.h>
#include <stdlib.h>
#include <athread.h>
#include <sys/time.h>

// 256*256*256
#define DIM_2 256
#define DIM_1 256
#define DIM_0 256
#define ITERATION 20

#define M (DIM_2+6)
#define N (DIM_1+6)
#define Q (DIM_0+6)

double input_mpe[M][N][Q], input_spe[M][N][Q];
double tmp_mpe[M][N][Q], tmp_spe[M][N][Q];

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

void stencil_3d19pt_iteration(double value_arg0[M][N][Q], double value_arg1[M][N][Q]);

void mpe_verify()
{
    int i, j, k, iter;
    // MPE 版本计算
    tic();
    for (iter = 0; iter < ITERATION/2; iter++) {
        for (i = 3; i < M-3; i++) {
            for (j = 3; j < N-3; j++) {
                for (k = 3; k < Q-3; k++) {
                    tmp_mpe[i][j][k] = 
                        0.1*input_mpe[i-3][j][k] + 0.2*input_mpe[i+3][j][k] +
                        0.3*input_mpe[i][j-3][k] + 0.4*input_mpe[i][j+3][k] +
                        0.5*input_mpe[i][j][k-3] + 0.6*input_mpe[i][j][k+3] +

                        0.1*input_mpe[i-2][j][k] + 0.2*input_mpe[i+2][j][k] +
                        0.3*input_mpe[i][j-2][k] + 0.4*input_mpe[i][j+2][k] +
                        0.5*input_mpe[i][j][k-2] + 0.6*input_mpe[i][j][k+2] +

                        0.1*input_mpe[i-1][j][k] + 0.2*input_mpe[i+1][j][k] +
                        0.3*input_mpe[i][j-1][k] + 0.4*input_mpe[i][j+1][k] +
                        0.5*input_mpe[i][j][k-1] + 0.6*input_mpe[i][j][k+1] +
                        0.7*input_mpe[i][j][k];
                }
            }
        }
        for (i = 3; i < M-3; i++) {
            for (j = 3; j < N-3; j++) {
                for (k = 3; k < Q-3; k++) {
                    input_mpe[i][j][k] = 
                        0.1*tmp_mpe[i-3][j][k] + 0.2*tmp_mpe[i+3][j][k] +
                        0.3*tmp_mpe[i][j-3][k] + 0.4*tmp_mpe[i][j+3][k] +
                        0.5*tmp_mpe[i][j][k-3] + 0.6*tmp_mpe[i][j][k+3] +
                        
                        0.1*tmp_mpe[i-2][j][k] + 0.2*tmp_mpe[i+2][j][k] +
                        0.3*tmp_mpe[i][j-2][k] + 0.4*tmp_mpe[i][j+2][k] +
                        0.5*tmp_mpe[i][j][k-2] + 0.6*tmp_mpe[i][j][k+2] +

                        0.1*tmp_mpe[i-1][j][k] + 0.2*tmp_mpe[i+1][j][k] +
                        0.3*tmp_mpe[i][j-1][k] + 0.4*tmp_mpe[i][j+1][k] +
                        0.5*tmp_mpe[i][j][k-1] + 0.6*tmp_mpe[i][j][k+1] +
                        0.7*tmp_mpe[i][j][k];
                }
            }
        }
    }
    double elapsedTime = tok();
    printf("MPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 正确性检查
    int flag = 1;
    for (i = 3; i < M-3; i++) {
        for (j = 3; j < N-3; j++) {
            for (k = 3; k < Q-3; k++) {
                double error = input_mpe[i][j][k] - input_spe[i][j][k];
                if (error > 1e-6 || error < -1e-6) {
                    printf("mpe-->spe: (%d, %d, %d) --> (%lf - %lf = %lf)\n", i, j, k,
                        input_mpe[i][j][k], input_spe[i][j][k], error);
                    flag = 0;
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
    int i, j, k;
    athread_init();

    // 初始化输入
    printf("Initializing data...\n");
    for (i = 0; i < M; i++) {
        for (j = 0; j < N; j++) {
            for (k = 0; k < Q; k++) {
                double value = rand() % 50;
                input_mpe[i][j][k] = value;
                input_spe[i][j][k] = value;
                tmp_mpe[i][j][k] = value;
                tmp_spe[i][j][k] = value;
            }
        }
    }

    // 启用从核计算
    printf("spe computing...\n");
    tic();
    stencil_3d19pt_iteration(input_spe, tmp_spe);
    double elapsedTime = tok();
    printf("SPE elapsed Time: %lf (ms)\n", elapsedTime);

    // 检查结果正确性
    printf("mpe computing\n");
    mpe_verify();
    athread_halt();

    exit(EXIT_SUCCESS);
}
