module ECC

export ECPoint, multiply, reduction, reduction192, reduction224, 
       reduction256, reduction384, reduction521, set_prime, set_curve, 
       affinify, Curve, null, p192, p224, p256, p384, p521

# Curve enums for quick switching
@enum Curve null = 0 p192 = 1 p224 = 2 p256 = 3 p384 = 4 p521 = 5

# Point on elliptic curve
mutable struct ECPoint
    x::BigInt
    y::BigInt
    z::BigInt
end

prime = 0
curve = null

function Base.:+(P::ECPoint, Q::ECPoint)
    global prime
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

function multiply(x::BigInt, y::BigInt, z...)
    # reduce result from multiplication
    result = reduction(x * y)
    for r in z
        result = reduction(result * r)
    end
    return result
end

function reduction(x::BigInt)::BigInt
    # use Barrett reduction for NIST curves
    global curve
    if curve == p192
        return reduction192(x)
    elseif curve == p224
        return reduction224(x)
    elseif curve == p256
        return reduction256(x)
    elseif curve == p384
        return reduction384(x)
    elseif curve == p521
        return reduction521(x)
    end
end

# todo: update to barrett reduction formulas
function reduction192(x::BigInt)::BigInt
    global prime
    return mod(x, prime)
end

function reduction224(x::BigInt)::BigInt
    global prime
    return mod(x, prime)
end

function reduction256(x::BigInt)::BigInt
    global prime
    return mod(x, prime)
end

function reduction384(x::BigInt)::BigInt
    global prime
    return mod(x, prime)
end

function reduction521(x::BigInt)::BigInt
    global prime
    return mod(x, prime)
end

function Base.:*(k::BigInt, P::ECPoint)::ECPoint
    R0 = ECPoint(0, 1, 0)
    R1 = ECPoint(P.x, P.y, P.z)
    bits = ndigits(k, base=2)
    dig = digits(k, base=2)
    println(bits)
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

function affinify(P::ECPoint)::ECPoint
    global prime
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

function set_prime(p::BigInt)
    global prime = p
end

function set_curve(c::Curve)
    global curve = c
end

end # module ECC
