class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.1.tar.gz"
  sha256 "94cfa0a53a8265c813c8369d3963bf09ac6a357824ad1f93aee13486176e152e"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8f8ee5a61e66480cc383ae43cdf4db3a2f94e800854e9d0375c81dbc835b93e"
    sha256 cellar: :any,                 arm64_sequoia: "7444266862075d1b665b2f468e025bb272d818721ed1ac34c0ce188ce66ea40c"
    sha256 cellar: :any,                 arm64_sonoma:  "4169895a8269c28b7e6b075fbaf15dab3ccd128011640a4e973f615a6b38a9eb"
    sha256 cellar: :any,                 sonoma:        "5b3726d1a82db8b6b4790b9b96a41b64c10726f64b70cb30c12c4e815ae8839c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d9c9a5ad6622b96084650bb93f2f3634a2604e32f1e6ca53f611448d84c405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6212d46a60461488b19eb0a73a6b643f80c892cfaa9a23752e34d61fb08e045"
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
