class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "eb52b0e9239dff7dc26be5f9623567141b8720ec47da29eb3c1e0a660d17c8bb"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3cfd59f39885c79d2fecdf2bce38c4328d62157caa0e1390abddbefd7f31be24"
    sha256 cellar: :any, arm64_sequoia: "787baf3e52ae25e66a773250914051e720239832c23aaa6289b43c912c81d315"
    sha256 cellar: :any, arm64_sonoma:  "161b43d84014e54f778457bd378a463621e3b54c32ff88ec847023e0beaba2dc"
    sha256 cellar: :any, sonoma:        "92d5961f7d4e51229d41c21d2f4c4ea3c4a506359ee0931fa36fb2f5ce59b56e"
    sha256 cellar: :any, arm64_linux:   "da03a05f65ef2e7f1cac223c33950890bed80bbaf9d268c89f97cf0e2760d6ce"
    sha256 cellar: :any, x86_64_linux:  "d1e8e76c37b642980dc7ee04ebc87823daeca6417f0c920bfc2b03f3af812f41"
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
