class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ef2e1061951b8cf94a7597b4e60fd7810613e327e25305e8d73dfdff67d12190"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c7aadfa2c4e16008976d0392d303d853ca303761a33edefbc91bd65349033d1"
    sha256 cellar: :any,                 arm64_monterey: "b151935b712ede931579c527659980601eb91daa75914bce6a2aa18f8acc598a"
    sha256 cellar: :any,                 arm64_big_sur:  "4cd10f47fcd3830ad58ccaea156aa804d74af61adbbbd886e7db1a8503259089"
    sha256 cellar: :any,                 ventura:        "97b55ceb0fd8419d8374ea420cb3517a90a88252469d590074aacd3b2a20c7f5"
    sha256 cellar: :any,                 monterey:       "4bdeb1e333d34144fe0c1b461461cd0772ac64a45acb38fc26ed81c75ce13614"
    sha256 cellar: :any,                 big_sur:        "72c9a488df7b3885b8cbeb636e00dab0fcf0efd9ad015156869083b23e0b5e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59e49adc20fcfff78ad76299b8e4f314d43f59a3f35fa33fcbc315ad52aad5c"
  end

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-module-recovery"
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
