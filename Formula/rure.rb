class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.7.3.tar.gz"
  sha256 "880a1cc8a79382943abc28337543d52610afd3364948eb08482e2cf47ea68cd7"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95239452ef3b60d519e0e09215530d7df9ef3fb5756883eed0498b66d2fbbc19"
    sha256 cellar: :any,                 arm64_monterey: "b5218e61a8ff422236351c17da0d6b34f59852c6716e77fe858f70714109f7c3"
    sha256 cellar: :any,                 arm64_big_sur:  "84c38cae28a93fc9d0ee55c963fbdf6945b3305a9cf211d547d16144632a43b0"
    sha256 cellar: :any,                 ventura:        "f266fdfac93e08627a6c9cc9997a9a7e5220960e0ca23200ab6ef3c1f6b99e79"
    sha256 cellar: :any,                 monterey:       "5be9fab780c40b105869f972a03deb82a14bcb8d2fb78e8187b0a099b4c9d8c0"
    sha256 cellar: :any,                 big_sur:        "e35e1a8ca01db4233e18667f8a15ba491a6ecd95ebf728e260931f2c25e1811a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f386c8ee642aa1efc1cdbf56c42fd5345efd1a4f74b4e9f8776beb02265f70"
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
