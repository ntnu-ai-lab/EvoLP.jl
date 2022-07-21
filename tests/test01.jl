using Test
using Statistics
using StableRNGs

include("../src/generators.jl")
include("../src/crossover.jl")
myrng = StableRNG(123)

@info "Testing generators"
@testset verbose = true "Generator test" begin
    @testset "Binary pop generator" begin
        pop = rand_pop_binary(10, 50)
        @test length(pop) == 50
        @test length(pop[1]) == 10
        @test typeof(pop[1]) == BitVector
    end
    @testset "Uniform pop generator" begin
        pop = rand_pop_uniform(300, [0, 0], [1, 1])
        @test length(pop) == 300
        @test length(pop[1]) == 2
        @test typeof(pop[1]) == Vector{Float64}
        @test sum(sum.(pop)) / 300 ≈ 1 rtol=0.1
    end
    @testset "Normal pop generator" begin
        pop = rand_pop_normal(3000, [0, 0], [1 0; 0 1])
        @test length(pop) == 3000
        @test length(pop[1]) == 2
        @test typeof(pop[1]) == Vector{Float64}
        @test mean(pop) ≈ [0, 0] atol=0.1
    end
end

@info "Testing Crossover operators"
@testset verbose = true "Crossover test" begin
    @testset "Single point crossover" begin
        S = SinglePointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(S, a, b)
        @test c == [0, 0, 0, 0, 1, 1, 1, 0]
        @test length(c) == length(a)
    end
    @testset "Two point crossover" begin
        T = TwoPointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(T, a, b)
        @test c == [0, 1, 1, 1, 0, 0, 0, 1]
        @test length(c) == length(a)
    end
    @testset "Uniform crossover" begin
        U = UniformCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(U, a, b)
        @test c == [0, 1, 1, 1, 0, 0, 0, 0]
        @test length(c) == length(a)
    end
    @testset "Interpolation crossover" begin
        L = InterpolationCrossover(0.3)
        a = [2, 3, 4]
        b = [1, 2, 3]
        c = cross(L, a, b)
        @test c == 0.7 * a + 0.3 * b
        @test length(c) == length(a)
    end
end