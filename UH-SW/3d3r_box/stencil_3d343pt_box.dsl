stencil stencil_3d343pt(double input[262][262][262]) {
    iteration(20)
    operation (stencil_3d343pt_kernel)

    kernel stencil_3d343pt_kernel {
        tile(8, 8, 8)
        domain([3, 259][3, 259][3,259])
        expr {
            0.01*input[z-3][y-3][x-3] + 0.02*input[z-3][y-3][x-2] + 0.03*input[z-3][y-3][x-1] + 0.04*input[z-3][y-3][x] + 0.05*input[z-3][y-3][x+1] + 0.06*input[z-3][y-3][x+2] + 0.07*input[z-3][y-3][x+3] +
            0.01*input[z-3][y-2][x-3] + 0.02*input[z-3][y-2][x-2] + 0.03*input[z-3][y-2][x-1] + 0.04*input[z-3][y-2][x] + 0.05*input[z-3][y-2][x+1] + 0.06*input[z-3][y-2][x+2] + 0.07*input[z-3][y-2][x+3] +
            0.01*input[z-3][y-1][x-3] + 0.02*input[z-3][y-1][x-2] + 0.03*input[z-3][y-1][x-1] + 0.04*input[z-3][y-1][x] + 0.05*input[z-3][y-1][x+1] + 0.06*input[z-3][y-1][x+2] + 0.07*input[z-3][y-1][x+3] +
            0.01*input[z-3][y][x-3] + 0.02*input[z-3][y][x-2] + 0.03*input[z-3][y][x-1] + 0.04*input[z-3][y][x] + 0.05*input[z-3][y][x+1] + 0.06*input[z-3][y][x+2] + 0.07*input[z-3][y][x+3] +
            0.01*input[z-3][y+1][x-3] + 0.02*input[z-3][y+1][x-2] + 0.03*input[z-3][y+1][x-1] + 0.04*input[z-3][y+1][x] + 0.05*input[z-3][y+1][x+1] + 0.06*input[z-3][y+1][x+2] + 0.07*input[z-3][y+1][x+3] +
            0.01*input[z-3][y+2][x-3] + 0.02*input[z-3][y+2][x-2] + 0.03*input[z-3][y+2][x-1] + 0.04*input[z-3][y+2][x] + 0.05*input[z-3][y+2][x+1] + 0.06*input[z-3][y+2][x+2] + 0.07*input[z-3][y+2][x+3] +
            0.01*input[z-3][y+3][x-3] + 0.02*input[z-3][y+3][x-2] + 0.03*input[z-3][y+3][x-1] + 0.04*input[z-3][y+3][x] + 0.05*input[z-3][y+3][x+1] + 0.06*input[z-3][y+3][x+2] + 0.07*input[z-3][y+3][x+3] +
            0.01*input[z-2][y-3][x-3] + 0.02*input[z-2][y-3][x-2] + 0.03*input[z-2][y-3][x-1] + 0.04*input[z-2][y-3][x] + 0.05*input[z-2][y-3][x+1] + 0.06*input[z-2][y-3][x+2] + 0.07*input[z-2][y-3][x+3] +
            0.01*input[z-2][y-2][x-3] + 0.02*input[z-2][y-2][x-2] + 0.03*input[z-2][y-2][x-1] + 0.04*input[z-2][y-2][x] + 0.05*input[z-2][y-2][x+1] + 0.06*input[z-2][y-2][x+2] + 0.07*input[z-2][y-2][x+3] +
            0.01*input[z-2][y-1][x-3] + 0.02*input[z-2][y-1][x-2] + 0.03*input[z-2][y-1][x-1] + 0.04*input[z-2][y-1][x] + 0.05*input[z-2][y-1][x+1] + 0.06*input[z-2][y-1][x+2] + 0.07*input[z-2][y-1][x+3] +
            0.01*input[z-2][y][x-3] + 0.02*input[z-2][y][x-2] + 0.03*input[z-2][y][x-1] + 0.04*input[z-2][y][x] + 0.05*input[z-2][y][x+1] + 0.06*input[z-2][y][x+2] + 0.07*input[z-2][y][x+3] +
            0.01*input[z-2][y+1][x-3] + 0.02*input[z-2][y+1][x-2] + 0.03*input[z-2][y+1][x-1] + 0.04*input[z-2][y+1][x] + 0.05*input[z-2][y+1][x+1] + 0.06*input[z-2][y+1][x+2] + 0.07*input[z-2][y+1][x+3] +
            0.01*input[z-2][y+2][x-3] + 0.02*input[z-2][y+2][x-2] + 0.03*input[z-2][y+2][x-1] + 0.04*input[z-2][y+2][x] + 0.05*input[z-2][y+2][x+1] + 0.06*input[z-2][y+2][x+2] + 0.07*input[z-2][y+2][x+3] +
            0.01*input[z-2][y+3][x-3] + 0.02*input[z-2][y+3][x-2] + 0.03*input[z-2][y+3][x-1] + 0.04*input[z-2][y+3][x] + 0.05*input[z-2][y+3][x+1] + 0.06*input[z-2][y+3][x+2] + 0.07*input[z-2][y+3][x+3] +
            0.01*input[z-1][y-3][x-3] + 0.02*input[z-1][y-3][x-2] + 0.03*input[z-1][y-3][x-1] + 0.04*input[z-1][y-3][x] + 0.05*input[z-1][y-3][x+1] + 0.06*input[z-1][y-3][x+2] + 0.07*input[z-1][y-3][x+3] +
            0.01*input[z-1][y-2][x-3] + 0.02*input[z-1][y-2][x-2] + 0.03*input[z-1][y-2][x-1] + 0.04*input[z-1][y-2][x] + 0.05*input[z-1][y-2][x+1] + 0.06*input[z-1][y-2][x+2] + 0.07*input[z-1][y-2][x+3] +
            0.01*input[z-1][y-1][x-3] + 0.02*input[z-1][y-1][x-2] + 0.03*input[z-1][y-1][x-1] + 0.04*input[z-1][y-1][x] + 0.05*input[z-1][y-1][x+1] + 0.06*input[z-1][y-1][x+2] + 0.07*input[z-1][y-1][x+3] +
            0.01*input[z-1][y][x-3] + 0.02*input[z-1][y][x-2] + 0.03*input[z-1][y][x-1] + 0.04*input[z-1][y][x] + 0.05*input[z-1][y][x+1] + 0.06*input[z-1][y][x+2] + 0.07*input[z-1][y][x+3] +
            0.01*input[z-1][y+1][x-3] + 0.02*input[z-1][y+1][x-2] + 0.03*input[z-1][y+1][x-1] + 0.04*input[z-1][y+1][x] + 0.05*input[z-1][y+1][x+1] + 0.06*input[z-1][y+1][x+2] + 0.07*input[z-1][y+1][x+3] +
            0.01*input[z-1][y+2][x-3] + 0.02*input[z-1][y+2][x-2] + 0.03*input[z-1][y+2][x-1] + 0.04*input[z-1][y+2][x] + 0.05*input[z-1][y+2][x+1] + 0.06*input[z-1][y+2][x+2] + 0.07*input[z-1][y+2][x+3] +
            0.01*input[z-1][y+3][x-3] + 0.02*input[z-1][y+3][x-2] + 0.03*input[z-1][y+3][x-1] + 0.04*input[z-1][y+3][x] + 0.05*input[z-1][y+3][x+1] + 0.06*input[z-1][y+3][x+2] + 0.07*input[z-1][y+3][x+3] +
            0.01*input[z][y-3][x-3] + 0.02*input[z][y-3][x-2] + 0.03*input[z][y-3][x-1] + 0.04*input[z][y-3][x] + 0.05*input[z][y-3][x+1] + 0.06*input[z][y-3][x+2] + 0.07*input[z][y-3][x+3] +
            0.01*input[z][y-2][x-3] + 0.02*input[z][y-2][x-2] + 0.03*input[z][y-2][x-1] + 0.04*input[z][y-2][x] + 0.05*input[z][y-2][x+1] + 0.06*input[z][y-2][x+2] + 0.07*input[z][y-2][x+3] +
            0.01*input[z][y-1][x-3] + 0.02*input[z][y-1][x-2] + 0.03*input[z][y-1][x-1] + 0.04*input[z][y-1][x] + 0.05*input[z][y-1][x+1] + 0.06*input[z][y -1][x+2] + 0.07*input[z][y-1][x+3] +
            0.01*input[z][y][x-3] + 0.02*input[z][y][x-2] + 0.03*input[z][y][x-1] + 0.04*input[z][y][x] + 0.05*input[z][y][x+1] + 0.06*input[z][y][x+2] + 0.07*input[z][y][x+3] +
            0.01*input[z][y+1][x-3] + 0.02*input[z][y+1][x-2] + 0.03*input[z][y+1][x-1] + 0.04*input[z][y+1][x] + 0.05*input[z][y+1][x+1] + 0.06*input[z][y+1][x+2] + 0.07*input[z][y+1][x+3] +
            0.01*input[z][y+2][x-3] + 0.02*input[z][y+2][x-2] + 0.03*input[z][y+2][x-1] + 0.04*input[z][y+2][x] + 0.05*input[z][y+2][x+1] + 0.06*input[z][y+2][x+2] + 0.07*input[z][y+2][x+3] +
            0.01*input[z][y+3][x-3] + 0.02*input[z][y+3][x-2] + 0.03*input[z][y+3][x-1] + 0.04*input[z][y+3][x] + 0.05*input[z][y+3][x+1] + 0.06*input[z][y+3][x+2] + 0.07*input[z][y+3][x+3] +
            0.01*input[z+1][y-3][x-3] + 0.02*input[z+1][y-3][x-2] + 0.03*input[z+1][y-3][x-1] + 0.04*input[z+1][y-3][x] + 0.05*input[z+1][y-3][x+1] + 0.06*input[z+1][y-3][x+2] + 0.07*input[z+1][y-3][x+3] +
            0.01*input[z+1][y-2][x-3] + 0.02*input[z+1][y-2][x-2] + 0.03*input[z+1][y-2][x-1] + 0.04*input[z+1][y-2][x] + 0.05*input[z+1][y-2][x+1] + 0.06*input[z+1][y-2][x+2] + 0.07*input[z+1][y-2][x+3] +
            0.01*input[z+1][y-1][x-3] + 0.02*input[z+1][y-1][x-2] + 0.03*input[z+1][y-1][x-1] + 0.04*input[z+1][y-1][x] + 0.05*input[z+1][y-1][x+1] + 0.06*input[z+1][y-1][x+2] + 0.07*input[z+1][y-1][x+3] +
            0.01*input[z+1][y][x-3] + 0.02*input[z+1][y][x-2] + 0.03*input[z+1][y][x-1] + 0.04*input[z+1][y][x] + 0.05*input[z+1][y][x+1] + 0.06*input[z+1][y][x+2] + 0.07*input[z+1][y][x+3] +
            0.01*input[z+1][y+1][x-3] + 0.02*input[z+1][y+1][x-2] + 0.03*input[z+1][y+1][x-1] + 0.04*input[z+1][y+1][x] + 0.05*input[z+1][y+1][x+1] + 0.06*input[z+1][y+1][x+2] + 0.07*input[z+1][y+1][x+3] +
            0.01*input[z+1][y+2][x-3] + 0.02*input[z+1][y+2][x-2] + 0.03*input[z+1][y+2][x-1] + 0.04*input[z+1][y+2][x] + 0.05*input[z+1][y+2][x+1] + 0.06*input[z+1][y+2][x+2] + 0.07*input[z+1][y+2][x+3] +
            0.01*input[z+1][y+3][x-3] + 0.02*input[z+1][y+3][x-2] + 0.03*input[z+1][y+3][x-1] + 0.04*input[z+1][y+3][x] + 0.05*input[z+1][y+3][x+1] + 0.06*input[z+1][y+3][x+2] + 0.07*input[z+1][y+3][x+3] +
            0.01*input[z+2][y-3][x-3] + 0.02*input[z+2][y-3][x-2] + 0.03*input[z+2][y-3][x-1] + 0.04*input[z+2][y-3][x] + 0.05*input[z+2][y-3][x+1] + 0.06*input[z+2][y-3][x+2] + 0.07*input[z+2][y-3][x+3] +
            0.01*input[z+2][y-2][x-3] + 0.02*input[z+2][y-2][x-2] + 0.03*input[z+2][y-2][x-1] + 0.04*input[z+2][y-2][x] + 0.05*input[z+2][y-2][x+1] + 0.06*input[z+2][y-2][x+2] + 0.07*input[z+2][y-2][x+3] +
            0.01*input[z+2][y-1][x-3] + 0.02*input[z+2][y-1][x-2] + 0.03*input[z+2][y-1][x-1] + 0.04*input[z+2][y-1][x] + 0.05*input[z+2][y-1][x+1] + 0.06*input[z+2][y-1][x+2] + 0.07*input[z+2][y-1][x+3] +
            0.01*input[z+2][y][x-3] + 0.02*input[z+2][y][x-2] + 0.03*input[z+2][y][x-1] + 0.04*input[z+2][y][x] + 0.05*input[z+2][y][x+1] + 0.06*input[z+2][y][x+2] + 0.07*input[z+2][y][x+3] +
            0.01*input[z+2][y+1][x-3] + 0.02*input[z+2][y+1][x-2] + 0.03*input[z+2][y+1][x-1] + 0.04*input[z+2][y+1][x] + 0.05*input[z+2][y+1][x+1] + 0.06*input[z+2][y+1][x+2] + 0.07*input[z+2][y+1][x+3] +
            0.01*input[z+2][y+2][x-3] + 0.02*input[z+2][y+2][x-2] + 0.03*input[z+2][y+2][x-1] + 0.04*input[z+2][y+2][x] + 0.05*input[z+2][y+2][x+1] + 0.06*input[z+2][y+2][x+2] + 0.07*input[z+2][y+2][x+3] +
            0.01*input[z+2][y+3][x-3] + 0.02*input[z+2][y+3][x-2] + 0.03*input[z+2][y+3][x-1] + 0.04*input[z+2][y+3][x] + 0.05*input[z+2][y+3][x+1] + 0.06*input[z+2][y+3][x+2] + 0.07*input[z+2][y+3][x+3] +
            0.01*input[z+3][y-3][x-3] + 0.02*input[z+3][y-3][x-2] + 0.03*input[z+3][y-3][x-1] + 0.04*input[z+3][y-3][x] + 0.05*input[z+3][y-3][x+1] + 0.06*input[z+3][y-3][x+2] + 0.07*input[z+3][y-3][x+3] +
            0.01*input[z+3][y-2][x-3] + 0.02*input[z+3][y-2][x-2] + 0.03*input[z+3][y-2][x-1] + 0.04*input[z+3][y-2][x] + 0.05*input[z+3][y-2][x+1] + 0.06*input[z+3][y-2][x+2] + 0.07*input[z+3][y-2][x+3] +
            0.01*input[z+3][y-1][x-3] + 0.02*input[z+3][y-1][x-2] + 0.03*input[z+3][y-1][x-1] + 0.04*input[z+3][y-1][x] + 0.05*input[z+3][y-1][x+1] + 0.06*input[z+3][y-1][x+2] + 0.07*input[z+3][y-1][x+3] +
            0.01*input[z+3][y][x-3] + 0.02*input[z+3][y][x-2] + 0.03*input[z+3][y][x-1] + 0.04*input[z+3][y][x] + 0.05*input[z+3][y][x+1] + 0.06*input[z+3][y][x+2] + 0.07*input[z+3][y][x+3] +
            0.01*input[z+3][y+1][x-3] + 0.02*input[z+3][y+1][x-2] + 0.03*input[z+3][y+1][x-1] + 0.04*input[z+3][y+1][x] + 0.05*input[z+3][y+1][x+1] + 0.06*input[z+3][y+1][x+2] + 0.07*input[z+3][y+1][x+3] +
            0.01*input[z+3][y+2][x-3] + 0.02*input[z+3][y+2][x-2] + 0.03*input[z+3][y+2][x-1] + 0.04*input[z+3][y+2][x] + 0.05*input[z+3][y+2][x+1] + 0.06*input[z+3][y+2][x+2] + 0.07*input[z+3][y+2][x+3] +
            0.01*input[z+3][y+3][x-3] + 0.02*input[z+3][y+3][x-2] + 0.03*input[z+3][y+3][x-1] + 0.04*input[z+3][y+3][x] + 0.05*input[z+3][y+3][x+1] + 0.06*input[z+3][y+3][x+2] + 0.07*input[z+3][y+3][x+3]


        }
    }    
}
