class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.7.1.tar.gz"
  sha256 "23b0ebce7aa113cb82115d19bea27ea120836e162523d1a9200341b436bf2843"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7bf25601afdc1d241c0cb526a141ae6685c6300586e3b0a31ac5ca9183c7ad0a"
    sha256 cellar: :any,                 arm64_monterey: "ba3d5f2db7e5695ea987b9de8e3f78a410201591b3af23ff58003b0bb77891b7"
    sha256 cellar: :any,                 arm64_big_sur:  "d874af3228f5b61a0d27b20d60bdd7bc395723b378f1b0b1b8b87c5dc418acf3"
    sha256 cellar: :any,                 ventura:        "06c9b860292af987fb9865f2abd413582bd1fc00cfc74f6b158f06b61f266470"
    sha256 cellar: :any,                 monterey:       "516b6cbc4e0edc5a96f1a007245e0cb97645ecb9f147932bb01d13d090a1ee9e"
    sha256 cellar: :any,                 big_sur:        "0b560ac72dcd81e7cdede7146f982a3b21828d6969139c56a339084afb857849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52bd18066598f8baf181ca10fb5eb589937206dddf8ebd713a996a5633e4bdc3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
