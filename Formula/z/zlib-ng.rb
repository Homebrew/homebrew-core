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
    sha256 cellar: :any,                 arm64_sonoma:   "68a0d88da9e3299b877d436dd4cf7aab9d2d5548adae8640d8b338f907b16355"
    sha256 cellar: :any,                 arm64_ventura:  "f5a61f55027c18a3f7b81b473b4e97aa36bdb7b7993a75120ce4eaa0c8269dd4"
    sha256 cellar: :any,                 arm64_monterey: "6b014d9746b5605c6407cd7e5f19c6a8740c8ac73ccf57eb913dcbfc31b2deec"
    sha256 cellar: :any,                 sonoma:         "6ed50a121de70d0c2a1d106c031fa75855df810cfaa356f1060c48c7db843998"
    sha256 cellar: :any,                 ventura:        "d5b2d8ed297a4bd134ff17b295e9861497865a9cee1d756400eb3ba57ad7eccb"
    sha256 cellar: :any,                 monterey:       "52ff5e709148ead370199df579de3b9e14b5c80f4c3fe71a1d57517f4679c9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5979dc197360dda1e6f3695aa7b5a773379b7d0bba2431151fe746f4977ab8"
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
