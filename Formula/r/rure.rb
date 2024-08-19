class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.10.6.tar.gz"
  sha256 "9ca2905c45aa024a979dc97c8140b97af2be143e2dd47fc2d990af5ac2befb31"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bee88478824dab1e04220f232c6985edc0b104da0988bab132b9c4865a1dfcaf"
    sha256 cellar: :any,                 arm64_ventura:  "daafe186cb2a0343ba58e00c800b4388066dfc94f94a0396ee8fc7e296f12e35"
    sha256 cellar: :any,                 arm64_monterey: "63fe7ad2bcb9b05aae352c022b39274551f08c73d299484e3f4889e55f33723e"
    sha256 cellar: :any,                 sonoma:         "6f289f0bb5e5914337c82208a7a77998a7544b7bd0b9ffa08eba86517b16b018"
    sha256 cellar: :any,                 ventura:        "58450166903f27cb8469b302d9601869f271f3721480308f5738bc37d239992c"
    sha256 cellar: :any,                 monterey:       "5814cac480d689026b2e2ecba9e270b1808f524347ff52be82727eea15b1a312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca0f991890a446418faee08463144b3e3e0724a6e336d51d25c274246535980"
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
