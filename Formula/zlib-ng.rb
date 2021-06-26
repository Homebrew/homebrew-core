class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.5.tar.gz"
  sha256 "eca3fe72aea7036c31d00ca120493923c4d5b99fe02e6d3322f7c88dbdcd0085"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4e92251a14daf9987f938066d7d0b8a2821a969048c0de9d924318501e29ae28"
    sha256 cellar: :any, big_sur:       "c37be5088955a060b78ea842307e0f7cc2a73f5d59e4827bdaf4b97dd06498bb"
    sha256 cellar: :any, catalina:      "8fdc719ddc0b97f9c66b45842fb6dfb96ae3e27101288066c1793df182845ecf"
    sha256 cellar: :any, mojave:        "676bd181106053efa6e620527910c7630cd6af5eac220101507c2e3e204029e9"
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
