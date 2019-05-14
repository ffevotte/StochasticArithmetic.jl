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
SFloat64(x::SFloat32) = SFloat64(x.value)

value(x::SFloat) = x.value

det_type(::Type{T}) where {T<:Real} = T
det_type(::Type{SFloat64}) = Float64
det_type(::Type{SFloat32}) = Float32

sto_type(::Type{Float64}) = SFloat64
sto_type(::Type{Float32}) = SFloat32

Base.promote_rule(::Type{T1}, ::Type{T2}) where {T1<:SFloat, T2} = sto_type(promote_type(det_type(T1), det_type(T2)))
result_type(x::T1, y::T2) where {T1, T2} = promote_type(T1, T2)

import Base: +, -, *, /, <, <=
+(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value,  b.value))
*(a::SFloat, b::SFloat) = result_type(a, b)(*(RND, a.value,  b.value))
-(a::SFloat, b::SFloat) = result_type(a, b)(+(RND, a.value, -b.value))
/(a::SFloat, b::SFloat) = result_type(a, b)(/(RND, a.value,  b.value))
<(a::SFloat, b::SFloat) = value(a) < value(b)
<=(a::SFloat, b::SFloat) = value(a) <= value(b)

-(a::T)              where T<:SFloat = T(-a.value)
Base.zero(::Type{T}) where T<:SFloat = T(0)
Base.one(::Type{T})  where T<:SFloat = T(1)
Base.abs(x::T)       where T<:SFloat = T(abs(value(x)))



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
