# StochasticArithmetic
    
It is relatively well known in the scientific computing community that the use
of finite-precision floating-point (FP) computations (as opposed to computations
with real, infinite-precision numbers) can be the source of quality losses in
the computed results.
     
Stochastic Arithmetic is one of many ways which can be used to diagnose
FP-related problems. In standard IEEE-754-compliant Floating-Point Arithmetic,
the result of each floating-point operation is rounded to the nearest
representable floating-point value. When some floating-point operations produce
results which are not representable as floating-point values (as is the case,
for example of 1/3 in base 10, or 1/10 in binary representations), some
information is lost during this rounding operation. Stochastic Arithmetic models
this loss of accuracy using random variables.
    
More precisely, this package implements the CESTAC arithmetic [Jean Vignes and
Michel La Porte. Error Analysis in Computing, 1974] in which the result of each
FP operation $x\circ y$ is replaced with

```math
\bigcirc_{\text{rnd}}(x,y) = \left|\begin{array}{ll} \bigtriangledown(x\circ y)
& \text{with probability $\displaystyle\frac12$}, \\[1em]
\bigtriangleup(x\circ y) & \text{with
probability $\displaystyle\frac12$}, \end{array}\right.
```

where for any real value $a\in\mathbb{R}$, $\bigtriangleup(a)$ and
$\bigtriangledown(a)$ respectively denote its upward- and downward-rounded
floating-point values.
    
Operations in this package do not rely on changing the hardware rounding mode,
since this can be vey inefficient. Instead, the implementation proposed here
follows the same overall design as the
[Verrou](http://github.com/edf-hpc/verrou) tool: [Error-Free
Transformations](@ref eft) are used to efficiently simulate directed [rounding
modes](@ref rounding). New stochastic Floating-Point [types](@ref sfloat) rely on this to model
regular FP numbers, on which arithmetic operations get randomly rounded upwards
or downwards.
