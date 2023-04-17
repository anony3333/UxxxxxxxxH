// to run:
// nvcc -c -O3 -o 3d27pt_cu.o 3d27pt.cu && nvcc -ccbin clang 3d27pt_main.cpp 3d27pt_cu.o -lcudart -lcuda -o && ./a.out

#include <cuda.h>
#include <stdio.h>
// dsl 输入
#define M 258  
#define N 258
#define K 258
#define Halo 1

// 编译时输入（选项/uh文件）
#define gridSize_x 8 
#define gridSize_y 8
#define gridSize_z 8
#define blockSize_x 4
#define blockSize_y 4
#define blockSize_z 4

__global__ void stencil_3d27pt_kernel_1(double* input, double* output) 
{
    // u_int tx = threadIdx.x;
    // u_int ty = threadIdx.y;
    // u_int tz = threadIdx.z;
    // u_int bx = blockIdx.x;
    // u_int by = blockIdx.y;
    // u_int bz = blockIdx.z;

    // 编译时推断
    const u_int points_per_thread_x = (M - 2 * Halo) / gridSize_x / blockSize_x; 
    const u_int points_per_thread_y = (N - 2 * Halo) / gridSize_y / blockSize_y;
    const u_int points_per_thread_z = (K - 2 * Halo) / gridSize_z / blockSize_z;

    // 编译时确定
    const u_int points_per_block_x = points_per_thread_x * blockSize_x; 
    const u_int points_per_block_y = points_per_thread_y * blockSize_y;
    const u_int points_per_block_z = points_per_thread_z * blockSize_z;

    // inner tile 编译时指定
    const u_int tile_size_x = 2;
    const u_int tile_size_y = 2;
    const u_int tile_size_z = 2;
    // shared mem 
    __shared__ double in_shm[tile_size_z * blockSize_z + 2 * Halo]
                            [tile_size_y * blockSize_y + 2 * Halo]
                            [tile_size_x * blockSize_x + 2 * Halo];
    __shared__ double out_shm[tile_size_z * blockSize_z]
                            [tile_size_y * blockSize_y]
                            [tile_size_x * blockSize_x];

    double (*in)[N][K] = (double(*)[N][K])input;
    double (*out)[N][K] = (double(*)[N][K])output;

    // 编译时推断
    const u_int num_tile_z = points_per_thread_z / tile_size_z;
    const u_int num_tile_y = points_per_thread_y / tile_size_y;
    const u_int num_tile_x = points_per_thread_x / tile_size_x;

    for (u_int i_tile_z = 0; i_tile_z < num_tile_z; i_tile_z ++) {
    for (u_int i_tile_y = 0; i_tile_y < num_tile_y; i_tile_y ++) {
    for (u_int i_tile_x = 0; i_tile_x < num_tile_x; i_tile_x ++) {

        u_int iz_st = blockIdx.z * points_per_block_z + i_tile_z * tile_size_z * blockSize_z;
        u_int iy_st = blockIdx.y * points_per_block_y + i_tile_y * tile_size_y * blockSize_y;
        u_int ix_st = blockIdx.x * points_per_block_x + i_tile_x * tile_size_x * blockSize_x;

        // load shared mem
        for (u_int iz = threadIdx.z; iz < blockSize_z * tile_size_z + 2 * Halo; iz += blockSize_z) {
            for (u_int iy = threadIdx.y; iy < blockSize_y * tile_size_y + 2 * Halo; iy += blockSize_y) {
                for (u_int ix = threadIdx.x; ix < blockSize_x * tile_size_x + 2 * Halo; ix += blockSize_x) {
                    in_shm[iz][iy][ix] = in[iz_st + iz][iy_st + iy][ix_st + ix];
                }
            }
        }
        // in_shm[0][0][0] = in[1][1][1];
        __syncthreads();
        // compute
        for (u_int iz = 0; iz < tile_size_z; iz ++) {
            for (u_int iy = 0; iy < tile_size_y; iy ++) {
                for (u_int ix = 0; ix < tile_size_x; ix ++) {
                    u_int zz = iz * blockSize_z + threadIdx.z; 
                    u_int yy = iy * blockSize_y + threadIdx.y; 
                    u_int xx = ix * blockSize_x + threadIdx.x; 
                    out_shm[zz][yy][xx] = 0.1*in_shm[zz][yy][xx] 
                                        + 0.2*in_shm[zz][yy][xx+Halo] 
                                        + 0.3*in_shm[zz][yy][xx+2*Halo]
                                        + 0.4*in_shm[zz][yy+Halo][xx]
                                        + 0.5*in_shm[zz][yy+Halo][xx+Halo]
                                        + 0.6*in_shm[zz][yy+Halo][xx+2*Halo]
                                        + 0.7*in_shm[zz][yy+2*Halo][xx] 
                                        + 0.8*in_shm[zz][yy+2*Halo][xx+Halo] 
                                        + 0.9*in_shm[zz][yy+2*Halo][xx+2*Halo]
                                        // panel 1
                                        + 0.1*in_shm[zz+Halo][yy][xx] 
                                        + 0.2*in_shm[zz+Halo][yy][xx+Halo] 
                                        + 0.3*in_shm[zz+Halo][yy][xx+2*Halo]
                                        + 0.4*in_shm[zz+Halo][yy+Halo][xx] 
                                        + 0.5*in_shm[zz+Halo][yy+Halo][xx+Halo] 
                                        + 0.6*in_shm[zz+Halo][yy+Halo][xx+2*Halo]
                                        + 0.7*in_shm[zz+Halo][yy+2*Halo][xx] 
                                        + 0.8*in_shm[zz+Halo][yy+2*Halo][xx+Halo] 
                                        + 0.9*in_shm[zz+Halo][yy+2*Halo][xx+2*Halo]
                                        // panel 2
                                        + 0.1*in_shm[zz+2*Halo][yy][xx] 
                                        + 0.2*in_shm[zz+2*Halo][yy][xx+Halo] 
                                        + 0.3*in_shm[zz+2*Halo][yy][xx+2*Halo]
                                        + 0.4*in_shm[zz+2*Halo][yy+Halo][xx] 
                                        + 0.5*in_shm[zz+2*Halo][yy+Halo][xx+Halo] 
                                        + 0.6*in_shm[zz+2*Halo][yy+Halo][xx+2*Halo]
                                        + 0.7*in_shm[zz+2*Halo][yy+2*Halo][xx] 
                                        + 0.8*in_shm[zz+2*Halo][yy+2*Halo][xx+Halo] 
                                        + 0.9*in_shm[zz+2*Halo][yy+2*Halo][xx+2*Halo];
                }
            }
        }
        __syncthreads();
        // store
        for (u_int iz = threadIdx.z; iz < tile_size_z * blockSize_z; iz += blockSize_z) {
            for (u_int iy = threadIdx.y; iy < tile_size_y * blockSize_y; iy += blockSize_y) {
                for (u_int ix = threadIdx.x; ix < tile_size_x * blockSize_x; ix += blockSize_x) {
                    out[iz_st + Halo + iz ][iy_st + Halo + iy][ix_st + Halo + ix] = out_shm[iz][iy][ix];
                }
            }
        }
        // out[1][1][1] = in_shm[0][0][0];
    }
    }
    }
}

void stencil_3d27pt_box_cuda(double* input, double* output) {
    dim3 grid{gridSize_x, gridSize_y, gridSize_z};
    dim3 block{blockSize_x, blockSize_y, blockSize_z};
    stencil_3d27pt_kernel_1<<<grid, block>>>(input, output);
    stencil_3d27pt_kernel_1<<<grid, block>>>(output, input);
    cudaError_t status = cudaDeviceSynchronize();
    if (status != cudaSuccess) {
        printf("cuda error: %s\n", cudaGetErrorString(status));
    }
}