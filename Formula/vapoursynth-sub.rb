class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R3.tar.gz"
  sha256 "d0a1cf9bdbab5294eaa2e8859a20cfe162103df691604d87971a6eb541bebd83"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1d566a35094458188b0ef7503f4313d564b3d39d14698ba3d6ad33e812395934"
    sha256 cellar: :any,                 arm64_big_sur:  "5be9a2f65b43236d03eebbc934971f1146cb5d442a9ef925b07c4087112a7d92"
    sha256 cellar: :any,                 monterey:       "1343035d03a7207ed4fb65dcffcc1a53e742b855709993acc71b6f1b1eb3c6a0"
    sha256 cellar: :any,                 big_sur:        "5ec53b9369f41673d1787985213f4984d4c6ff29b9f311882834193b4e80af69"
    sha256 cellar: :any,                 catalina:       "d54510ddb431b6a0f959e402d5c3b02476e34b4d14a4a03ac94a40187c3f260b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b19e13e669af79fef8f897b445e4d72da584e739974bc5d7f759aa2bf8e8e97"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # A meson-based install method has been added but is not present
    # in this release. Switch to it in the next release to avoid
    # manually installing the shared library.
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libsubtext")}"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.sub"
  end
end
