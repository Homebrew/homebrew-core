class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.1.6.tar.gz"
  sha256 "a5d504c0d52e2e2721e7e7d86988dec2e290d723ced2307145dedd06aeb6fef2"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bec24ea3f719139dbd06cc28874257b69bbb921ac9d7b405db416a0ac004ad7f"
    sha256 cellar: :any,                 arm64_ventura:  "d0a07260a51bd3d13e2a92c0d3f59153d349e805728ef7450cbf9769af770319"
    sha256 cellar: :any,                 arm64_monterey: "61b6f04ca4f1870d6dba8d8062fb2d2ac3710958b9c343ad287962a354eeb8aa"
    sha256 cellar: :any,                 sonoma:         "b13e667f51e3a68104985c5305d741bd6d989d548b6d944dd9f7d4a715c8c793"
    sha256 cellar: :any,                 ventura:        "e8fe49b1be8cbaaa27f201882776c5bdfa46a6dc20a8a99089a37fb779ed105a"
    sha256 cellar: :any,                 monterey:       "915d8b23591e4e7581930d3b36102b2396a168a39d8ccccbff17bbaf0478e43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57997eda0dd7a5e7e4003465002ff957009de1489f6ff72d9297e157aefb9f0"
  end

  # https://zlib.net/zlib_how.html
  resource "homebrew-test_artifact" do
    url "https://zlib.net/zpipe.c"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("homebrew-test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~EOS
      #include "zlib-ng.h"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    EOS

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", content)
    assert_equal content, pipe_output("./zpipe -d", compressed)
  end
end
