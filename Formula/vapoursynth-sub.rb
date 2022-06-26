class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R3.tar.gz"
  sha256 "d0a1cf9bdbab5294eaa2e8859a20cfe162103df691604d87971a6eb541bebd83"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "598c2f969d228c6aad738f79102fd549d47facea2ebfd8fd25b1f3d7e85edbd2"
    sha256 cellar: :any,                 arm64_big_sur:  "b279a50abb9df0e703a3ed9edbc2f65146e5ee2cedc0e49fd9d593a8001e1f42"
    sha256 cellar: :any,                 monterey:       "adeb08c0941dbfb5ade18eb806408659a450c1bc3f0a84501e2bb2e24023c190"
    sha256 cellar: :any,                 big_sur:        "022a82b6d201fbdf76b421695bd6338fe2c02710f5fae1e17b9d304a9ef228a3"
    sha256 cellar: :any,                 catalina:       "eaa0081cf6b8569686e3d6405267aa9825e2e1021e63a7128f37c269f4bd4fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f74fda462cb23aadfd9c57d0f98dd67980f5dfbd303015a864143def16ebf356"
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
