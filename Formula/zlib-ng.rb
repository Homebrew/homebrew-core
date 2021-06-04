class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.3.tar.gz"
  sha256 "30305bd1551e3454bddf574f9863caf7137dde0fdbd4dcd7094eacfbb23955a0"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6da07fcefc7d5e5bc8c0e263ef190f40f0dfe4b175bca12905a1dbdf6cc3de4c"
    sha256 cellar: :any, big_sur:       "a31ce3ccf4d859b63e23df088d565432d2d3e3c97d8962203960dcc295bab81a"
    sha256 cellar: :any, catalina:      "462f4462fe656f825bb890e2fd1502d285e18ad90eb9749c6587f67f4d3188e8"
    sha256 cellar: :any, mojave:        "33132308de914dbd6e10cb5c342667ea6dd270914d600a3c1b0c9e2a015975cb"
  end

  # https://zlib.net/zlib_how.html
  resource "test_artifact" do
    url "https://zlib.net/zpipe.c"
    sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test uses an example of code for zlib and overwrites its API with zlib-ng API
    testpath.install resource("test_artifact")
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~EOS
      #include \"zlib-ng.h\"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    EOS

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!\n"
    (testpath/"foo.txt").write content

    system "./zpipe < foo.txt > foo.txt.z"
    assert_predicate testpath/"foo.txt.z", :exist?
    assert_equal content, shell_output("./zpipe -d < foo.txt.z")
  end
end
