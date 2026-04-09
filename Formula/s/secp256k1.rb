class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "958f204dbafc117e73a2604285dc2eb2a5128344d3499c114dcba5de54cb7a9e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da2fa73c7222a2b0ecd611814895c92fe175fd59b4a2e60fb9886993c549b842"
    sha256 cellar: :any,                 arm64_sequoia: "07ae325f7e07a797ff61e73a6b785ef5066855459990f568604ae387d5154175"
    sha256 cellar: :any,                 arm64_sonoma:  "329d9345dc3d88b81a2206b921cfd3b0f55241d878e639ce4f2e49b5f1ba5506"
    sha256 cellar: :any,                 sonoma:        "c6a1dfbc6bfaec13225ebc3a979b131dcce74b475afebc60bb8993dd59087112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "684efba291dd63c1bae72882e46db5aa6a94b052ea45db027bc776d964544fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11de3494970a0d0e9b4206ea0a8d5eea0fc119efcd3927e309fed714944c19c"
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
