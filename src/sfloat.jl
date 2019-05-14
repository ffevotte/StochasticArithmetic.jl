struct SFloat{T} <: AbstractFloat
    value :: T
end
value(x::SFloat) = x.value
SFloat{T}(x::SFloat) where T = SFloat{T}(T(x.value))

"""
Stochastic Float64

This type represents a double-precision (64-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
const SFloat64 = SFloat{Float64}

"""
Stochastic Float32

This type represents a single-precision (32-bit) floating-point number, on which
every operation gets randomly rounded upwards or downwards.
"""
const SFloat32 = SFloat{Float32}

det_type(::Type{T}) where {T<:Real} = T
det_type(::Type{SFloat{T}}) where {T} = T

sto_type(::Type{T}) where {T} = SFloat{T}

Base.promote_rule(::Type{T1}, ::Type{T2}) where {T1<:SFloat, T2} = sto_type(promote_type(det_type(T1), det_type(T2)))
result_type(x::T1, y::T2) where {T1, T2} = promote_type(T1, T2)

#binary operators
for op = (:+, :-, :*, :/)
    eval(quote
        Base.$op(a::SFloat,b::SFloat) = result_type(a,b)($op(RND, a.value,  b.value))
    end)
end

for op = (:<, :<=)
    eval(quote
        Base.$op(a::SFloat,b::SFloat) = $op(a.value,  b.value)
    end)
end

#unary operators
for op = (:-, :zero, :one, :abs)
    eval(quote
        Base.$op(a::SFloat) = SFloat($op(a.value))
    end)
end

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
