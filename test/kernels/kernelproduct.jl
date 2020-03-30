@testset "kernelproduct" begin
    rng = MersenneTwister(123456)
    v1 = rand(rng, 3)
    v2 = rand(rng, 3)

    k1 = LinearKernel()
    k2 = SqExponentialKernel()
    k3 = RationalQuadraticKernel()

    k = KernelProduct([k1,k2])
    @test length(k) == 2
    @test kappa(k,v1,v2) == kappa(k1*k2,v1,v2)
    @test kappa(k*k,v1,v2) ≈ kappa(k,v1,v2)^2
    @test kappa(k*k3,v1,v2) ≈ kappa(k3*k,v1,v2)
end