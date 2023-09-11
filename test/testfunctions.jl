using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)

@info "Testing Benchmark functions"
@testset verbose = true "Benchmark test" begin
    @testset "OneMax" begin
        x = ones(10)
        @test onemax(x) == 10
    end

    @testset "Leading Ones" begin
        x = [1, 1, 1, 0, 0, 1, 1, 0, 0]
        y = [1, 1, 1, 1, 1, 1, 1, 0, 0]
        z = [0, 1, 1, 1, 1, 1, 1, 0, 0]
        @test leadingones(x) == 3
        @test leadingones(y) == 7
        @test leadingones(z) == 0
    end

    @testset "Jump-K" begin
        x = [1, 1, 1, 1, 1, 1, 0, 0, 1, 1]
        y = ones(10)
        z = [1, 1, 0, 0, 1, 0, 0, 0, 1, 1]
        @test jumpk(x; k=3) == -8
        @test jumpk(y) == 10
        @test jumpk(z; k=4) == 5
    end

    @testset "Ackley" begin
        x = zeros(8)
        y = zeros(3)
        # known optimum
        @test ackley(x) ≈ 0 atol = 0.001
        @test ackley(y) ≈ 0 atol = 0.001
    end

    @testset "Booth" begin
        x = [1.0, 3.0]
        @test booth(x) == 0 # known optimum
    end

    @testset "Branin" begin
        x = [-π, 12.275]
        y = [π, 2.275]
        z = [9.42478, 2.475]
        # known optima
        @test branin(x) ≈ 0.397887 atol = 0.001
        @test branin(y) ≈ 0.397887 atol = 0.001
        @test branin(z) ≈ 0.397887 atol = 0.001
    end

    @testset "Michalewicz" begin
        x = [2.202906, 1.570796]
        y = [2.202906, 1.570796, 1.284992]
        z = [2.202906, 1.570796, 1.284992, 1.923058, 1.720470]
        # known optima
        @test michalewicz(x) ≈ -1.8013 atol = 0.001
        @test michalewicz(y) ≈ -2.7603 atol = 0.001
        @test michalewicz(z) ≈ -4.6876 atol = 0.001
    end

    @testset "Rosenbrock" begin
        x = ones(2)
        y = ones(5)
        # known optima
        @test rosenbrock(x) == 0
        @test rosenbrock(y) == 0
    end

    @testset "Wheeler" begin
        x = [1.0, 1.5]
        @test wheeler(x) == -1  # known optimum
    end
end;
