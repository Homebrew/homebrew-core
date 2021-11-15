class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.5.tar.gz"
  sha256 "eca3fe72aea7036c31d00ca120493923c4d5b99fe02e6d3322f7c88dbdcd0085"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7db02600535bac3c8d4425b572cc4edddfb8a80048b15d8445da72e6784dfa55"
    sha256 cellar: :any,                 arm64_big_sur:  "6774c82888cdb156bff87776b470decf161279e3b349a7ceecb2ff6540e47086"
    sha256 cellar: :any,                 monterey:       "83ac999adf4b2279e8ba5f19156bb3c13da5c4ba418472a0c458c570f5dc4e9c"
    sha256 cellar: :any,                 big_sur:        "16b590ffbf23919316ff04b0687493aa124d125fd417d97f2f1b9ef9bb020bf1"
    sha256 cellar: :any,                 catalina:       "1028a7aded6cdcaf9053500fc7ce0b07e9801429249bc13d859463941b4e83c7"
    sha256 cellar: :any,                 mojave:         "6716bf16e0c48b26a5452c040d205e1dda8c418648eb115a6ecabddd253ce4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b8ac18de50fd8b34f2d99dbcf93b1d58670b9c1a2789e8a94433c78c20909b"
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
