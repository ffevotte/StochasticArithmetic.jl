#!/bin/bash
#=
exec julia --color=yes make.jl
=#

push!(LOAD_PATH, "../src/")
using Documenter, StochasticArithmetic

makedocs(
    modules = [StochasticArithmetic],
    format = :html,
    checkdocs = :exports,
    sitename = "StochasticArithmetic.jl",
    # doctest = :fix,
    pages = Any["Home" => "index.md",
                "Error-Free Transformations" => "EFT.md",
                "Rounding modes" => "rounding.md",
                "Stochastic FP types" => "sfloat.md"]
)

deploydocs(
    repo = "github.com/ffevotte/StochasticArithmetic.jl.git",
)

# Local Variables:
# mode: julia
# End:
