module EFT
export twoSum, twoProd, twoDiv

# * Documentation of function

"""
    twoSum(a, b)

Error-Free Transformation for the sum of two numbers:

(x,y) = twoSum(a,b)

  <=>

x = fl(a+b)  and  x+y == a+b
"""
function twoSum end


"""
    twoProd(a, b)

Error-Free Transformation for the product of two numbers:

(x,y) = twoProd(a, b)

  <=>

x = fl(a*b)  and  x+y == a*b
"""
function twoProd end


"""
    twoDiv(a, b)

Approximate transformation for the division The transformation in not exact (the
error is not representable) but at least the sign of y should be correct:

(x, y) == twoDiv(a, b)

  <=>

x = fl(a/b)  and  y ≈ a/b - x
"""
function twoDiv end


# * Generic implementation

"""
Generic implementation of twoSum. Uses the algorithm by D. Knuth.
"""
function twoSum(a, b)
    x = a + b
    z = x - a
    y = (a - (x-z)) + (b-z)
    return (x,y)
end


"""
    split(a)

Error-free splitting of a FP number:

(x,y) = split(a)

<=>

x+y == a, and the representations of x and y do not overlap

This implementation uses the algorithm by Dekker.
"""
function Base.split(a)
    # New methods should be added to compute the correct
    # constant for each FP representation
    #
    # factor = 1+2^s, where s is the mantissa length
    factor(x::Float64) = 134217729
    factor(x::Float32) = 4097

    c = factor(a) * a
    x = c - (c - a)
    y = a - x
    return (x, y)
end

"""
Generic implementation of TwoProd. Uses the algorithm by Veltkamp.
"""
function twoProd(a, b)
    x = a * b
    (a1, a2) = split(a)
    (b1, b2) = split(b)
    y = a2*b2 - (((x - a1*b1) - a2*b1) - a1*b2)
    return (x,y)
end

function twoDiv(a, b)
    x = a / b
    (p1, p2) = twoProd(x, b)
    y = (a-p1-p2)/b
    return (x, y)
end


# * Specific algorithms for Float32

# Since double precision (Float64) is available to run higher-precision
# computations, it should be used to compute more efficiently transformations of
# Float32 operations.

macro float32_transformation(operator, name)
    quote
        function $(esc(name))(a::Float32, b::Float32)
            x = $operator(a, b)
            r = $operator(Float64(a), Float64(b)) - Float64(x)
            y = Float32(r)
            return (x,y)
        end
    end
end

@float32_transformation(+, twoSum)
@float32_transformation(*, twoProd)
@float32_transformation(/, twoDiv)

end
