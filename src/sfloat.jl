
"""
Stochastic Float64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat64 <: Number
    value :: Float64
end

SFloat64(x::SFloat64) = SFloat64(x.value)
value(x::SFloat64) = x.value

import Base: +, -, *, /
+(a::SFloat64, b::SFloat64) = SFloat64(+(RND, a.value,  b.value))
*(a::SFloat64, b::SFloat64) = SFloat64(*(RND, a.value,  b.value))
-(a::SFloat64, b::SFloat64) = SFloat64(+(RND, a.value, -b.value))
/(a::SFloat64, b::SFloat64) = SFloat64(/(RND, a.value,  b.value))

Base.zero(::SFloat64) = SFloat64(0.)
Base.zero(::Type{SFloat64}) = SFloat64(0.)
Base.one(::Type{SFloat64}) = SFloat64(1.)
Base.conj(x::SFloat64) = x

Base.promote_rule(::Type{SFloat64}, ::Type{<:Number}) = SFloat64


using Statistics, Formatting

deref(x) = x
deref(x::Array{T,0}) where T = x[]
macro reliable_digits(expr)
    return quote
        x = [value.($(esc(expr))) for i = 1:10]
        mu = mean(x)
        sigma = std(x)
        s = -log10.((/).(sigma, abs.(mu)))
        zip(mu, s) |> collect |> deref
    end
end
