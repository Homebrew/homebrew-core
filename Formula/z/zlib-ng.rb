class ZlibNg < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.3.tar.gz"
  sha256 "f2fb245c35082fe9ea7a22b332730f63cf1d42f04d84fe48294207d033cba4dd"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a6407ff6ed8f11bdc38455def3dd19e0072ead6c4b7dd946a9c794369743952"
    sha256 cellar: :any,                 arm64_sonoma:  "02f492874924adb106c91d846a90b3960c5b4b9c15320773ebea7cf492f01743"
    sha256 cellar: :any,                 arm64_ventura: "f7da1ac1536239ff9e75637e41443f7f151dd5874d45f387ec37c6551ab0b370"
    sha256 cellar: :any,                 sonoma:        "3af29abb3a9911cf6572bfc8dd6cd4e23c7bc6b7b5777bb1be87db15bf270e82"
    sha256 cellar: :any,                 ventura:       "83d66831f2775ee792e9398e2ed6dae9c4d0c46d8c1e29c3b2955fcf434f218b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0527249cbdc21f2521169d09bb968a41a4bed937deac3b3ef6e9b09108110f59"
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
