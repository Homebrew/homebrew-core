class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d7c956606e7f52b7703fd2967cb31d2e21ec90c0b440ff1cc7c7d764a4092b98"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8052ad2c3cf363619c481e08ace05aa608524c393a371739877b7cd49644204"
    sha256 cellar: :any,                 arm64_monterey: "f680e1d8c031b995c3311e45af700851dd48e1e8bb0f6853d31937fa77437234"
    sha256 cellar: :any,                 arm64_big_sur:  "1f375a5c53f753b0a769a6f5f86dc7b18f6e689e1f452ce495a50cf2135e4d16"
    sha256 cellar: :any,                 ventura:        "f844e97ab346d800b0e4b27697788e90fc1df03f23bd557c2bc2ace431aac74a"
    sha256 cellar: :any,                 monterey:       "e1a96645352094a69c55ca5549b83252dc9166c8492756e79b9db7ce971a8b8b"
    sha256 cellar: :any,                 big_sur:        "3bf4f57e1445c953e6e2446e9d18f33c9ae6349a850f01d806b3139597abce65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d7c64f8408205f74592dac509f55dae6c896a036c8fd58ba3ff2c67d14edb50"
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
