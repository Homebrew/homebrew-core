class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.6.tar.gz"
  sha256 "8258b75a72303b661a238047cb348203d88d9dddf85d480ed885f375916fcab6"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ad26fa280a898e242d0e6eb458feca8df57dad93bf7cf7330268a830731cc32"
    sha256 cellar: :any,                 arm64_monterey: "27e2439642448477e9e0100c025242af1c136c8314d6f8cae85ba5ad1101cd0d"
    sha256 cellar: :any,                 arm64_big_sur:  "68c5eb10ccca6d24f04b9d1544c00bfadfddc2e668b1ebfc1b884f73a0ba2056"
    sha256 cellar: :any,                 ventura:        "eb172adb8d246fb99cb05629718235ac4785a70a5bdb253efa20a302f6280c94"
    sha256 cellar: :any,                 monterey:       "f9d1492435a2216b3b9009f3850821a5cad24598d7fe324154b3ff4351d2d4a9"
    sha256 cellar: :any,                 big_sur:        "c144f0a15009955bc6c00ff887f52263166e69fd76faf4f68521460839f3c086"
    sha256 cellar: :any,                 catalina:       "e73656cc12181b5c35df40e579420d7f93eec7c8536bf044f3ddae9703e10b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee344d5250258b2e2f9cdaebbdba9b6f6f01ae881ad5aa976d2fc9a629af5548"
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
