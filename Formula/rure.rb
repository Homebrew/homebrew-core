class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.6.0.tar.gz"
  sha256 "1626e48f59865315419f56172d82906002cc6e54d26c785dfa6bc20b48ea09b1"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "96e03e60025e7a807c0310ca52b92dbb74f0754a2fa5c6a3574943a6ea43b159"
    sha256 cellar: :any,                 arm64_big_sur:  "217c7c2c97c04ab1af1621e270ea867f953e2c4644548b38463781277b329dbc"
    sha256 cellar: :any,                 monterey:       "33b0c8e9d7e0db6187901b0c106118cb421a1061b86e7b85cd9a6168bccb7d12"
    sha256 cellar: :any,                 big_sur:        "9553095ff8bdfcbd1b51859881c9d329d3f70d40b9f5bf71636c1f41bee6dbfa"
    sha256 cellar: :any,                 catalina:       "306d235a91ad6e2454b142a29d373bfc5709fcbb4531e9718ecfce6202beb025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "305261750d4870844c903e45983f7863eaa321e6aba6683b4f0b88fde59d8c51"
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
