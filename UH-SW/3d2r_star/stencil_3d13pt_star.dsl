stencil stencil_3d13pt(double input[260][260][260]) {
    iteration(20)
    operation (stencil_3d13pt_kernel)

    kernel stencil_3d13pt_kernel {
        tile(8, 8, 8)
        domain([2, 258][2, 258][2,258])
        expr {
            0.1*input[z-2][y][x] + 0.2*input[z+2][y][x] +
            0.3*input[z][y-2][x] + 0.4*input[z][y+2][x] +
            0.5*input[z][y][x-2] + 0.6*input[z][y][x+2] +

            0.1*input[z-1][y][x] + 0.2*input[z+1][y][x] +
            0.3*input[z][y-1][x] + 0.4*input[z][y+1][x] +
            0.5*input[z][y][x-1] + 0.6*input[z][y][x+1] +
            0.7*input[z][y][x]
        }
    }    
}
