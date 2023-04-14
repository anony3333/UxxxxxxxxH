stencil stencil_2d5pt(double input[4098][4098]) {
    iteration(20)
    operation (stencil_2d5pt_kernel)

    kernel stencil_2d5pt_kernel {
        tile(32, 64)
        domain([1, 4097][1, 4097])
        expr {
            0.1*input[y-1][x] + 0.2*input[y+1][x] + 
            0.3*input[y][x] + 0.4*input[y][x+1] + 0.5*input[y][x-1]
        }
    }    
}
