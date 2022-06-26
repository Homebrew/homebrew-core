class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.5.6.tar.gz"
  sha256 "2931fa4620c9360c28e0960c2023847baa127b72c326b77a5de0fbf5a4741db0"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "828f757a36e1c845ff33754ecd24adba8686d8dd17ba7aff0709eed3a45cb46f"
    sha256 cellar: :any,                 arm64_big_sur:  "bc40d2d4525298789f79723e78088a691dd639ac08f0d4b89bb4681402d30407"
    sha256 cellar: :any,                 monterey:       "fdcbab55c770d63925b3b2502d3e42d927e508b2d0a0d47f1b857f31b940cc6b"
    sha256 cellar: :any,                 big_sur:        "ee6d27b55537ab654b2ea4aaea1ead734403fc2f533ea19abfac5e213f03fcad"
    sha256 cellar: :any,                 catalina:       "8a1efd1d59ad55e5669473281ef34f6ffed2860d293dc0e57823893723dc360a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db4c23351fdfe8369d0bd695358bc2f003ac858bde07700b07ccabeef7cb69ae"
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
