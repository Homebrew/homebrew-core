class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.9.5.tar.gz"
  sha256 "adaaba54fe18cf5c5cff17573a26daae0ada64be03ec38568dc5c9d189e61bbf"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f28a4df0515889cf222d2a717ba8ed0bad0a5c7a2544860ca5746d7bcc3de9d"
    sha256 cellar: :any,                 arm64_monterey: "ee41505ea11ce9e2f57256d76984d503f849a5534524754fb98a012ebed747fe"
    sha256 cellar: :any,                 arm64_big_sur:  "829d94dbb7d129f1a54467a9980d24548f5a36d86c4241930f20ba57fea92038"
    sha256 cellar: :any,                 ventura:        "2dffd4117dc257b75ae928dda86552975f6c0deeec4989e1edc2294f70865e63"
    sha256 cellar: :any,                 monterey:       "b30d330d9ca2a63f2ebd0b10c86393f6939b465c9f5c0ba821e15813e2471533"
    sha256 cellar: :any,                 big_sur:        "88e5d928bfebfaeeb251650a5662b78b96274919919856639515dc2e74faf257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195488d563883cbeaea74f4bb7a672b783a63f8682a723722fc1effcb0ea991b"
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
