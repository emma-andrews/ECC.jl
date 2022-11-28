mutable struct ECPoint
    x::Int64
    y::Int64
    z::Int64
end

function Base.:+(P::ECPoint, Q::ECPoint, prime::Int64)
    isDbl = P.x == Q.x && P.y == Q.y && P.z == Q.z
    if isDbl
    else
        if Q.z != 1
            Q = affinify(Q, prime)
        end
        a = (Q.x * P.z * P.z) % prime
        b = (Q.y * P.z * P.z * P.z) % prime
        c = (a - P.x) % prime
        d = (b - P.y) % prime
        x = ((d * d) - ((c ^ 3) + (2 * P.x * c * c))) % prime
        y = (d * ((P.x * c * c) - x) - (P.y * (c ^ 3))) % prime
        z = (P.z * c) % prime
    end
end

function affinify(P::ECPoint, prime::Int64)::ECPoint
    if P.z == 1 || P.z == 0
        return P
    else
        lambda = powermod(P.z, -1, prime)
        x = (lambda * lambda * P.x) % prime
        y = (lambda * lambda * lambda * P.y) % prime
        R = ECPoint(x, y, 1)
        return R
    end
end