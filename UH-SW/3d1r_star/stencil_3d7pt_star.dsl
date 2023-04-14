stencil stencil_3d7pt(double input[258][258][258]) {
    iteration(20)
    operation (stencil_3d7pt_kernel)

    kernel stencil_3d7pt_kernel {
        tile(8, 8, 8)
        domain([1, 257][1, 257][1,257])
        expr {
            0.1*input[z-1][y][x] + 0.2*input[z+1][y][x] +
            0.3*input[z][y-1][x] + 0.4*input[z][y+1][x] +
            0.5*input[z][y][x-1] + 0.6*input[z][y][x+1] +
            0.7*input[z][y][x]
        }
    }    
}
