stencil stencil_2d49pt(double input[4102][4102]) {
    iteration(20)
    operation (stencil_2d49pt_kernel)

    kernel stencil_2d49pt_kernel {
        tile(32, 64)
        domain([3, 4099][3, 4099])
        expr {
            0.1*input[y-3][x-3] + 0.2*input[y-3][x-2] + 0.3*input[y-3][x-1] +
            0.4*input[y-3][x] + 0.5*input[y-3][x+1] + 0.6*input[y-3][x+2] +
            0.7*input[y-3][x+3] +

            0.1*input[y-2][x-3] + 0.2*input[y-2][x-2] + 0.3*input[y-2][x-1] +
            0.4*input[y-2][x] + 0.5*input[y-2][x+1] + 0.6*input[y-2][x+2] +
            0.7*input[y-2][x+3] +

            0.1*input[y-1][x-3] + 0.2*input[y-1][x-2] + 0.3*input[y-1][x-1] +
            0.4*input[y-1][x] + 0.5*input[y-1][x+1] + 0.6*input[y-1][x+2] +
            0.7*input[y-1][x+3] +

            0.1*input[y][x-3] + 0.2*input[y][x-2] + 0.3*input[y][x-1] +
            0.4*input[y][x] + 0.5*input[y][x+1] + 0.6*input[y][x+2] +
            0.7*input[y][x+3] +

            0.1*input[y+1][x-3] + 0.2*input[y+1][x-2] + 0.3*input[y+1][x-1] +
            0.4*input[y+1][x] + 0.5*input[y+1][x+1] + 0.6*input[y+1][x+2] +
            0.7*input[y+1][x+3] +

            0.1*input[y+2][x-3] + 0.2*input[y+2][x-2] + 0.3*input[y+2][x-1] +
            0.4*input[y+2][x] + 0.5*input[y+2][x+1] + 0.6*input[y+2][x+2] +
            0.7*input[y+2][x+3] +

            0.1*input[y+3][x-3] + 0.2*input[y+3][x-2] + 0.3*input[y+3][x-1] +
            0.4*input[y+3][x] + 0.5*input[y+3][x+1] + 0.6*input[y+3][x+2] +
            0.7*input[y+3][x+3]
        }
    }    
}
