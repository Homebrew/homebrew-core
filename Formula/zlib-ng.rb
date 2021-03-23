class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.2.tar.gz"
  sha256 "dd37886f22ca6890e403ea6c1d60f36eab1d08d2f232a35f5b02126621149d28"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0637bd04747c1e7e3724d4e5dd88c80623b1781bb59bfac53e7c154c4dbdb33a"
    sha256 cellar: :any, big_sur:       "ab60e9528909ce0f2ee5564510eb5e8a31c78a6129f3ad515ec2428ebcd4e896"
    sha256 cellar: :any, catalina:      "9c661fe9cd0ad02455ac8acb29215cc5e32c44e8ccdc30af59ddd268b761a3e5"
    sha256 cellar: :any, mojave:        "c8341f77f2c9c45ec5560ded89c258978935c6ce2040bb0390b12095ddc771cf"
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
