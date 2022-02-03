class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1667",
      revision: "6b84f258e4238edd627e24ec8460a7040613d054"
  version "r1667"
  license "ISC"
  revision 1
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "657854dafa6263213d881e2686e838eee4ee1556d5da97706b15db67e1b16bfc"
    sha256 cellar: :any,                 arm64_big_sur:  "1da9bdf68de35520d505dbc59153df161db4e967e2e610a0d5214ee9bfec30f9"
    sha256 cellar: :any,                 monterey:       "f0c52e047a2de316fb3bd9ed331339bcbe826b4e5884dccfc563ac53ad75fae3"
    sha256 cellar: :any,                 big_sur:        "8645bf02e96c0a5e4bc52a51b355af86d7362f60413ed388f14a80ac6c6082fc"
    sha256 cellar: :any,                 catalina:       "d96550fc66015250ef8a2fe7a3864c7e688a0b912a66fc306d0997edbfecd5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb21895ea0256c867a24bc300cc5bc254c2e769e4e74a4cb2766ae9f5662fe57"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
