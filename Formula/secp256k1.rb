class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "0e7bb22c29ed6add5e3631e6a9ed0526f3020a20f3b99e6151918fba6cf6affa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbbf2edffb2371af96bd8c595306b8bc49c9496735648fe6f6f8e7c349f8f6a9"
    sha256 cellar: :any,                 arm64_monterey: "511ea10f1ce0465b014ea8eda4efa1d56d964a8cbbf8c1c93d59dd4d355a7f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "2baa3ef9d257894e11ccbed8c00d51028bf0a213da31ffdd8f62be1c6e7effe8"
    sha256 cellar: :any,                 ventura:        "a7bebb8953d6f4875311d6a7d5631634ba936b2a73e7c0b862f026fa0042a0d0"
    sha256 cellar: :any,                 monterey:       "4bacdb868a069a37e735a21368ebc5fa312103114de3a8bb836c40f30387bfd3"
    sha256 cellar: :any,                 big_sur:        "389eeb9c37b9b70dd7af5dd91bac1e470fc7dd077fd540c63d4722e223d664e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff58608bd62932a166e89bcabff6514513bb91d66c0bf51503e338cfa720cead"
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
