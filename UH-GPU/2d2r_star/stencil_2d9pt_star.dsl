stencil stencil_2d9pt(double input[8196][8196]) {
    iteration(4)
    operation (stencil_2d9pt_kernel)

    kernel stencil_2d9pt_kernel {
        tile(32, 64)
        domain([2, 8194][2, 8194])
        expr {
            0.1*input[y-2][x] + 0.2*input[y+2][x] +
            0.3*input[y-1][x] + 0.4*input[y+1][x] + 
            0.5*input[y][x] + 
            0.6*input[y][x+1] + 0.7*input[y][x-1] +
            0.8*input[y][x+2] + 0.9*input[y][x-2]
        }
    }    
}
