"Module for performing elliptic curve cryptography on standardized curves"
module ECC

include("curves.jl")

export multiply, set_curve, affinify, ecdsa_sign

using SHA

curve::Curve = EMPTY

function Base.:+(P::ECPoint, Q::ECPoint)
    global curve
    prime = curve.prime
    if P.z == 0
        return Q
    elseif Q.z == 0
        return P
    end
    # different calculation if points are the same (doubling)
    if P.x == Q.x && P.y == Q.y && P.z == Q.z
        a = multiply(big(4), P.x, P.y, P.y)
        b = multiply(big(8), P.y, P.y, P.y, P.y)
        c = multiply(multiply(big(3), P.x - multiply(P.z, P.z)), P.x + multiply(P.z, P.z))
        d = mod((prime - a) + (prime - a) + multiply(c, c), prime)
        y = mod(multiply(c, a - d) - b, prime)
        z = multiply(big(2), P.y, P.z)
        return ECPoint(d, y, z)
    else
        if Q.z != 1
            Q = affinify(Q)
        end
        # multiply already calls mod prime, no need to recall on single multiply statements
        a = multiply(Q.x, P.z, P.z)
        b = multiply(Q.y, P.z, P.z, P.z)
        c = mod(a - P.x, prime)
        d = mod(b - P.y, prime)
        x = mod(multiply(d, d) - (multiply(c, c, c) + multiply(big(2), P.x, c, c)), prime)
        y = mod(multiply(d, multiply(P.x, c, c) - x) - multiply(P.y, multiply(c, c, c)), prime)
        z = multiply(P.z, c)
        return ECPoint(x, y, z)
    end
end

function Base.:(==)(P::ECPoint, Q::ECPoint)
    return P.x == Q.x && P.y == Q.y && P.z == Q.z
end

"""
    multiply(x, y, z ...)

Multiply two or more fields together, reducing each step modulo prime
"""
function multiply(x::BigInt, y::BigInt, z...)
    global curve
    prime = curve.prime
    # reduce result from multiplication
    result = mod(x * y, prime)
    for r in z
        result = mod(result * r, prime)
    end
    return result
end

function Base.:*(k::BigInt, P::ECPoint)::ECPoint
    R0 = ECPoint(0, 1, 0)
    R1 = ECPoint(P.x, P.y, P.z)
    bits = ndigits(k, base=2)
    dig = digits(k, base=2)
    for i = bits:-1:1
        if dig[i] == 0
            R1 = R0 + R1
            R0 = R0 + R0
        else
            R0 = R0 + R1
            R1 = R1 + R1
        end
    end
    return R0
end

"""
    affinify(P::ECPoint)

Convert an elliptic curve point from projective representation to affine representation.
Returns the resulting point in affine representation.
"""
function affinify(P::ECPoint)::ECPoint
    global curve
    prime = curve.prime
    # convert from projective to affine coordinates
    if P.z == 1 || P.z == 0
        # ignore point at infinity and points already in affine
        return P
    else
        lambda = powermod(P.z, -1, prime)
        x = mod(multiply(lambda, lambda, P.x), prime)
        y = mod(multiply(lambda, lambda, lambda, P.y), prime)
        return ECPoint(x, y, 1)
    end
end

function Base.show(io::IO, P::ECPoint)
    # custom point printing in hex
    x = string(P.x, base=16)
    y = string(P.y, base=16)
    z = string(P.z, base=16)
    print(io, "(", x, ", ", y, ", ", z, ")")
end

function set_curve(c::Curve)
    global curve = c
end

function ecdsa_sign(message::String)
    global curve
    e = bytes2hex(sha256(message))
    bits = ndigits(curve.n, base=2)
    z = e[1:bits]
end

end # module ECC
