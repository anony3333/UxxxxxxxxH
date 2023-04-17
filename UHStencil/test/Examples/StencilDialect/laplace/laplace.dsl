stencil laplace(double input[72][18][16]) {
    iteration(1)
    operation(laplaceKernel)

    kernel laplaceKernel {
        tile(5, 4, 4)
        swCacheAt(2)
        domain([1,71][1,17][0,16])
        expr {
            4.0*input[x+1][y][z]
        }
    }
}