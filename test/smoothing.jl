using FemMesh
using Test

printstyled("\nMesh smoothing\n", color=:cyan)

println("QUAD4:")
bl   = Block2D( [0 0; 1 1], nx=2, ny=2, cellshape=QUAD4)
mesh = Mesh(bl)
smooth!(mesh, maxit=5, extended=false)
@test mesh.quality ≈ 1.0 atol=1e-2

println("TRI3:")
bl   = Block2D( [0 0; 1 1], nx=2, ny=2, cellshape=TRI3)
mesh = Mesh(bl)
smooth!(mesh, maxit=5, extended=false)
@test mesh.quality ≈ 0.95 atol=1e-2

println("HEX8:")
bl = Block3D( [ 0 0 0; 2 0 0; 2 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1 ], nx=3, ny=3, nz=3, cellshape=HEX8)
mesh = Mesh(bl)
smooth!(mesh, maxit=5, extended=false)
@test mesh.quality ≈ 0.95 atol=1e-2
laplacian_smooth!(mesh)
@test mesh.quality ≈ 0.95 atol=1e-2

println("QUAD8:")
bl = Block2D( [ 1.0 0.0; 2.0 0.0; 0.0 2.0; 0.0 1.0; 1.5 0.0; 1.5 1.5; 0.0 1.5; 0.7 0.7 ], nx=3, ny=6, cellshape=QUAD8)
mesh = Mesh(bl)
smooth!(mesh, maxit=5, extended=false)
@test mesh.quality ≈ 0.99 atol=1e-2

println("TRI6:")
bl = Block2D( [ 1.0 0.0; 2.0 0.0; 0.0 2.0; 0.0 1.0; 1.5 0.0; 1.5 1.5; 0.0 1.5; 0.7 0.7 ], nx=3, ny=6, cellshape=TRI6)
mesh = Mesh(bl)
smooth!(mesh, tol=1e-3, mintol=1e-2, maxit=5, extended=false)
@test mesh.quality ≈ 0.89 atol=1e-2

