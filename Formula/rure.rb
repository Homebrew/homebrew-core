class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.5.5.tar.gz"
  sha256 "52908e95272d0aa7353e8472defd059364a88729c1c85e41b0ec4b8a4d099f60"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "804ac120c4c780e0490f25bf5e91faa188685895782dc3d01816e9d92e605cb0"
    sha256 cellar: :any,                 arm64_big_sur:  "14fd800eb2efd70f9cb052008af157be74ac566582717c134f3bc6660b2cfaa5"
    sha256 cellar: :any,                 monterey:       "63e8e249626405e4d8313c93b9bfca35df4dbd258a901779d6bc00b28e9923f6"
    sha256 cellar: :any,                 big_sur:        "4006f50beb8cad8f91615b018501307d16150f9a358753f636a7fce9ee08ac2c"
    sha256 cellar: :any,                 catalina:       "e9a73c7130b3d67d1bee43880daeb1f95b7efd561722b33149e2fd1a232fea0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a69d3947c7eac0f9d6c462e429010255eeb9a8eee1b9b2054e6317c6e684c1e7"
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
