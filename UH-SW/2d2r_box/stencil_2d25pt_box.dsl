stencil stencil_2d25pt(double input[4100][4100]) {
    iteration(20)
    operation (stencil_2d25pt_kernel)

    kernel stencil_2d25pt_kernel {
        tile(32, 64)
        domain([2, 4098][2, 4098])
        expr {
            0.1*input[y-2][x-2] + 0.2*input[y-2][x-1] + 0.3*input[y-2][x] + 
            0.4*input[y-2][x+1] + 0.5*input[y-2][x+2] +

            0.1*input[y-1][x-2] + 0.2*input[y-1][x-1] + 0.3*input[y-1][x] + 
            0.4*input[y-1][x+1] + 0.5*input[y-1][x+2] +

            0.1*input[y][x-2] + 0.2*input[y][x-1] + 0.3*input[y][x] + 
            0.4*input[y][x+1] + 0.5*input[y][x+2] +

            0.1*input[y+1][x-2] + 0.2*input[y+1][x-1] + 0.3*input[y+1][x] + 
            0.4*input[y+1][x+1] + 0.5*input[y+1][x+2] +

            0.1*input[y+2][x-2] + 0.2*input[y+2][x-1] + 0.3*input[y+2][x] + 
            0.4*input[y+2][x+1] + 0.5*input[y+2][x+2]
        }
    }    
}
