class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R4.tar.gz"
  sha256 "75b43db67062bf98e31c4e98138fe8d7fd328619216ad0444423efc3d6bc1398"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18df66402b5b0612d575766fefadc18f40d8fe7aed14ff7a6ec97c1a05e94bff"
    sha256 cellar: :any,                 arm64_monterey: "0be08d3ca56d404588d61badae14e9930f1abe0df0eae0c6b69ac6eff85d1db3"
    sha256 cellar: :any,                 arm64_big_sur:  "b01b9b7977bdbf1e5ff744e6f4bf91f0c5f659cbad4054bb72aabe1ab801e169"
    sha256 cellar: :any,                 ventura:        "ef507c8bd5dbbbeb8e330bcec90cf01f3a8a974baeb3aea0b8b68a834b15032a"
    sha256 cellar: :any,                 monterey:       "65a9159a7dd44be6977ee0fc089db43e182024e7fd4080daee108c39bd185b02"
    sha256 cellar: :any,                 big_sur:        "a943de850d54d3bec2297cad3aa6031bf80d9f002994af268741314122fb3a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eee1c9ffd626de825ad7b1cb66a1db3985c0b9faf7f87480c2ae67d73f8aa39"
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libsubtext")}"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.sub"
  end
end
