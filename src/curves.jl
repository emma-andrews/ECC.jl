export ECPoint, Curve, Weierstrass, Montgomery, TwistedEdwards,
    EMPTY, P192, P224, P256, P384, P521

"""
Point on an elliptic curve

# Fields
- x: x-coordinate
- y: y-coordinate
- z: z-coordinate, used for computation in projective form
"""
mutable struct ECPoint
    x::BigInt
    y::BigInt
    z::BigInt
end

# generic curve type
abstract type Curve end

# Weierstrass curve type
struct Weierstrass <: Curve
    prime::BigInt
    G::ECPoint # generator point
    a::BigInt # a and b from curve equation
    b::BigInt
    name::String
end

# montgomery curve type
struct Montgomery <: Curve end

# twisted edwards curve type
struct TwistedEdwards <: Curve end

# empty curve for no operations
const EMPTY = Weierstrass(0, ECPoint(0, 1, 0), 0, 0, "Empty")

# NIST P-192
const P192 = Weierstrass(0xfffffffffffffffffffffffffffffffeffffffffffffffff,
    ECPoint(0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012,
        0x07192b95ffc8da78631011ed6b24cdd573f977a11e794811,
        1
    ),
    0xfffffffffffffffffffffffffffffffefffffffffffffffc,
    0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1,
    "P192"
)

# NIST P-224
const P224 = Weierstrass(0xffffffffffffffffffffffffffffffff000000000000000000000001,
    ECPoint(0xb70e0cbd6bb4bf7f321390b94a03c1d356c21122343280d6115c1d21,
        0xbd376388b5f723fb4c22dfe6cd4375a05a07476444d5819985007e34,
        1
    ),
    0xfffffffffffffffffffffffffffffffefffffffffffffffffffffffe,
    0xb4050a850c04b3abf54132565044b0b7d7bfd8ba270b39432355ffb4,
    "P224"
)

const P256 = Weierstrass(0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff,
    ECPoint(0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296,
        0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5,
        1
    ),
    0xffffffff00000001000000000000000000000000fffffffffffffffffffffffc,
    0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b,
    "P256"
)

const P384 = Weierstrass(
    0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000ffffffff,
    ECPoint(0xaa87ca22be8b05378eb1c71ef320ad746e1d3b628ba79b9859f741e082542a385502f25dbf55296c3a545e3872760aB7,
        0x3617de4a96262c6f5d9e98bf9292dc29f8f41dbd289a147ce9da3113b5f0b8c00a60b1ce1d7e819d7a431d7c90ea0e5F,
        1
    ),
    0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeffffffff0000000000000000fffffffc,
    0xb3312fa7e23ee7e4988e056be3f82d19181d9c6efe8141120314088f5013875ac656398d8a2ed19d2a85c8edd3ec2aef,
    "P384"
)

const P521 = Weierstrass(
    0x000001ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff,
    ECPoint(
        0x000000c6858e06b70404e9cd9e3ecb662395b4429c648139053fb521f828af606b4d3dbaa14b5e77efe75928fe1dc127a2ffa8de3348b3c1856a429bf97e7e31c2e5bd66,
        0x0000011839296a789a3bc0045c8a5fb42c7d1bd998f54449579b446817afbd17273e662c97ee72995ef42640c550b9013fad0761353c7086a272c24088be94769fd16650,
        1
    ),
    0x000001fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc,
    0x00000051953eb9618e1c9a1f929a21a0b68540eea2da725b99b315f3b8b489918ef109e156193951ec7e937b1652c0bd3bb1bf073573df883d2c34f1ef451fd46b503f00,
    "P521"
)