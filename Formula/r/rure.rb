class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://static.crates.io/crates/rure/rure-0.2.4.crate"
  sha256 "e76c0d9cbe885d29bf9a65974d9230e4d67c066ccfa07ab791926e73a181bcfc"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bbccbb0da7678208955a3dd006c5bf25efd87d129a722d4802b77da7c59c7cb"
    sha256 cellar: :any,                 arm64_sequoia: "514dcfe048fe80c4e61b7f484b953047a6c53c8f086bf15f77d508b77dc44900"
    sha256 cellar: :any,                 arm64_sonoma:  "d621df2afaad9172d36278dd75734ffb613fa438932fe437e863528eb04c2651"
    sha256 cellar: :any,                 sonoma:        "498127073bc6ef31463cabcca924cb45fb0f2374b48c59eb1440cd2d3efc3c18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e630eb9736bec9f81a47d1b3f02d1058ede85f5934a1bace4057ae8c30074ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4186d8a985246308ff68d373504be7c12e6ddcdb6250742e674a832bf40df6ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release"
    include.install "include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rure.h>
      int main(int argc, char **argv) {
        rure *re = rure_compile_must("a");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lrure", "-o", "test"
    system "./test"
  end
end
