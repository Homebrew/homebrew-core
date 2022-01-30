class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/master/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.5.4.tar.gz"
  version "0.2.1"
  sha256 "a91d5b3e1644a1b298ca4ac8e458d693ae268df7fd3307c6d5d12915b5bc3870"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install Pathname.glob("target/release/librure.*") - [Pathname.new("target/release/librure.d")]
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
