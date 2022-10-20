class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1776",
      revision: "bcdba525bdcda370085f76ad0f48f5388c6ddef4"
  version "r1776"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35280e6c396dfe15a627a6a5af8080fc23d9f5f5603cdd2e348003d96c93b2ee"
    sha256 cellar: :any,                 arm64_big_sur:  "a0d2a305b0863e5e1a437781042fb5d1b86c25ab1e5bfbbfeb59f2888faf7787"
    sha256 cellar: :any,                 monterey:       "495cc3df390e60ce6794c3249672fac28d89e623c730df4250e656975153d2d2"
    sha256 cellar: :any,                 big_sur:        "925c342e95ed3da0d73dcd5d20b5fe75da4f2ae02a1a146ce0714ac27471ace8"
    sha256 cellar: :any,                 catalina:       "9b65ffe21b4018aa5d81f3b9e1d5b7b793a1963e9550a466bb8b48442f21b3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f9db45bc8e531c8bea0e98c37558f796971dd52e81e8f4527c986173ad783e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
