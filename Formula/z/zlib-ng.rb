class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.2.tar.gz"
  sha256 "fcb41dd59a3f17002aeb1bb21f04696c9b721404890bb945c5ab39d2cb69654c"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc1a40efd791c95a4f89cf7130143af0f55cb60293bcba7e898274ce1d6072f8"
    sha256 cellar: :any,                 arm64_sonoma:  "ab11bbbef94c89230de768f2ce3ee4ff0fc1c0b6a6e6bd502a9ed63987c1f07f"
    sha256 cellar: :any,                 arm64_ventura: "ed5838db3f194af31af706bdb83479f9ab58e97d591255da69a243f54e0d63bf"
    sha256 cellar: :any,                 sonoma:        "490cc436f9bd223ba9bfe652dde27f8b57e49c3062c91fd4455be1b249e21631"
    sha256 cellar: :any,                 ventura:       "3186ce97b2be07dd0a4dfd2f4dafbcd7c0cae2da506ff67c363394426b783471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cbfac94e97c9cc5a8518002b3e2baa090cf034a38023aefc292fdb479e3f608"
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
