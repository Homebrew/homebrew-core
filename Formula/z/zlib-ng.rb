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
    sha256 cellar: :any,                 arm64_tahoe:   "c0618be9f364de98d86317dd4d2c13a420e4071043a0a7870c4338caf4c6b85f"
    sha256 cellar: :any,                 arm64_sequoia: "b9d4833018667eceb9c16a3e2d94c02f9da89ad418c131e6449f68d6c9a3b0b6"
    sha256 cellar: :any,                 arm64_sonoma:  "7836ba4de58a38aebc6e2a4b622c4cb414035b7d6d7656ca88f3d487f1836cbd"
    sha256 cellar: :any,                 arm64_ventura: "cd4bc03c96c10c9916ce8af977f1ce76a5ee84bcac6bb4e2df9efeec6040020d"
    sha256 cellar: :any,                 sonoma:        "815ee670c61db45c5c5bf409e63855cedb46ca1263ac25f3208834381ccfa3f5"
    sha256 cellar: :any,                 ventura:       "7424413d91a8820c6f12fe0abc69c7e50c7cf2543b7ea42af0d9cb0c40eed8d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac407dd2e07a48f869d007a729add61fed50c56c63e8ca1ef48a597c4f8c4564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5149e77944f616115e8a9b7653925c4665397e0024d0c3ec3b9e3158d772847"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
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
