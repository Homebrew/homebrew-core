class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.9.3.tar.gz"
  sha256 "e3164c4d3b87f913f1ab04b19bd2044bec0622b416cb754906ce83901b5d9e81"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "679307382587ac2ce5bfd38f2eb81d662bd033c5b5ea34f9f4d3a0f22811f341"
    sha256 cellar: :any,                 arm64_monterey: "abfd4d5d8b62c09b78fda4438e81e41b3e86546fb5cca016302e92da2143e5cc"
    sha256 cellar: :any,                 arm64_big_sur:  "57d3368c124b027ebb9b0584b312bd6e2e0ae1a505e3b6f35fbfbf4f5a685cb9"
    sha256 cellar: :any,                 ventura:        "95c8907d19978629643870485e8a76c2fc48c05bb29d2679e37b6517d65d549a"
    sha256 cellar: :any,                 monterey:       "b1f9e07cb3553f6eb79266b38b7fa84f2aec9f1e2c5eeb11fb19d72c32dd5a09"
    sha256 cellar: :any,                 big_sur:        "355c5ff29aaf37ae03c5a0f69963caf48250ae3ad2b5bd0679dc9d656d4f3668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecbd010492b6c4c1f9b44a4774b925d925cf3e0ef58334d1dedc5437e3ae18ae"
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
