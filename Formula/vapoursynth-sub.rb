class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R3.tar.gz"
  sha256 "d0a1cf9bdbab5294eaa2e8859a20cfe162103df691604d87971a6eb541bebd83"
  license "MIT"
  revision 1
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eac11e8cab42e2dc20a55b4047847195f96d9d3754b1f07051a7573602a8e22d"
    sha256 cellar: :any,                 arm64_monterey: "bd049fa76cceba7b8f7106f561e2dfafbac4bc614ce2f84df20eb6d82c5835c4"
    sha256 cellar: :any,                 arm64_big_sur:  "eb1c664154707e72972d6485fa32b7b2122185364d3733d2e7f6a4a6ff3983c5"
    sha256 cellar: :any,                 ventura:        "0565ed71fbbd513f943174c1976f6a22b3d11d8c5619e8f03e38d2ed6a015249"
    sha256 cellar: :any,                 monterey:       "936cfa07b6d8856b0f0e06b32b6768d75da7614be2eed007fa53bff97be73450"
    sha256 cellar: :any,                 big_sur:        "6e94b0c7086d046c513b9ddf6c1ed1750f7c56b98c55867329fb06ff47c372c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191b136d2a97715a7a083d435682be7cd83673a3aeb073d2cf0f9605c9757e7b"
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
