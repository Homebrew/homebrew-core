class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.11.2.tar.gz"
  sha256 "f66568092a7981a50a6c1f2da95574c8fdd2fe4a01c336eb6a19be43130107c8"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa32e1b7c930e97027058c888811a55178fe0ab6be86e57b16f72dca18e847f9"
    sha256 cellar: :any,                 arm64_sequoia: "0330e68fa328bfd6e04dc9b72c728f9e1bc8908a874160e6952df4532f4f62d9"
    sha256 cellar: :any,                 arm64_sonoma:  "d3057f9c8648c56abe1eb69a3764d0f0d0a6dba4c163a651e16d66731fd7f3cd"
    sha256 cellar: :any,                 arm64_ventura: "70ca1320bedeaf214ceac5f9df650931a2c09b79ca969ca6c6d1d4dc8a5902f0"
    sha256 cellar: :any,                 sonoma:        "5f4aeae141b8adca71e9f35c2c225e8226c592dd0b74506bf0ea1f3b6a372dc2"
    sha256 cellar: :any,                 ventura:       "0f0146b9ee76f401a92fd7ff452dbbbb6b580d34bdb5bb8a2836127ebe822e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78433b5531941eabcc6e9c8596d59f160343745cb7f3d95b76dde0e2d5d4ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7903c646a9ccd13c7b04d226685d5e5d4278e35690abb95e566752fe46c175"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--manifest-path", "regex-capi/Cargo.toml", "--release"
    include.install "regex-capi/include/rure.h"
    lib.install "target/release/#{shared_library("librure")}"
    lib.install "target/release/librure.a"
    prefix.install "regex-capi/README.md" => "README-capi.md"
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
