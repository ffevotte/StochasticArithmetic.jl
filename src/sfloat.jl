struct SFloat64
    value :: Float64
end

import Base: +, -, *, /
+(a::SFloat64, b::SFloat64) = SFloat64(+(RND, a.value, b.value))
*(a::SFloat64, b::SFloat64) = SFloat64(*(RND, a.value, b.value))
-(a::SFloat64, b::SFloat64) = SFloat64(+(RND, a.value, -b.value))
/(a::SFloat64, b::SFloat64) = SFloat64(/(RND, a.value, b.value))

Base.zero(::SFloat64) = SFloat64(0.)
Base.zero(::Type{SFloat64}) = SFloat64(0.)
Base.one(::Type{SFloat64}) = SFloat64(1.)

Base.inv(x::SFloat64) = SFloat64(1.) / x
Base.transpose(x::SFloat64) = x
Base.adjoint(x::SFloat64) = x

Base.convert(::Type{SFloat64}, x::Float64) = SFloat64(x)
Base.convert(::Type{Float64}, x::SFloat64) = x.value
Base.promote_rule(::Type{SFloat64}, ::Type{<:Number}) = SFloat64

value(x::SFloat64) = x.value
