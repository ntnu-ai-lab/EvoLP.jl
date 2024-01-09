using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)

@info "Testing mutators"
@testset verbose = true "Mutator test" begin
    @testset "Bitwise" begin
        M = BitwiseMutator(1/8)
        x = binary_vector_pop(1, 8, rng=myrng)[1]  # 1. randpop
        c = mutate(M, x; rng=myrng) # 2. rand(myrng, 8) results in flipping 3rd bit
        @test c == Bool[1, 1, 1, 1, 0, 1, 0, 0]
    end

    @testset "Gaussian" begin
        G = GaussianMutator(0.5)
        x = [0, 0, 0, 0, 0, 0, 0, 0]
        c = mutate(G, x; rng=myrng) # 3. randn(myrng, 8) results in the following vector
        v = [
            -0.9671975288083468,
            -1.3641880343579902,
            -0.9995722599695167,
            -1.4919831226368483,
            -1.3103156411991586,
            0.9562355731126654,
            2.0446617634637434,
            1.6344585127632065,
        ]
        @test c ≈ x + v * 0.5 atol=5e-8
    end

    @testset "Swap" begin
        S = SwapMutator()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(S, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false) == 3, 7
        @test c == [1, 2, 7, 4, 5, 6, 3, 8]
    end

    @testset "Insert" begin
        I = InsertionMutator()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(I, x; rng=myrng) # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [4, 6]
        @test c == [1, 2, 3, 4, 6, 5, 7, 8]
    end

    @testset "Scramble" begin
        S = ScrambleMutator()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(S, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [3, 7]
        # shuffle!(myrng, selectedpart) == [6, 5, 4, 7, 3]
        @test c == [1, 2, 6, 5, 4, 7, 3, 8]
    end

    @testset "Inversion" begin
        I = InversionMutator()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(I, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [5, 6]
        @test c == [1, 2, 3, 4, 6, 5, 7, 8]
    end
end;
