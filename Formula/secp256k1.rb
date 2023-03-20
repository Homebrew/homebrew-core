class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f96c62406a79c52388f69948f74443272904704b91128bbb137971bc65897458"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06858d2a9d01e2ae707aa11675fccce5758ef5b958e22d928b5464de2ea3bfea"
    sha256 cellar: :any,                 arm64_monterey: "590186c846ebd4e2fa28bb2ae48c1dfe9265630affcc9e1a60bd0404b21ff93b"
    sha256 cellar: :any,                 arm64_big_sur:  "05d92e03523d58c11198306f828bba7ea867517bc3cb4f8a4c3250224b1dd695"
    sha256 cellar: :any,                 ventura:        "dedfdfd1f823ca90e9897e88c2d139f2a32fe0c994d128ff1c55eccdb617563f"
    sha256 cellar: :any,                 monterey:       "fe564535cbb80b4af952dfb28d79f68623d5362343b6df71147fed32def135c0"
    sha256 cellar: :any,                 big_sur:        "f86f42457da68f886bf763a2947b371312ae2f751d3dda8e1aba7df3f7ee3f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342e11ebe9de3f341ffb93807797396b24e045b102874ac036342b9f158f2e16"
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
