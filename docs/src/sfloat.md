# [Stochastic Floating-Point Types](@id sfloat)


This package defines a new `SFloat64` type which represents a regular
double-precision floating-point number, except every operation gets randomly
rounded upwards or downwards. It should be possible tu use `SFloat64` numbers
everywhere `Float64` would be supported. For example:

```@meta
DocTestSetup = quote
    using StochasticArithmetic
    using Random
    Random.seed!(42)
    
    A = Float64[1 2 3; 4 5 6; 7 8 10];
    B = Float64[1 ; 2 ; 3];
end
```

```
julia> A = Float64[1 2 3;
                   4 5 6;
                   7 8 10];
julia> B = Float64[1 ; 2 ; 3];
```

```jldoctest
julia> A \ B
3-element Array{Float64,1}:
 -0.3333333333333333
  0.6666666666666666
 -0.0
```

```jldoctest
julia> SFloat64.(A) \ SFloat64.(B)
3-element Array{SFloat64,1}:
 SFloat64(-0.3333333333333325)
 SFloat64(0.666666666666665)
 SFloat64(8.881784197001221e-16)
```

```@meta
DocTestSetup = nothing
```


## Reference


```@docs
SFloat64
```
