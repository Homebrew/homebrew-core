class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "785bb98e7d6705c51c8dfa8ac3af6aa2ccfa3774714d51c0b9e28fac1146e9f1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df425b521f46c58e13a1bb877d7a59fdeaf405ec020c530c6052bcab8108b007"
    sha256 cellar: :any,                 arm64_sonoma:  "f1e59f7f9158c265009d9e68474320514d4275e3fc4ddd9c90b97e690fbb51c1"
    sha256 cellar: :any,                 arm64_ventura: "7d62c4478e434647dd715759c7c1e5d6d891823b835e102c01458ae41cf278c6"
    sha256 cellar: :any,                 sonoma:        "11d1cfee8f09a6a398cb05161e3b132634385f9ea17f3f1be9816777fa5fc693"
    sha256 cellar: :any,                 ventura:       "29a61d5ddeb1e6b5a9d6ced52e059530e8cc1cd0d734a8258d6b48847506dcc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e524ded9708762e9b13a77b719d2ef7dbf44e4192444c113e7e8dd75b544122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "021cdad1de96cc81c67a779074717150bd1aa5eff164ecc10d91226871a805dd"
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
    (testpath/"test.c").write <<~C
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lsecp256k1",
                   "-o", "test"
    system "./test"
  end
end
