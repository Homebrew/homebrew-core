class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "31b1a03c7365dbce7aff4be9526243da966c58a8b88b6255556d51b3016492c5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03b40bddbb6b72659f949217d4b4a1c050702d1dd21c53eeb1652c2292887c2a"
    sha256 cellar: :any,                 arm64_ventura:  "4c98d29ae39b63c0895288c7b17f8fa61f9139018e4cf3448d747affbf4c2ce7"
    sha256 cellar: :any,                 arm64_monterey: "6f445670af428d307d02e9a84bcaf265fdae9bcd05626bc00cf2a874cce381b8"
    sha256 cellar: :any,                 sonoma:         "165da4588d4cc04a0c91c9b564e8147dab1d46c51252ea2211366c5a1a15f397"
    sha256 cellar: :any,                 ventura:        "95ad19b967af85bb774f2944ccef71690f128b8de68e2271c4f2025eae126d3a"
    sha256 cellar: :any,                 monterey:       "fbd592da40640caa0ce5ba425da4ef913d14b7be9a65a907e6d70f16bcef8f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46a1c0169fb6ea73146f0dd7aa6a970502191bf230f8f70054319eb4105361b"
  end

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    args = %w[
      --disable-silent-rules
      --enable-module-recovery
      --enable-module-ecdh
      --enable-module-schnorrsig
      --enable-module-extrakeys
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lsecp256k1",
                   "-o", "test"
    system "./test"
  end
end
