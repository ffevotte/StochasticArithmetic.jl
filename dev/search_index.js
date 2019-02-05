var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#StochasticArithmetic-1",
    "page": "Home",
    "title": "StochasticArithmetic",
    "category": "section",
    "text": "It is relatively well known in the scientific computing community that the use of finite-precision floating-point (FP) computations (as opposed to computations with real, infinite-precision numbers) can be the source of quality losses in the computed results.Stochastic Arithmetic is one of many ways which can be used to diagnose FP-related problems. In standard IEEE-754-compliant Floating-Point Arithmetic, the result of each floating-point operation is rounded to the nearest representable floating-point value. When some floating-point operations produce results which are not representable as floating-point values (as is the case, for example of 1/3 in base 10, or 1/10 in binary representations), some information is lost during this rounding operation. Stochastic Arithmetic models this loss of accuracy using random variables.More precisely, this package implements the CESTAC arithmetic [Jean Vignes and Michel La Porte. Error Analysis in Computing, 1974] in which the result of each FP operation xcirc y is replaced withbigcirc_textrnd(xy) = leftbeginarrayll bigtriangledown(xcirc y)\n textwith probability displaystylefrac12 1em\nbigtriangleup(xcirc y)  textwith\nprobability displaystylefrac12 endarrayrightwhere for any real value ainmathbbR, bigtriangleup(a) and bigtriangledown(a) respectively denote its upward- and downward-rounded floating-point values.Operations in this package do not rely on changing the hardware rounding mode, since this can be vey inefficient. Instead, the implementation proposed here follows the same overall design as the Verrou tool: Error-Free Transformations are used to efficiently simulate directed rounding modes. New stochastic Floating-Point types rely on this to model regular FP numbers, on which arithmetic operations get randomly rounded upwards or downwards."
},

{
    "location": "EFT/#",
    "page": "Error-Free Transformations",
    "title": "Error-Free Transformations",
    "category": "page",
    "text": ""
},

{
    "location": "EFT/#eft-1",
    "page": "Error-Free Transformations",
    "title": "Error-Free Transformations",
    "category": "section",
    "text": "An Error-Free Transformation (EFT) for a given operation circ in + - times is a transformation allowing to express(x delta) = bigcirc_texteft(a b)such thatbeginalign*\nx + delta = acirc b\nx = lozenge(acirc b)\nendalign*where lozenge(x) denotes rounding xinmathbbR to the nearest representable FP value, and all equalities written above are exactly valid (i.e. in the sense of real, infinite-precision computations).EFTs are defined in the StochasticArithmetic.EFT module. They are used by other parts of StochasticArithmetic.jl, but can also be used standalone, for example to implement compensated algorithms."
},

{
    "location": "EFT/#StochasticArithmetic.EFT.twoSum",
    "page": "Error-Free Transformations",
    "title": "StochasticArithmetic.EFT.twoSum",
    "category": "function",
    "text": "twoSum(a, b)\n\nError-Free Transformation for the sum of two numbers:\n\n(x,y) = twoSum(a,b)\n\nLeftrightarrow\n\nx = fl(a+b)  and  x+y = a+b\n\n\n\n\n\n"
},

{
    "location": "EFT/#StochasticArithmetic.EFT.twoProd",
    "page": "Error-Free Transformations",
    "title": "StochasticArithmetic.EFT.twoProd",
    "category": "function",
    "text": "twoProd(a, b)\n\nError-Free Transformation for the product of two numbers:\n\n(x,y) = twoProd(a, b)\n\nLeftrightarrow\n\nx = fl(ab)  and  x+y = ab\n\n\n\n\n\n"
},

{
    "location": "EFT/#StochasticArithmetic.EFT.twoDiv",
    "page": "Error-Free Transformations",
    "title": "StochasticArithmetic.EFT.twoDiv",
    "category": "function",
    "text": "twoDiv(a, b)\n\nApproximate transformation for the division. The transformation is not exact (the error is not representable) but at least the sign of y should be correct:\n\n(x, y) = twoDiv(a, b)\n\nLeftrightarrow\n\nx = fl(ab)  and  y  ab - x\n\n\n\n\n\n"
},

{
    "location": "EFT/#Reference-1",
    "page": "Error-Free Transformations",
    "title": "Reference",
    "category": "section",
    "text": "using StochasticArithmetic.EFTCurrentModule = StochasticArithmetic.EFTtwoSum\ntwoProd\ntwoDiv"
},

{
    "location": "rounding/#",
    "page": "Rounding modes",
    "title": "Rounding modes",
    "category": "page",
    "text": ""
},

{
    "location": "rounding/#rounding-1",
    "page": "Rounding modes",
    "title": "Floating-Point operations with specific rounding mode",
    "category": "section",
    "text": "Directed roundings for an operation acirc b can be computed using EFTs in the following way: let (x delta) = bigcirc_texteft(a b). One of three situations can happen:if delta = 0, then no rounding occurred. In this case, x = lozenge(acirc b) = acirc b.\nif delta  0, then a rounding occurred, which was directed downwards. In this case, x = lozenge(acirc b) = bigtriangledown(acirc b) and bigtriangleup(acirc b) = textsuccessor(x).\nconversely, if delta  0, then x = lozenge(acirc b) = bigtriangleup(acirc b) and bigtriangleup(acirc b) = textpredecessor(x).This strategy is used to implement basic FP operations with directed rounding. In addition to IEEE-754 directed roundings : upwards (UP) and downwards (DWN), an additional random (RND) rounding mode is introduced, which chooses one of the two directed roundings randomly with probability 0.5.DocTestSetup = quote\n    using StochasticArithmetic\n    using Random\n    Random.seed!(42)\nendjulia> +(DWN, 0.1, 0.3)\n0.39999999999999997\n\njulia> +(UP,  0.1, 0.3)\n0.4\n\njulia> +(RND, 0.1, 0.3)\n0.39999999999999997julia> *(DWN, 0.1, 0.3)\n0.03\n\njulia> *(UP,  0.1, 0.3)\n0.030000000000000002\n\njulia> *(RND, 0.1, 0.3)\n0.030000000000000002julia> /(DWN, 0.1, 0.3)\n0.3333333333333333\n\njulia> /(UP,  0.1, 0.3)\n0.33333333333333337\n\njulia> /(RND, 0.1, 0.3)\n0.3333333333333333DocTestSetup = nothing"
},

{
    "location": "sfloat/#",
    "page": "Stochastic FP types",
    "title": "Stochastic FP types",
    "category": "page",
    "text": ""
},

{
    "location": "sfloat/#sfloat-1",
    "page": "Stochastic FP types",
    "title": "Stochastic Floating-Point Types",
    "category": "section",
    "text": "This package defines a new SFloat64 type which represents a regular double-precision floating-point number, except every operation gets randomly rounded upwards or downwards. It should be possible tu use SFloat64 numbers everywhere Float64 would be supported. For example:DocTestSetup = quote\n    using StochasticArithmetic\n    using Random\n    Random.seed!(42)\n    \n    A = Float64[1 2 3; 4 5 6; 7 8 10];\n    B = Float64[1 ; 2 ; 3];\nendjulia> A = Float64[1 2 3;\n                   4 5 6;\n                   7 8 10];\njulia> B = Float64[1 ; 2 ; 3];julia> A \\ B\n3-element Array{Float64,1}:\n -0.3333333333333333\n  0.6666666666666666\n -0.0julia> SFloat64.(A) \\ SFloat64.(B)\n3-element Array{SFloat64,1}:\n SFloat64(-0.3333333333333325)\n SFloat64(0.666666666666665)\n SFloat64(8.881784197001221e-16)DocTestSetup = nothing"
},

{
    "location": "sfloat/#StochasticArithmetic.SFloat64",
    "page": "Stochastic FP types",
    "title": "StochasticArithmetic.SFloat64",
    "category": "type",
    "text": "Stochastic Float64\n\nThis type represents a double-precision (64-bit) floating-point number, on which every operation gets randomly rounded upwards or downwards.\n\n\n\n\n\n"
},

{
    "location": "sfloat/#Reference-1",
    "page": "Stochastic FP types",
    "title": "Reference",
    "category": "section",
    "text": "SFloat64"
},

]}
