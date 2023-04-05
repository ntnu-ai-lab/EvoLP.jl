using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)

@info "Testing Recombinators"
@testset verbose = true "Crossover test" begin
    @testset "Single point crossover" begin
        S = SinglePointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(S, a, b, rng=myrng) # 1. rand(myrng, 1:n) == 4
        @test c == [0, 0, 0, 0, 0, 0, 0, 0]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Two point crossover" begin
        T = TwoPointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(T, a, b, rng=myrng)  # 2. rand(myrng, 1:n, 2) == [7, 8]
        @test c == [0, 0, 0, 0, 1, 1, 1, 0]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Uniform crossover" begin
        U = UniformCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(U, a, b, rng=myrng) # 3. rand(myrng, 8) results in bbbaaaba
        @test c == [1, 1, 1, 0, 1, 1, 0, 1]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Interpolation crossover" begin
        L = InterpolationCrossover(0.3)
        a = [2, 3, 4]
        b = [1, 2, 3]
        c = cross(L, a, b)
        @test c == 0.7 * a + 0.3 * b  # Check that interpolation is correct
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "OX1 crossover" begin
        O = OrderOneCrossover()
        a = [1, 2, 3, 4, 5, 6, 7, 8]
        b = [8, 7, 6, 5, 4, 3, 2, 1]
        c = cross(O, a, b; rng=myrng)
        # 4. sample(myrng, 2:7, 2 replace=false, ordered=true) == [2, 7]
        @test c == [8, 2, 3, 4, 5, 6, 7, 1]
        @test length(c) == length(a) # Check length of offspring
    end
end;
