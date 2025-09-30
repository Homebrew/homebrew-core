class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.5.tar.gz"
  sha256 "5b3b022489f3ced82384f06db1e13ba148cbce38c7941e424d6cb414416acd18"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "707d202777a8492d9743d2c7e382bf62449c7e4ca8ae998d395a1d261c37975d"
    sha256 cellar: :any,                 arm64_sequoia: "543ae48a252d60483bde45bdc98212d746453a2281af43dda8e86b092bc90a21"
    sha256 cellar: :any,                 arm64_sonoma:  "9b4dadbd1478ed59de80242758e4593fe3203e9e97463902b1dfb1481046f51e"
    sha256 cellar: :any,                 sonoma:        "5124c7b8b06709281d92c4e44840e7f9d3e31f32943447f71218fec0e5c6f719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87cb7f8f09e1ebf2030e7739aa89174b518a945f467d81ea68d0a5d22ed25b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876d5f20cbe79e39872673ef215e41c6a7fe21da7600d49dde5052ef3b2a7a7f"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "homebrew-test_artifact" do
      url "https://zlib.net/zpipe.c"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

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
