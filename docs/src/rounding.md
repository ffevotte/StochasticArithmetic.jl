# [Floating-Point operations with specific rounding mode](@id rounding)

Directed roundings for an operation $a\circ b$ can be computed using EFTs in the
following way: let $(x, \delta) = \bigcirc_{\text{eft}}(a, b)$. One of three
situations can happen:

- if $\delta = 0$, then no rounding occurred. In this case, $x = \lozenge(a\circ
  b) = a\circ b$.

- if $\delta > 0$, then a rounding occurred, which was directed downwards. In
  this case, $x = \lozenge(a\circ b) = \bigtriangledown(a\circ b)$ and
  $\bigtriangleup(a\circ b) = \text{successor}(x)$.

- conversely, if $\delta > 0$, then $x = \lozenge(a\circ b) =
  \bigtriangleup(a\circ b)$ and $\bigtriangleup(a\circ b) =
  \text{predecessor}(x)$.


This strategy is used to implement basic FP operations with directed
rounding. In addition to IEEE-754 directed roundings : upwards (`UP`) and
downwards (`DWN`), an additional random (`RND`) rounding mode is introduced,
which chooses one of the two directed roundings randomly with probability 0.5.

```@meta
DocTestSetup = quote
    using StochasticArithmetic
    using Random
    Random.seed!(42)
end
```

```jldoctest
julia> +(DWN, 0.1, 0.3)
0.39999999999999997

julia> +(UP,  0.1, 0.3)
0.4

julia> +(RND, 0.1, 0.3)
0.39999999999999997
```

```jldoctest
julia> *(DWN, 0.1, 0.3)
0.03

julia> *(UP,  0.1, 0.3)
0.030000000000000002

julia> *(RND, 0.1, 0.3)
0.030000000000000002
```

```jldoctest
julia> /(DWN, 0.1, 0.3)
0.3333333333333333

julia> /(UP,  0.1, 0.3)
0.33333333333333337

julia> /(RND, 0.1, 0.3)
0.3333333333333333
```



```@meta
DocTestSetup = nothing
```
