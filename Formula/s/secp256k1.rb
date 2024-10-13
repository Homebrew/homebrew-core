class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "081f4730becba2715a6b0fd198fedd9e649a6caaa6a7d6d3cf0f9fa7483f2cf1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "63acff5cca20cf35d418316d11fab3930384c3f5d2b6f67def6ff90c38dcae25"
    sha256 cellar: :any,                 arm64_sonoma:   "dc8c68c51ab101aef56121fa672050640af6e127f3b8d9480126dd2215dd0d0e"
    sha256 cellar: :any,                 arm64_ventura:  "826e86e829d68f144751d76eef24068c9d636fea551317a64cf9bb4be0eded86"
    sha256 cellar: :any,                 arm64_monterey: "2915c652a10d2c5c66c0771dfdb6fc6804b977b1a7d736341011d9922d64588f"
    sha256 cellar: :any,                 sonoma:         "6871a2013ba7afbee1d24689f7c7fdeb31a0270a8fe11221f251635b69b59578"
    sha256 cellar: :any,                 ventura:        "9af6633c71705d1afc05088794ee92d1228d3977e5c4d8fd201688f98eb9838b"
    sha256 cellar: :any,                 monterey:       "3acade7a85c214c000f252f9fba12ea8f2452e3fd2109fd6eb936f91f4aeade5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56286a0823e4e9c0145223c6b08cb2e7624e4ccc7a07b3f3435794a2bcfbed76"
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
