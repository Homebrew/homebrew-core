class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/2.1.3.tar.gz"
  sha256 "d20e55f89d71991c59f1c5ad1ef944815e5850526c0d9cd8e504eaed5b24491a"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1691dcb7645027203f4b7672b052d8e98643aaefe88f8db7aa0eb5f754f93fac"
    sha256 cellar: :any,                 arm64_monterey: "3afe91b0f21d26f6e3c6fbfbd103c2f57d12aa4991524c08a2c1a4f5f9881808"
    sha256 cellar: :any,                 arm64_big_sur:  "2f7c641b699727baaaf4b3e08c09cc9efee625b496336906ff838f4fcd34dab6"
    sha256 cellar: :any,                 ventura:        "54996b18079af43be761755d9da2573846b96d191b812f04dcfa76ebebd2b99f"
    sha256 cellar: :any,                 monterey:       "2904452a7eac011cddd53b53bba8ff30047ff3f025e9317a3a3c653bc868d754"
    sha256 cellar: :any,                 big_sur:        "5ff6114f11e3c7a8a11e8f74c4422c400d7818719318d6ada4b3d349153b7488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "310d3e2b84bd80be2db4a8c339442a1d92e474bdf1e59baec2865ba01719aa32"
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
