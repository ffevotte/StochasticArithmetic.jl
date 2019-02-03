# [Error-Free Transformations](@id eft)

An Error-Free Transformation (EFT) for a given operation $\circ \in \{+, -,
\times\}$ is a transformation allowing to express
```math
(x, \delta) = \bigcirc_{\text{eft}}(a, b)
```
such that
```math
\begin{align*}
&x + \delta = a\circ b,\\
&x = \lozenge(a\circ b),
\end{align*}
```
where $\lozenge(x)$ denotes rounding $x\in\mathbb{R}$ to the nearest
representable FP value, and all equalities written above are exactly valid
(*i.e.* in the sense of real, infinite-precision computations).

EFTs are defined in the `StochasticArithmetic.EFT` module. They are used by
other parts of `StochasticArithmetic.jl`, but can also be used standalone, for
example to implement compensated algorithms.

## Reference

```
using StochasticArithmetic.EFT
```

```@meta
CurrentModule = StochasticArithmetic.EFT
```

```@docs
twoSum
twoProd
twoDiv
```
