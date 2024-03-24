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
    sha256 cellar: :any,                 arm64_sonoma:   "3d45b5a844b45b1efb05f39bb960bab79a9e3d8118532aee46e3fc24918734da"
    sha256 cellar: :any,                 arm64_ventura:  "d480036878b521c5db5813b6fd32dae29d8065812ca45ee4b316e06cb1d36604"
    sha256 cellar: :any,                 arm64_monterey: "7e352160cc8e38efe0f1ac95626f3010d5fec32dbd0c7adb22869c8cb7e88313"
    sha256 cellar: :any,                 sonoma:         "1a8ee8f8a65213f23b050828a77d0702ca37c12c16974c18d5ad790fa00ea34c"
    sha256 cellar: :any,                 ventura:        "4436398e50b2c13e5bf77965557bea081b6d9655e7cdd65c8612b1b5ad07c22f"
    sha256 cellar: :any,                 monterey:       "be91ecdfa158b4b61b5d333c6367dd4a4ca16dadbc4a7ba0280cb2822232369f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e5397554dd9a8f9115aca15eb0b63bca0ee0d50f71080f7619589e320d9c302"
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
