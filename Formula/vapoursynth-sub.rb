class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R2.tar.gz"
  sha256 "509fd9b00f44fd3db5ad0de4bfac6ccff3e458882281d479a11c10ac7dfc37e4"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "28810861f7eea8d5c0b1225edcd8547ce264d11add68186d470b6b46ef5a39f0"
    sha256 cellar: :any,                 arm64_big_sur:  "77ff99cf76d94fa5cbcc961e58a739c1af1fce4cd3587a8b7bb34561e7179473"
    sha256 cellar: :any,                 monterey:       "40238f510f53a8e03d0e75a7a00a4c7d1d9f18361d1fe4bc06a84116609495b8"
    sha256 cellar: :any,                 big_sur:        "9970926b50e25df64e9c8a13e3c575d823cbf5ff93b4244257941af17932bd9b"
    sha256 cellar: :any,                 catalina:       "dd5762ff060f077b961b229cf4daecb93f5b3130fdcd23d6b0fed8cfbdd49e09"
    sha256 cellar: :any,                 mojave:         "146a023ced7c207b5b1a054abc25b7587b1e3e6513034e97bf4c57fb7bbbaa22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd479be090c286ebbe0c2e7af858d597d6581b52178748c9b629ed608b771c3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

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
