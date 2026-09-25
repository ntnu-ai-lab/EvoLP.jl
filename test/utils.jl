using EvoLP
using Test

@info "Testing bin utils"
@testset verbose = true "Bin Utils" begin
    @testset "ind2dec" begin
        n = 8
        x1 = [0, 1, 1, 1, 1, 1, 1, 1]  # 127
        x2 = ones(Int, n)
        x3 = BitArray([0, 1, 1, 1, 1, 1, 1, 1])  # 127

        @test ind2dec(force_boolean(x1)) == 127  # ints + force_boolean
        @test ind2dec(force_boolean(x2)) == 255  # works with Int ones + force_boolean
        @test ind2dec(x3) == 127  # works with bit arrays
    end

    @testset "ind2str" begin
        x1 = [0, 0, 0, 0, 0, 0, 0, 1]
        x2 = zeros(Int, 8)
        x3 = ones(Int, 8)
        s1 = "00000001"
        s2 = "00000000"
        s3 = "11111111"

        @test ind2str(force_boolean(x1)) == s1
        @test ind2str(force_boolean(x2)) == s2
        @test ind2str(force_boolean(x3)) == s3
    end

    @testset "dec2ind" begin
        @test dec2ind(7; pad = 4) == BitArray([0, 1, 1, 1])
        @test dec2ind(7; pad = 8) == BitArray([0, 0, 0, 0, 0, 1, 1, 1])
        @test dec2ind(256; pad = 9) == BitArray([1, 0, 0, 0, 0, 0, 0, 0, 0])
        @test dec2ind(31; pad = 5) == BitArray([1, 1, 1, 1, 1])
    end

    @testset "get_neighbourhood (ind)" begin
        x = zeros(Bool, 4)
        n1 = BitArray([1, 0, 0, 0])
        n2 = BitArray([0, 1, 0, 0])
        n3 = BitArray([0, 0, 1, 0])
        n4 = BitArray([0, 0, 0, 1])

        @test get_neighbourhood(x) == [n1, n2, n3, n4]
    end

    @testset "get_neighbourhood (int)" begin
        x = 0
        n1 = 8
        n2 = 4
        n3 = 2
        n4 = 1

        @test get_neighbourhood(x; pad = 4) == [n1, n2, n3, n4]
    end

    @testset "get_neighbourhood_ixs" begin
        x = zeros(Bool, 4)

        @test get_neighbourhood_ixs(x) == [8, 4, 2, 1]
    end

    @testset "global_entropy" begin
        @testset "Full convergence" begin
            # 5 individuals, fully converged
            pop_zeros = [falses(10) for _ in 1:5]
            pop_ones = [trues(10) for _ in 1:5]

            @test global_entropy(pop_zeros) == 0.0
            @test global_entropy(pop_ones) == 0.0
        end

        @testset "Max Entropy" begin
            pop_half = [trues(10), falses(10)]

            @test global_entropy(pop_half) == 1.0
        end

    end
end;
