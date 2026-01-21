class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.2.tar.gz"
  sha256 "6a0561b50b8f5f6434a6a9e667a67026f2b2064a1ffa959c6b2dae320161c2a8"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eda237ebfd034c7529c24b4de24e796d4b9d949eba2fb8eca20aa17507c28269"
    sha256 cellar: :any,                 arm64_sequoia: "46cbd9f86d8450a612ab4c72b7695011cd94dafadf762f09640ab2ddc0b4ceb0"
    sha256 cellar: :any,                 arm64_sonoma:  "3cf5eb2ff042b02d37c46c23c816dd1c888e48ea457658aef4cbfff04f3b7e5d"
    sha256 cellar: :any,                 sonoma:        "5adf8f11e1b810cd11336fba239ae24b95f5d9e1924df268282226d1bc640661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2517bb59eeac0cc8653758f229b68c584ea743777c5109baa9d59aca8a312ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6b881b00a10f68d4f0f735854135bd1a6b961f6f5f9e81079eb21cdf83df4d1"
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
