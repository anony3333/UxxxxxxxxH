stencil stencil_3d125pt(double input[260][260][260]) {
    iteration(20)
    operation (stencil_3d125pt_kernel)

    kernel stencil_3d125pt_kernel {
        tile(8, 8, 8)
        domain([2, 258][2, 258][2,258])
        expr {
            0.01*input[z-2][y-2][x-1] + 0.02*input[z-2][y-2][x] + 0.03*input[z-2][y-2][x+1] + 
            0.04*input[z-2][y-2][x-2] + 0.05*input[z-2][y-2][x+2] +
            0.01*input[z-2][y-1][x-1] + 0.02*input[z-2][y-1][x] + 0.03*input[z-2][y-1][x+1] + 
            0.04*input[z-2][y-1][x-2] + 0.05*input[z-2][y-1][x+2] +
            0.01*input[z-2][y][x-1] + 0.02*input[z-2][y][x] + 0.03*input[z-2][y][x+1] +
            0.04*input[z-2][y][x-2] + 0.05*input[z-2][y][x+2] +
            0.01*input[z-2][y+1][x-1] + 0.02*input[z-2][y+1][x] + 0.03*input[z-2][y+1][x+1] +
            0.04*input[z-2][y+1][x-2] + 0.05*input[z-2][y+1][x+2] +
            0.01*input[z-2][y+2][x-1] + 0.02*input[z-2][y+2][x] + 0.03*input[z-2][y+2][x+1] +
            0.04*input[z-2][y+2][x-2] + 0.05*input[z-2][y+2][x+2] +
            
            0.01*input[z-1][y-2][x-1] + 0.02*input[z-1][y-2][x] + 0.03*input[z-1][y-2][x+1] + 
            0.04*input[z-1][y-2][x-2] + 0.05*input[z-1][y-2][x+2] +
            0.01*input[z-1][y-1][x-1] + 0.02*input[z-1][y-1][x] + 0.03*input[z-1][y-1][x+1] + 
            0.04*input[z-1][y-1][x-2] + 0.05*input[z-1][y-1][x+2] +
            0.01*input[z-1][y][x-1] + 0.02*input[z-1][y][x] + 0.03*input[z-1][y][x+1] +
            0.04*input[z-1][y][x-2] + 0.05*input[z-1][y][x+2] +
            0.01*input[z-1][y+1][x-1] + 0.02*input[z-1][y+1][x] + 0.03*input[z-1][y+1][x+1] +
            0.04*input[z-1][y+1][x-2] + 0.05*input[z-1][y+1][x+2] +
            0.01*input[z-1][y+2][x-1] + 0.02*input[z-1][y+2][x] + 0.03*input[z-1][y+2][x+1] +
            0.04*input[z-1][y+2][x-2] + 0.05*input[z-1][y+2][x+2] +

            0.01*input[z][y-2][x-1] + 0.02*input[z][y-2][x] + 0.03*input[z][y-2][x+1] + 
            0.04*input[z][y-2][x-2] + 0.05*input[z][y-2][x+2] +
            0.01*input[z][y-1][x-1] + 0.02*input[z][y-1][x] + 0.03*input[z][y-1][x+1] + 
            0.04*input[z][y-1][x-2] + 0.05*input[z][y-1][x+2] +
            0.01*input[z][y][x-1] + 0.02*input[z][y][x] + 0.03*input[z][y][x+1] +
            0.04*input[z][y][x-2] + 0.05*input[z][y][x+2] +
            0.01*input[z][y+1][x-1] + 0.02*input[z][y+1][x] + 0.03*input[z][y+1][x+1] +
            0.04*input[z][y+1][x-2] + 0.05*input[z][y+1][x+2] +
            0.01*input[z][y+2][x-1] + 0.02*input[z][y+2][x] + 0.03*input[z][y+2][x+1] +
            0.04*input[z][y+2][x-2] + 0.05*input[z][y+2][x+2] +

            0.01*input[z+1][y-2][x-1] + 0.02*input[z+1][y-2][x] + 0.03*input[z+1][y-2][x+1] + 
            0.04*input[z+1][y-2][x-2] + 0.05*input[z+1][y-2][x+2] +
            0.01*input[z+1][y-1][x-1] + 0.02*input[z+1][y-1][x] + 0.03*input[z+1][y-1][x+1] + 
            0.04*input[z+1][y-1][x-2] + 0.05*input[z+1][y-1][x+2] +
            0.01*input[z+1][y][x-1] + 0.02*input[z+1][y][x] + 0.03*input[z+1][y][x+1] +
            0.04*input[z+1][y][x-2] + 0.05*input[z+1][y][x+2] +
            0.01*input[z+1][y+1][x-1] + 0.02*input[z+1][y+1][x] + 0.03*input[z+1][y+1][x+1] +
            0.04*input[z+1][y+1][x-2] + 0.05*input[z+1][y+1][x+2] +
            0.01*input[z+1][y+2][x-1] + 0.02*input[z+1][y+2][x] + 0.03*input[z+1][y+2][x+1] +
            0.04*input[z+1][y+2][x-2] + 0.05*input[z+1][y+2][x+2] +

            0.01*input[z+2][y-2][x-1] + 0.02*input[z+2][y-2][x] + 0.03*input[z+2][y-2][x+1] + 
            0.04*input[z+2][y-2][x-2] + 0.05*input[z+2][y-2][x+2] +
            0.01*input[z+2][y-1][x-1] + 0.02*input[z+2][y-1][x] + 0.03*input[z+2][y-1][x+1] + 
            0.04*input[z+2][y-1][x-2] + 0.05*input[z+2][y-1][x+2] +
            0.01*input[z+2][y][x-1] + 0.02*input[z+2][y][x] + 0.03*input[z+2][y][x+1] +
            0.04*input[z+2][y][x-2] + 0.05*input[z+2][y][x+2] +
            0.01*input[z+2][y+1][x-1] + 0.02*input[z+2][y+1][x] + 0.03*input[z+2][y+1][x+1] +
            0.04*input[z+2][y+1][x-2] + 0.05*input[z+2][y+1][x+2] +
            0.01*input[z+2][y+2][x-1] + 0.02*input[z+2][y+2][x] + 0.03*input[z+2][y+2][x+1] +
            0.04*input[z+2][y+2][x-2] + 0.05*input[z+2][y+2][x+2]
        }
    }    
}
