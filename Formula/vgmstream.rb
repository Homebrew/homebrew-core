class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1745",
      revision: "72eb0e6b6fe2863be24650414a34ad504f56f2f8"
  version "r1745"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f57ddf0e086737b2ca84e5f07940a2cc5e70abe8e1e0d53e757211165a8f8598"
    sha256 cellar: :any,                 arm64_big_sur:  "e6a1df2a246d2cd9bfba5fad07bbe16375c8bf532e4d02c1d4aa44afc4fd6d45"
    sha256 cellar: :any,                 monterey:       "ca9659ab9397511f0ba33662d599152cbed0c6aa0f510b1de5ef30c6532b0442"
    sha256 cellar: :any,                 big_sur:        "cda923350cb2ad199ebcb69d4a8af3a0512b766f58b575bf97dfbbc346617b73"
    sha256 cellar: :any,                 catalina:       "f9646009f868b5a338740f2aab8e8f7deccb0c2bd6009998f4427ba0349639c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c08aeb195df59c70f044381afb8527686204eac958b21fb3a8761887bdd83466"
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
