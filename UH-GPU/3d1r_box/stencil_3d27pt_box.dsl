stencil stencil_3d27pt(double input[514][514][514]) {
    iteration(4)
    operation (stencil_3d27pt_kernel)

    kernel stencil_3d27pt_kernel {
        tile(8, 8, 8)
        domain([1, 513][1, 513][1,513])
        expr {
            0.1*input[z-1][y-1][x-1] + 0.2*input[z-1][y-1][x] + 0.3*input[z-1][y-1][x+1] + 
            0.1*input[z-1][y][x-1] + 0.2*input[z-1][y][x] + 0.3*input[z-1][y][x+1] +
            0.1*input[z-1][y+1][x-1] + 0.2*input[z-1][y+1][x] + 0.3*input[z-1][y+1][x+1] +

            0.1*input[z][y-1][x-1] + 0.2*input[z][y-1][x] + 0.3*input[z][y-1][x+1] + 
            0.1*input[z][y][x-1] + 0.2*input[z][y][x] + 0.3*input[z][y][x+1] +
            0.1*input[z][y+1][x-1] + 0.2*input[z][y+1][x] + 0.3*input[z][y+1][x+1] +

            0.1*input[z+1][y-1][x-1] + 0.2*input[z+1][y-1][x] + 0.3*input[z+1][y-1][x+1] + 
            0.1*input[z+1][y][x-1] + 0.2*input[z+1][y][x] + 0.3*input[z+1][y][x+1] +
            0.1*input[z+1][y+1][x-1] + 0.2*input[z+1][y+1][x] + 0.3*input[z+1][y+1][x+1]
        }
    }    
}
