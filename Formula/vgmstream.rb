class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1667",
      revision: "6b84f258e4238edd627e24ec8460a7040613d054"
  version "r1667"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "63fcd172e33b874c68b0fcab3a6109d573d0f737642f8f5cdeeafd45105467df"
    sha256 cellar: :any,                 arm64_big_sur:  "334824f6ab927e82b2aabc815abf06596107e835e4fc7452cebed773cb9d17df"
    sha256 cellar: :any,                 monterey:       "1f95eba46f07f4777ead25bce5bb2dae4e3a40911e154406e8b6f96c2382f943"
    sha256 cellar: :any,                 big_sur:        "281369bd894a70133b48f0ec6446a9104e17d27bbb4c516ecdd1255ab0a549ad"
    sha256 cellar: :any,                 catalina:       "da5772992533010c9fee28177f9edeeacf9f07091335ed4daaa4c17cc0b2db5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f8de79597d4d06620e582e7bc8208575eb49de9fec0aa86cb8ae67896706885"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "cmake", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args, "."
    system "cmake", "--build", ".", "--config", "Release", "--target", "vgmstream_cli", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
