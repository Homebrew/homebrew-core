class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.8.4.tar.gz"
  sha256 "f68bf5ef0b6b87eb9eab6ce84987f42103d987d5ae93c866d0002f724778c124"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7e2ce4c5e9ece7e6958613136009793726f7fe6c2a30dbaa0f74c14ea599360"
    sha256 cellar: :any,                 arm64_monterey: "3c0bb15c39a9f8199c843f8e4e37bb4416b8e56cc89b8a8c5be7fec507be1f66"
    sha256 cellar: :any,                 arm64_big_sur:  "ec01930fe40426f597c2260e9a1b2f8731706c16a4d6d9c7d612293b9147324f"
    sha256 cellar: :any,                 ventura:        "ea827ebf2e8171cc3d72fa9d56cdb6a4e34d5c399ddab53ce9cbcfed6eb7c2cb"
    sha256 cellar: :any,                 monterey:       "f07854b3e0b19ecd7102fa696f4b163a4a0ea2ca562bb5f7a08b30ef9056efa9"
    sha256 cellar: :any,                 big_sur:        "47bac2bbfa17a4d8af21745fc4750056b456b9cacbc7da8c33815fe6564bd7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dafd53aebdda632c7228f8e44fb7cad0bf8d5519264fa487af1821040217f2f9"
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
