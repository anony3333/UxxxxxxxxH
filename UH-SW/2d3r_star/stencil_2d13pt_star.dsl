stencil stencil_2d13pt(double input[4102][4102]) {
    iteration(20)
    operation (stencil_2d13pt_kernel)

    kernel stencil_2d13pt_kernel {
        tile(32, 64)
        domain([3, 4099][3, 4099])
        expr {
            0.1*input[y-3][x] + 0.2*input[y-2][x] + 0.3*input[y-1][x] + 
            0.4*input[y][x] + 0.5*input[y+1][x] + 0.6*input[y+2][x] + 0.7*input[y+3][x] +
             0.8*input[y][x-3] + 0.9*input[y][x-2] + 1.0*input[y][x-1] + 
             1.1*input[y][x+1] + 1.2*input[y][x+2] + 1.3*input[y][x+3]
        }
    }    
}
