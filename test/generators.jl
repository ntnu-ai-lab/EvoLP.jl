using EvoLP
using Test
using StableRNGs
using Statistics

myrng = StableRNG(123)

@info "Testing generators"
@testset verbose = true "Generator test" begin
    @testset "Binary vectors generator" begin
        pop = binary_vector_pop(50, 10, rng=myrng)
        @test length(pop) == 50  # Size of the population matches
        @test length(pop[1]) == 10  # Size of an individual matches
        @test typeof(pop[1]) == BitVector  # Type of an individual matches
    end

    @testset "Permutation vectors generator" begin
        pop = permutation_vector_pop(30, 8, 1:8; replacement=false, rng=myrng)
        @test length(pop) == 30  # Size of the population matches
        @test length(pop[1]) == 8  # Length of an individual matches
        @test typeof(pop[1]) <: Vector{Int64}  # Type of an individual matches
        @test allunique(pop[1])  # Uniqueness holds when replacement=false
    end

    @testset "Normal random vectors generator" begin
        pop = normal_rand_vector_pop(3000, [0, 0], [1 0; 0 1], rng=myrng)
        @test length(pop) == 3000  # Size of the population matches
        @test length(pop[1]) == 2  # size of an individual matches
        @test typeof(pop[1]) <: Vector{Float64}  # Type of an individual matches
        @test mean(pop) ≈ [0, 0] atol = 0.1  # Distribution E[x] holds
    end

    @testset "Uniformly random vectors generator" begin
        pop = unif_rand_vector_pop(3000, [0, 0], [1, 1], rng=myrng)
        @test length(pop) == 3000  # Size of the population matches
        @test length(pop[1]) == 2 # Size of an individual matches
        @test typeof(pop[1]) <: Vector{Float64} # Type of an individual matches
        @test sum(sum.(pop)) / 3000 ≈ 1 rtol = 0.1  # Distribution E[x] holds
    end

    @testset "Normal random particles generator" begin
        pop = normal_rand_particle_pop(3000, [0, 0], [1 0; 0 1], rng=myrng)
        @test length(pop) == 3000  # Size of the population matches
        @test length(pop[1].x) == 2 # Dimensions of position matches
        @test typeof(pop[1]) == Particle  # Type of individual matches
        @test mean([P.x for P in pop]) ≈ [0, 0] atol = 0.1  # Distribution E[x] holds
    end

    @testset "Uniformly random particles generator" begin
        pop = unif_rand_particle_pop(3000, [0, 0], [1, 1], rng=myrng)
        @test length(pop) == 3000  # Size of the population matches
        @test length(pop[1].x) == 2 # Dimensions of position matches
        @test typeof(pop[1]) == Particle  # Type of individual matches
        @test sum([sum(P.x) for P in pop]) / 3000 ≈ 1 rtol = 0.1  # Distribution E[x] holds
    end
end;
