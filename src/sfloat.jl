
"""
Stochastic Float64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat64 <: Number
    value :: Float64
end

"""
Stochastic Float32

This type represents a single-precision (32-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
struct SFloat32 <: Number
    value :: Float32
end

import Base: +, -, *, /
macro define_stochastic_type(name)
    quote
        $name(x::$name) = $name(x.value)
        value(x::$name) = x.value

        +(a::$name, b::$name) = $name(+(RND, a.value,  b.value))
        *(a::$name, b::$name) = $name(*(RND, a.value,  b.value))
        -(a::$name, b::$name) = $name(+(RND, a.value, -b.value))
        /(a::$name, b::$name) = $name(/(RND, a.value,  b.value))

        Base.zero(::$name) = $name(0.)
        Base.zero(::Type{$name}) = $name(0.)
        Base.one(::Type{$name}) = $name(1.)
        Base.conj(x::$name) = x

        Base.promote_rule(::Type{$name}, ::Type{<:Number}) = $name

        Base.abs(x::$name) = $name(abs(x.value))
        Base.isless(x::$name, y::Number) = isless(value(x), y)
        Base.isless(x::Number, y::$name) = isless(x, value(y))
        Base.isless(x::$name, y::$name) = isless(value(x), value(y))

    end |> esc
end

@define_stochastic_type SFloat64
@define_stochastic_type SFloat32

using Statistics, Formatting

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
