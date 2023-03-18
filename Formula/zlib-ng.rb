class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.0.7.tar.gz"
  sha256 "6c0853bb27738b811f2b4d4af095323c3d5ce36ceed6b50e5f773204fb8f7200"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c4dcbe4634cfd7ae97fb37dc9f1101b534807d5adfc4d50ff7e43161c73cb362"
    sha256 cellar: :any,                 arm64_monterey: "1ca8c0b6134401565a0309533b98d6f9ed7ee5e01c49ac385c6d53d5b846c65b"
    sha256 cellar: :any,                 arm64_big_sur:  "e8692606eae0001b6b5a7854c5e24d35af55e088afc079021de9dad59a506a61"
    sha256 cellar: :any,                 ventura:        "d40acc4bc18b101e8815d39b4137106113e73a0aa2e6cbc05594794ee0a99e14"
    sha256 cellar: :any,                 monterey:       "abb78fe6c0974e0e62562c46b6630c0d579f19609e95a9eeb68a99b854eac531"
    sha256 cellar: :any,                 big_sur:        "59094b0129766c803c907163d3c54136429be62b8664a1506b7be7749495d0f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9db9a7af2f61d9c1bf8ea1dd39ed0ad515d8f44be9ddbff451a17643a3d2e68"
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

    content = "Hello, Homebrew!\n"
    (testpath/"foo.txt").write content

    system "./zpipe < foo.txt > foo.txt.z"
    assert_predicate testpath/"foo.txt.z", :exist?
    assert_equal content, shell_output("./zpipe -d < foo.txt.z")
  end
end
