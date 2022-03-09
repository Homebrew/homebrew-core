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
    sha256 cellar: :any,                 arm64_monterey: "78ce91dfd749f3f6f333155546289662b891b128146cbf8825b4a2f8df52b92d"
    sha256 cellar: :any,                 arm64_big_sur:  "6ba4ed3e1ed9f7861419485860652042cce35b2d86735fc0f683e3e0bc069f12"
    sha256 cellar: :any,                 monterey:       "8c25b6e5b82ff41468d769fbc4df112166590982c9570bddf5a48a146be313a1"
    sha256 cellar: :any,                 big_sur:        "99794c5a4bd2d1d88ffdc8d3895c529c55d7375ece0b32b17686e00e15d7703b"
    sha256 cellar: :any,                 catalina:       "f04aad7ad7d4749aa4cba973a62fc39eafd70cee664b17b67aa89848ce6ce0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "986af4f9ae078011f903075e6aaebdbd5fadf09bb178f50009fc8c3d38b1b827"
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
