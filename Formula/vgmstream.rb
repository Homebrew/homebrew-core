class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1810",
      revision: "8b0204f3fce845df91adc68e43669f9b660d7c63"
  version "r1810"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9c33d45ccb9c4d5929f6f546910bac2cde9e91f5863c52796dcbc469774cfdee"
    sha256 cellar: :any,                 arm64_monterey: "c084986ba0059c842b2c86aa31d7d350fed5aa34727b40ce85c1ddd15703e9e1"
    sha256 cellar: :any,                 arm64_big_sur:  "5f38f449d113fcec67928267c6cb1d43ac16219870a79dc050316e803d2154f4"
    sha256 cellar: :any,                 ventura:        "6cd768a16e82be6e9d884d9dfcd83a1a2ecd0c5c6f1a4be9e2da45e0886ee87a"
    sha256 cellar: :any,                 monterey:       "3d662fcc0a3eff7a71550839a73f27b90f82a78a1b73cbbec11ef677f2f512cf"
    sha256 cellar: :any,                 big_sur:        "8e842266ae020d3f4379310f7ec6f2847b0d449c3166387a8655218280a8a5a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fdc19f1fdfe926dd933fb9cc79ba61e58d8b6f299107ed399a98630ab9c0f48"
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
