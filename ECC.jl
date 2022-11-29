module ECC
    # Curve enums for quick switching
    @enum Curve null=0 p192=1 p224=2 p256=3 p384=4 p521=5

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

    function setPrime(p::BigInt)
        global prime = p
    end

    function setCurve(c::Curve)
        global curve = c
    end

    # test data from P-192
    setPrime(0xfffffffffffffffffffffffffffffffeffffffffffffffff)
    setCurve(p192)
    x1 = 0xd458e7d127ae671b0c330266d246769353a012073e97acf8
    y1 = 0x325930500d851f336bddc050cf7fb11b5673a1645086df3b
    S = ECPoint(x1, y1, 1)
    x2 = 0xf22c4395213e9ebe67ddecdd87fdbd01be16fb059b9753a4
    y2 = 0x264424096af2b3597796db48f8dfb41fa9cecc97691a9c79
    T = ECPoint(x2, y2, 1)

    println(affinify(S + T))
    println(affinify(S + S))
end