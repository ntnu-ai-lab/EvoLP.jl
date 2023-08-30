using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)

@info "Testing Benchmark functions"
@testset verbose = true "Benchmark test" begin
    @testset "Onemax" begin
        a = collect(1.0:3.0)
        @test onemax(a) == 6.0
    end

    @testset "Leading ones" begin
        a = collect(1:3)
        @test leadingones(a) == 9
    end

    @testset "Jump k" begin
        a = collect(1:10)
        b = fill(1, 20)
        @test jumpk(a) == -55
        @test jumpk(b; k=1) == 20
    end

    @testset "Ackley" begin
        a = collect(1.0:5.0)
        @test ackley(a) != 9.69728
    end

    @testset "Booth" begin
        a = [1.0, 2.0]
        @test booth(a) == 5.0
    end

    @testset "Branin" begin
        a = [1.0, 2.0]
        @test branin(a) != 5.0
    end

    @testset "Circle" begin
        a = [1.0, 2.0]
        @test circle(a) != [1.0, 0.0]
    end

    @testset "Flower" begin
        a = collect(1.0:10.0)
        @test flower(a) != 9.0
    end

    @testset "Michel Wicz" begin
        a = collect(1.0:10.0)
        @test michalewicz(a) != 9.0
    end

    @testset "Rosenbrock" begin
        a = [1.0, 2.0]
        @test rosenbrock(a) == 5.0
    end

    @testset "Wheeler" begin
        a = [1.0, 2.0]
        @test wheeler(a) != 0.0
    end
end;
