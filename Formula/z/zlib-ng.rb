class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.4.tar.gz"
  sha256 "a73343c3093e5cdc50d9377997c3815b878fd110bf6511c2c7759f2afb90f5a3"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "172d222f67bb93065376bb88e1d8beaa3ffd3eb9902f1884c552483b58a04a50"
    sha256 cellar: :any,                 arm64_sonoma:  "f2306b42db96fa4ccbcfca1fe91b17fc1a90fb238c6493b1a92fa3dbba8bd972"
    sha256 cellar: :any,                 arm64_ventura: "209912594fd67b36271207675293682db9dec087434b3a1bd0856cec80718eea"
    sha256 cellar: :any,                 sonoma:        "fe0c7f653c0643174b97538d312383681a16c73ba02c01d20067277988b0015b"
    sha256 cellar: :any,                 ventura:       "ca3d91daa5ab604935fea3632a76db372128ebeebd93939a95af3982e066c29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fce3abce4b3344c6d1c3d7385d64c0199b0b78a0e977972fcf7daea99d3405e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067fda36b99d5dac97f99524fc362b5980ec06022037f1945377709b43f3c1b8"
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
    inreplace "zpipe.c", "#include \"zlib.h\"", <<~C
      #include "zlib-ng.h"
      #define inflate     zng_inflate
      #define inflateInit zng_inflateInit
      #define inflateEnd  zng_inflateEnd
      #define deflate     zng_deflate
      #define deflateEnd  zng_deflateEnd
      #define deflateInit zng_deflateInit
      #define z_stream    zng_stream
    C

    system ENV.cc, "zpipe.c", "-I#{include}", "-L#{lib}", "-lz-ng", "-o", "zpipe"

    content = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", content)
    assert_equal content, pipe_output("./zpipe -d", compressed)
  end
end
