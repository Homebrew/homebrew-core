class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f96c62406a79c52388f69948f74443272904704b91128bbb137971bc65897458"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c04de7a15f26c12bc7249a4a22aea57e0d96ae62a27647008ececf686b9ea3c1"
    sha256 cellar: :any,                 arm64_monterey: "ee9fc938a7b050a8dd09109d6b1ceacf4e26bb5392cc0d3abd75388bc02e87f0"
    sha256 cellar: :any,                 arm64_big_sur:  "a645f3b3894290a8c15ab2d925b3f892d5c6b5ed365cc4c974b1aa8d5dd161c2"
    sha256 cellar: :any,                 ventura:        "d0eeb9751a4a81fc0e0f3600513282d4c00742a36898b79c73e6d047629ff76b"
    sha256 cellar: :any,                 monterey:       "c8858df58c0936777aa6b25c1fdc23a2f298069fc501747a084786f734b91847"
    sha256 cellar: :any,                 big_sur:        "eabdd956d0cb66dc20f81e08e0fb319a40a151a51689e02b94a68312e555ef6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4db5a8502383769c830fca8b036febbbf7baec7c5bf9b57d46370ee82a87f53"
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
