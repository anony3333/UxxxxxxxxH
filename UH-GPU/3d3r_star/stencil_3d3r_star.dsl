stencil stencil_3d3r(double input[518][518][518]) {
    iteration(4)
    operation (stencil_3d3r_kernel)

    kernel stencil_3d3r_kernel {
        tile(8, 8, 8)
        domain([3, 515][3, 515][3,515])
        expr {
            0.1*input[z-3][y][x] + 0.1*input[z+3][y][x] +
            0.1*input[z][y-3][x] + 0.1*input[z][y+3][x] +
            0.1*input[z][y][x-3] + 0.1*input[z][y][x+3] +

            0.1*input[z-2][y][x] + 0.1*input[z+2][y][x] +
            0.1*input[z][y-2][x] + 0.1*input[z][y+2][x] +
            0.1*input[z][y][x-2] + 0.1*input[z][y][x+2] +

            0.1*input[z-1][y][x] + 0.1*input[z+1][y][x] +
            0.1*input[z][y-1][x] + 0.1*input[z][y+1][x] +
            0.1*input[z][y][x-1] + 0.1*input[z][y][x+1] +
            0.1*input[z][y][x]
        }
    }    
}
