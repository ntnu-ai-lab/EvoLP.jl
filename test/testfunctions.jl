using EvoLP
using Test

@info "Testing Benchmark functions"
@testset verbose = true "Test functions" begin
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

    @testset "Egg Holder" begin
        x = [512, 404.231805]
        y = [481.462894, 436.929541, 451.769713]
        z = [485.589834, 436.123707, 451.083199, 466.431218, 421.958519]
        # known optima
        @test eggholder(x) ≈ -959.64066270 atol = 0.001
        @test eggholder(y) ≈ -1888.3213909 atol = 0.001
        @test eggholder(z) ≈ -3719.7248363 atol = 0.001
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

    @testset "Rana" begin
        x = [-488.632577, 512]
        y = [-512, -512, -511.995602]
        z = [-512, -512, -512, -512, -511.995602]
        # known optima
        @test rana(x) ≈ -511.7328819 atol = 0.001
        @test rana(y) ≈ -1023.4166105 atol = 0.001
        @test rana(z) ≈ -2046.8320657 atol = 0.001
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
