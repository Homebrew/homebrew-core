class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "07934fde88c677abbc4d42c36ef7ef8d3850cd0c065e4f976f66f4f97502c95a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93eee8b392a8688a7bc5c9d4aaa28f118919c87d4deadebe840006e4962f13de"
    sha256 cellar: :any,                 arm64_ventura:  "b63f652b4fafc0fdbcb6eb19a2648fb23050dc4261338d5adca96374e33f6075"
    sha256 cellar: :any,                 arm64_monterey: "ade0ac4f6b18b4c15ccd6daad9049d999a12252510863e7bc9cf418cdbf6c449"
    sha256 cellar: :any,                 sonoma:         "5683c21ad03defb496ecbd4c25678ae41a835aa0f2ac1672fd1a5f30a892e07c"
    sha256 cellar: :any,                 ventura:        "4bb4dc07b5fc6bde6b609eff5e65cfb5b5b2065a82b3c7629917ec605852ac87"
    sha256 cellar: :any,                 monterey:       "e516724759530edee3ed7e31db0223af90f6bb23de976ecac0b0289f6064474f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b5d55719eee2b055c887ab7332093c075462d0bb18ba392fe2baf1c41eec78"
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
