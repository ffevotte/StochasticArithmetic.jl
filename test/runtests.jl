using StochasticArithmetic
using StochasticArithmetic.EFT
using Test
using Formatting

@testset "StochasticArithmetic" begin
    @testset "EFT" begin

        @testset "twoSum" begin
            let (x,y) = twoSum(0.1, 0.3)
                @test x ≈  0.4
                @test y ≈ -2.7755575615628914e-17
            end

            let (x,y) = twoSum(0.1f0, 0.2f0)
                @test x ≈  0.3f0
                @test y ≈ -7.450581f-9
            end
        end

        @testset "twoProd" begin
            let (x, y) = twoProd(0.1, 5.)
                @test x ≈ 0.5
                @test y ≈ 2.7755575615628914e-17
            end

            let (x, y) = twoProd(0.1f0, 5.f0)
                @test x ≈ 0.5f0
                @test y ≈ 7.450581f-9
            end
        end

        @testset "twoDiv" begin
            let (x, y) = twoDiv(1., 3.)
                @test x ≈ 0.3333333333333333
                @test y ≈ 1.850371707708594e-17
            end

            let (x, y) = twoDiv(1.f0, 3.f0)
                @test x ≈  0.333333f0
                @test y ≈ -9.934108f-9
            end
        end

        @testset "split" begin
            # Simple test for the error-free split of a Float64
            function checkSplit(a)
                binRepr(x) = format("{:b}", Int(significand(x)*2^(53)))
                (x, y) = split(a)

                xTrim = replace(binRepr(x), r"0+$" => "")
                @test startswith(binRepr(a), xTrim)

                n = length(xTrim)
                aEnd = (binRepr(a))[n+1:end]
                aEnd = replace(aEnd, r"^0+" => "")
                aEnd = replace(aEnd, r"0+$" => "")
                yTrim = replace(binRepr(y), r"0+$" => "")
                @test aEnd == yTrim
            end

            checkSplit(0.1)
        end
    end

    @testset "rounding modes" begin
        @testset "directed" begin
            for (x,y) in [(0.1, 0.3), (-0.31, 0.0125)]
                @test +(DWN, x, y) < +(UP, x, y)
                @test *(DWN, x, y) < *(UP, x, y)
                @test /(DWN, x, y) < /(UP, x, y)
            end
        end

        @testset "random" begin
            for (x,y) in [(0.1, 0.3), (-0.31, 0.0125)]
                @test all(+(RND, x, y) in (+(UP, x, y), +(DWN, x, y)) for _ in 1:100)
                @test all(*(RND, x, y) in (*(UP, x, y), *(DWN, x, y)) for _ in 1:100)
                @test all(/(RND, x, y) in (/(UP, x, y), /(DWN, x, y)) for _ in 1:100)
            end
        end
    end
end

@itest begin
end
