using ECC
using Test

@testset "P-192" begin
    set_curve(P192)
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
    set_curve(P224)

    x1 = 0x6eca814ba59a930843dc814edd6c97da95518df3c6fdf16e9a10bb5b
    y1 = 0xef4b497f0963bc8b6aec0ca0f259b89cd80994147e05dc6b64d7bf22
    S = ECPoint(x1, y1, 1)

    x2 = 0xb72b25aea5cb03fb88d7e842002969648e6ef23c5d39ac903826bd6d
    y2 = 0xc42a8a4d34984f0b71b5b4091af7dceb33ea729c1a2dc8b434f10c34
    T = ECPoint(x2, y2, 1)

    @test affinify(S + T) == ECPoint(0x236f26d9e84c2f7d776b107bd478ee0a6d2bcfcaa2162afae8d2fd15,
        0xe53cc0a7904ce6c3746f6a97471297a0b7d5cdf8d536ae25bb0fda70, 1)

    @test affinify(S + S) == ECPoint(0xa9c96f2117dee0f27ca56850ebb46efad8ee26852f165e29cb5cdfc7,
        0xadf18c84cf77ced4d76d4930417d9579207840bf49bfbf5837dfdd7d, 1)

    d = 0xa78ccc30eaca0fcc8e36b2dd6fbb03df06d37f52711e6363aaf1d73b
    @test affinify(d * S) == ECPoint(0x96a7625e92a8d72bff1113abdb95777e736a14c6fdaacc392702bca4,
        0x0f8e5702942a3c5e13cd2fd5801915258b43dfadc70d15dbada3ed10, 1)
end

@testset "P-256" begin
    set_curve(P256)
end

@testset "P-384" begin
    set_curve(P384)
end

@testset "P-521" begin
    set_curve(P521)
end