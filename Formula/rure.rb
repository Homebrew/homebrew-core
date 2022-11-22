class Rure < Formula
  desc "C API for RUst's REgex engine"
  homepage "https://github.com/rust-lang/regex/tree/HEAD/regex-capi"
  url "https://github.com/rust-lang/regex/archive/1.7.0.tar.gz"
  sha256 "9eb315d2874029e55397f5c4ff610215bc65d589679d72979378a94bcbc47586"
  license all_of: [
    "Unicode-TOU",
    any_of: ["Apache-2.0", "MIT"],
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ea5399a08624214fa3ae997f76b4c67230f9eaffcd00d6819bac7740b15a93d"
    sha256 cellar: :any,                 arm64_monterey: "e1f1933ea249fc5ee80a196c487e3845245569d71296ba0f410836fa72f2df9c"
    sha256 cellar: :any,                 arm64_big_sur:  "36aa508ccd0e7547847426e3fc81ba665ca68830552656a539a22c7c4d57da47"
    sha256 cellar: :any,                 ventura:        "92ca1e7544da8738011f9d4a1d795e6681c321268b3205b66d68a8e671fd45ec"
    sha256 cellar: :any,                 monterey:       "ec325f3c444065c4417b581bc0cf9526d58fe821c73668d37da280e02a99195c"
    sha256 cellar: :any,                 big_sur:        "804c90171510e98f72f2b4f3ac871f60ce3beaaa8a8d6ec0d7fb65c43a53daa9"
    sha256 cellar: :any,                 catalina:       "a77cf8820bd860ccd0a2c2956a27d12d8ec3ce902ee8e0c60cc64c5f00db55fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02094429cdc14bb30129260c30ba4d52e6323019fb8d169c2de3887bdfd5c338"
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
