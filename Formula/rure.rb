class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.9.2.tar.gz"
  sha256 "df6765f027d6b602ced9f6847c97bcb53600661b9bb5eb5216db6b556d1d248a"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77ea14d3c6782638e481591b08d974658111276c9a1bb7ed1ec05885e32605d2"
    sha256 cellar: :any,                 arm64_monterey: "ee2cbef6a42b175b6cf543f5f15697185ace635a3ef76490795add9784fe6a83"
    sha256 cellar: :any,                 arm64_big_sur:  "e926c8b29b3a7e4d77eb0eb902a63335759f205062e01aef0bf06d370c07d74d"
    sha256 cellar: :any,                 ventura:        "1971a3ec6dd0cb2a20e2c0f07da388aa483eb990d31fcfaae0cebaa5eb735f4a"
    sha256 cellar: :any,                 monterey:       "37e8b19e886d7712950492fa58f7e10daae33ac0e593803d24f9321e31b309c4"
    sha256 cellar: :any,                 big_sur:        "6e6941d1ac5538a13bdcd067bba998693e735f90048370a4bbd6c4cfade99348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "629e7550fa48509e1eaae856c6870526f290895178f0f9df45ef7fba241818e6"
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
