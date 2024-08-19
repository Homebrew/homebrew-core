class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.1.tar.gz"
  sha256 "ec6a76169d4214e2e8b737e0850ba4acb806c69eeace6240ed4481b9f5c57cdf"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aac6f687053010769a39a7491a8287952e929fcbbd60055965eb46267e97a763"
    sha256 cellar: :any,                 arm64_ventura:  "aab4b10b3025404add211b6ac62ae8e95cc012990fb5fb55657f1d3f6c96e94a"
    sha256 cellar: :any,                 arm64_monterey: "b6bef36dbacd12ce1cff6f90b73c840a611a1e2775d63bedf2cc868150fa83c8"
    sha256 cellar: :any,                 sonoma:         "74d2c4916bec00e12b191f1de40374f7cf210f7a361262ccdf6bf9686f9711e6"
    sha256 cellar: :any,                 ventura:        "7482bc8b9d332b87ac9e650a3aa3e808bc94d11950889feda4ceadfbff599e90"
    sha256 cellar: :any,                 monterey:       "0f9fe4f274ebf4b5497fc1d087f36ac95a5dd20c34c88c962e35da0de9815a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68bc93a042b9803ada6217132bb7e802cffbb82f0a68c531b6ab2f974118584e"
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
