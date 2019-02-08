# StochasticArithmetic.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.org/ffevotte/StochasticArithmetic.jl.svg?branch=master)](https://travis-ci.org/ffevotte/StochasticArithmetic.jl)
[![codecov.io](http://codecov.io/github/ffevotte/StochasticArithmetic.jl/coverage.svg?branch=master)](http://codecov.io/github/ffevotte/StochasticArithmetic.jl?branch=master)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://ffevotte.github.io/StochasticArithmetic.jl/dev/)

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

This package implements the CESTAC arithmetic [Jean Vignes and Michel La
Porte. Error Analysis in Computing, 1974] in which the result of each FP
operation is randomly rounded upwards or downwards. When a complete computation
is run with Stochastic Arithmetic, its results become realizations of a random
variable. Studying the distribution of this random variable helps understanding
the global impact of round-off errors on the computation.

Taking the example of an ill-conditioned dot product:

```
julia> x = ...
100-element Array{Float64,1}:
     -47.03899089072116
   -2302.2081944322417
 -156472.61080419843
   15263.008992086134
    -213.23078574079136
[...]

julia> y = ...
100-element Array{Float64,1}:
      -1.2528717788873576
    1078.9625210090078
  -31748.947458491493
      -0.015303734559162641
       4.784478272815557
[...]

julia> using LinearAlgebra
julia> dot(x, y)
0.8098193831511069

julia> @reliable_digits dot(SFloat64.(x), SFloat64.(y))
(0.8097595996923976, 3.798286681716415)
```
In the last instruction above, vectors were converted to a stochastic type
(`SFloat64`), effectively transforming the result of the dot product into a
random variable. Macro call `@reliable_digits` performs the computation a few
times and computes statistics estimating that:

- the averaged result is approximately 0.810,
- only 3 to 4 (decimal) digits should be relied upon in this result; the other
  are likely numerical noise.

See the [full
documentation](https://ffevotte.github.io/StochasticArithmetic.jl/dev/) for more
details.

<br/>

<hr/>

## Other tools

CESTAC and similar stochastic methods are currently implemented in various tools, such as:

- [CADNA](https://www-pequan.lip6.fr/cadna/): a library to be used by Fortran
  and C/C++ programs;
  
- [Verificarlo](https://github.com/verificarlo/verificarlo): an LLVM-based tool
  instrumenting programs at compile-time;

- [Verrou](http://github.com/edf-hpc/verrou): a Valgrind-based tool which
  dynamically instruments binary executables. The techniques used in
  StochasticArithmetic.jl closely follow those implemented in Verrou.
