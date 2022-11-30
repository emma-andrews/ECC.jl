using ECC
using Test

@testset "P-192" begin
    ECC.set_prime(0xfffffffffffffffffffffffffffffffeffffffffffffffff)
    ECC.set_curve(p192)
    x1 = 0xd458e7d127ae671b0c330266d246769353a012073e97acf8
    y1 = 0x325930500d851f336bddc050cf7fb11b5673a1645086df3b
    S = ECPoint(x1, y1, 1)
    x2 = 0xf22c4395213e9ebe67ddecdd87fdbd01be16fb059b9753a4
    y2 = 0x264424096af2b3597796db48f8dfb41fa9cecc97691a9c79
    T = ECPoint(x2, y2, 1)

    # point addition
    @test affinify(S + T) == ECPoint(0x48e1e4096b9b8e5ca9d0f1f077b8abf58e843894de4d0290, 
        0x408fa77c797cd7dbfb16aa48a3648d3d63c94117d7b6aa4b, 1)

    # point doubling
    @test affinify(S + S) == ECPoint(0x30c5bc6b8c7da25354b373dc14dd8a0eba42d25a3f6e6962,
        0x0dde14bc4249a721c407aedbf011e2ddbbcb2968c9d889cf, 1)

    # scalar multiplication
    d = 0xa78a236d60baec0c5dd41b33a542463a8255391af64c74ee
    @test affinify(d * S) == ECPoint(0x1faee4205a4f669d2d0a8f25e3bcec9a62a6952965bf6d31,
        0x5ff2cdfa508a2581892367087c696f179e7a4d7e8260fb06, 1)
end

@testset "P-224" begin
    
end

@testset "P-256" begin
    
end

@testset "P-384" begin
    
end

@testset "P-521" begin
    
end