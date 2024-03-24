class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.10.4.tar.gz"
  sha256 "450a86f3f24ff053caeb9f0b7c295bd85887f1ed79eb333841c5f040835ded32"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6a7482ad98ab24eabb0c1def47d6f08bcdefae174f961c7748d548df0ee0c561"
    sha256 cellar: :any,                 arm64_ventura:  "b4c63bf704e815fa87582b3df08cc86ed9e1a66e9b4646a36a28910fb751ffc0"
    sha256 cellar: :any,                 arm64_monterey: "f1c50c873603ee77fc592fce7c1bf6e19250228b91719d732e4d33aafe360994"
    sha256 cellar: :any,                 sonoma:         "b744daa38b3c95459a87b9939a0166bf69ab863b9f2486e23ca6241786e5be12"
    sha256 cellar: :any,                 ventura:        "3a6863f9befc40721d7702d9103d008bbad97d3d390fcf7fff0eb4a56fdc29a1"
    sha256 cellar: :any,                 monterey:       "444b3dd2b0d6a73b587f4fb148168883df751e6c55f29156c0fdd4ee7beb60d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20064814932d9706cf4c760fb02ebb1ea9220dc07c0aae915bcf69072e6c2ad6"
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
