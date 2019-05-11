abstract type SFloat <: Real end

"""
Stochastic Float64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat64 <: SFloat
    value :: Float64
end
SFloat64(x::SFloat64) = SFloat64(x.value)

"""
Stochastic Float32

This type represents a single-precision (32-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat32 <: SFloat
    value :: Float32
end
SFloat32(x::SFloat32) = SFloat32(x.value)


value(x::SFloat) = x.value

Base.promote_rule(::Type{SFloat64}, ::Type{SFloat32}) = SFloat64
Base.promote_rule(::Type{SFloat32}, ::Type{SFloat64}) = SFloat64
Base.promote_rule(::Type{T},        ::Type{<:Number}) where T<:SFloat = T
Base.promote_rule(::Type{<:Number}, ::Type{T})        where T<:SFloat = T
Base.promote_rule(::Type{T},        ::Type{T})        where T<:SFloat = T
result_type(x::T1, y::T2) where {T1, T2} = promote_rule(T1, T2)

import Base: +, -, *, /, <
+(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value,  b.value))
*(a::SFloat, b::SFloat) = result_type(a, b)(*(RND, a.value,  b.value))
-(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value, -b.value))
/(a::SFloat, b::SFloat) = result_type(a, b)(/(RND, a.value,  b.value))
<(a::SFloat, b::SFloat) = value(a) < value(b)

-(a::T)              where T<:SFloat = T(-a.value)
Base.zero(::T)       where T<:SFloat = T(0.)
Base.zero(::Type{T}) where T<:SFloat = T(0.)
Base.one(::Type{T})  where T<:SFloat = T(1.)
Base.abs(x::T)       where T<:SFloat = T(abs(value(x)))


using Statistics

value(x::Number) = x
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
