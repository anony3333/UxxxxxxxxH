stencil stencil_2d5pt(double input[8194][8194]) {
    iteration(20)
    operation (stencil_2d5pt_kernel)
    mpiTile(16, 8)
    mpiHalo([2,0][0,2])

    kernel stencil_2d5pt_kernel {
        tile(32, 64)
        swCacheAt(1)
        domain([1, 8193][1, 8193])
        expr {
            0.1*input[y-1][x] + 0.2*input[y+1][x] + 
            0.3*input[y][x] + 0.4*input[y][x+1] + 0.5*input[y][x-1]
        }
    }    
}
