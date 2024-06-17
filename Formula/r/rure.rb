class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/refs/tags/1.10.5.tar.gz"
  sha256 "e5b4b6b539a9697cd0c0ca7895cf62a3ba6e2aea41b607b7d949eb62f812f101"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09d9802ae1016fa79f855249122f5defdce0b8db7547d56fcd3d697b0f80fefc"
    sha256 cellar: :any,                 arm64_ventura:  "9976d4603b6d2952adfbecfa493005aa2acf36e68dc990d99e4d5a747dfb74e3"
    sha256 cellar: :any,                 arm64_monterey: "f3958551697b8473ebe20146ca57870329d222b6965eecfcb8947cb17d89ac60"
    sha256 cellar: :any,                 sonoma:         "f0221980d1057bb43f042783afd5f5ba491e30031dee37eec2588d7fed8c0bcd"
    sha256 cellar: :any,                 ventura:        "923cc7caab7c79b432ea153d11b7dcbb0b7584ecd63ad79d6615e7b38058225c"
    sha256 cellar: :any,                 monterey:       "1de1435a83f9a90ec8dda5e2277a3dea4e22a9f095f1464da64a0f929d9d64b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c9e49f31fc281d641049877055646f5f6ea4fc1713ce91abfe5c10ed7e06884"
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
