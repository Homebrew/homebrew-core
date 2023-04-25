class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.8.1.tar.gz"
  sha256 "3716433b765c58973979a8fac87a8703a54f39a694558cd52b33946b39ee513d"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2b0fd9c52866524563bb2bdc82e625230bee77cfa8a4c597e0724c2e2b0f04e"
    sha256 cellar: :any,                 arm64_monterey: "f5b4cf1d51d017565276b4c4354072303f4303c9fac4af580585aec752a7bc43"
    sha256 cellar: :any,                 arm64_big_sur:  "fa23a40c352ffcafdeaac004db8079e1ecfb15bd37fe9113843d03ad5a20cfd7"
    sha256 cellar: :any,                 ventura:        "6b954d0aa45776b62421e4e88c77859111effb7e42bbb44630b2d982e1245e0c"
    sha256 cellar: :any,                 monterey:       "ec4a7ffb481edd313713ccc11ad3cdcd3b3b96b93dcecf1a4183743e932a45d9"
    sha256 cellar: :any,                 big_sur:        "99dcdfe25b5d8fa75f305070d33a4148eba813e6521c304c2de07c0fc3f7636d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce1bd12551fd355628f1d96aa45ad75aef98f4626c2ef148d587bdba577a02c"
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
