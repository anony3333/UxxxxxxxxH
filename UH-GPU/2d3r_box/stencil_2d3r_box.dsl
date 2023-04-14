stencil stencil_2d3r(double input[8198][8198]) {
    iteration(4)
    operation (stencil_2d3r_kernel)

    kernel stencil_2d3r_kernel {
        tile(32, 64)
        domain([3, 8195][3, 8195])
        expr {
            0.1*input[y-3][x-2] + 0.1*input[y-3][x-1] + 0.1*input[y-3][x] + 
            0.1*input[y-3][x+1] + 0.1*input[y-3][x+2] +

            0.1*input[y-2][x-2] + 0.1*input[y-2][x-1] + 0.1*input[y-2][x] + 
            0.1*input[y-2][x+1] + 0.1*input[y-2][x+2] +

            0.1*input[y-1][x-2] + 0.1*input[y-1][x-1] + 0.1*input[y-1][x] + 
            0.1*input[y-1][x+1] + 0.1*input[y-1][x+2] +

            0.1*input[y][x-2] + 0.1*input[y][x-1] + 0.1*input[y][x] + 
            0.1*input[y][x+1] + 0.1*input[y][x+2] +

            0.1*input[y+1][x-2] + 0.1*input[y+1][x-1] + 0.1*input[y+1][x] + 
            0.1*input[y+1][x+1] + 0.1*input[y+1][x+2] +

            0.1*input[y+2][x-2] + 0.1*input[y+2][x-1] + 0.1*input[y+2][x] + 
            0.1*input[y+2][x+1] + 0.1*input[y+2][x+2] +

            0.1*input[y+3][x-2] + 0.1*input[y+3][x-1] + 0.1*input[y+3][x] + 
            0.1*input[y+3][x+1] + 0.1*input[y+3][x+2] +


            0.1*input[y+3][x-3] + 0.1*input[y+2][x-3] + 0.1*input[y+1][x-3] + 
            0.1*input[y][x-3] + 0.1*input[y-1][x-3] + 0.1*input[y-2][x-3] + 0.1*input[y-3][x-3] +

            0.1*input[y+3][x+3] + 0.1*input[y+2][x+3] + 0.1*input[y+1][x+3] + 
            0.1*input[y][x+3] + 0.1*input[y-1][x+3] + 0.1*input[y-2][x+3] + 0.1*input[y-3][x+3] 

        }
    }    
}
