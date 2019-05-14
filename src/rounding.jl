struct Up   end
struct Down end
struct Rand end

const UP  = Up()
const DWN = Down()
const RND = Rand()

macro defRound(op, eft)
    quote
        function $(esc(op))(::Up, a, b)
            (res, err) = $(esc(eft))(a, b)
            if err > 0
                $(esc(nextfloat))(res)
            else
                res
            end
        end

        function $(esc(op))(::Down, a, b)
            (res, err) = $(esc(eft))(a, b)
            if err < 0
                $(esc(prevfloat))(res)
            else
                res
            end
        end

        function $(esc(op))(::Rand, a, b)
            (res, err) = $(esc(eft))(a, b)
            if err < 0
                rand(Bool) ? $(esc(prevfloat))(res) : res
            elseif err > 0
                rand(Bool) ? $(esc(nextfloat))(res) : res
            else
                res
            end
        end
    end
end

import Base: +, -, *, /
@defRound(+, EFT.twoSum)
@defRound(-, EFT.twoDiff)
@defRound(*, EFT.twoProd)
@defRound(/, EFT.twoDiv)
