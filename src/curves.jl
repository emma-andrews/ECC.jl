module curves

export Curve, Weierstrass, Montgomery, TwistedEdwards,
    P192

abstract type Curve end

struct Weierstrass <: Curve
    prime::BigInt
    G::ECPoint # generator point
    a::BigInt # a and b from curve equation
    b::BigInt
    name::String
end

struct Montgomery <: Curve end
struct TwistedEdwards <: Curve end

const P192 = Weierstrass(0xfffffffffffffffffffffffffffffffeffffffffffffffff,
    ECPoint(0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012,
        0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811,
        1
    ),
    0xfffffffffffffffffffffffffffffffefffffffffffffffc,
    0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1,
    "P192"
)

end