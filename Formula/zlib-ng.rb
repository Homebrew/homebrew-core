class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.2.tar.gz"
  sha256 "dd37886f22ca6890e403ea6c1d60f36eab1d08d2f232a35f5b02126621149d28"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ea7326966520b19598a7140a54e86dbbca928709c965fa9743dbbe5b1cd83b0c"
    sha256 cellar: :any, big_sur:       "9b71cea1b762ba5fee001ecb839f87df698fec276b2dbec5874670cd933631f8"
    sha256 cellar: :any, catalina:      "8922f3e8564191211ea6533456d415fe5aee007a8242f91988eda666e63bff1b"
    sha256 cellar: :any, mojave:        "835a757a2ebc46fc9958910737903ecc50f04e9f12541b239076c9e017fbf122"
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
