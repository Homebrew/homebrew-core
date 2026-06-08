class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/refs/tags/r10.1.tar.gz"
  sha256 "3a340c23f4d77559d7c766a2a14f4a1e408752a785958930eb4ca41e13392c85"
  license "MIT"
  revision 1
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab6f04f6c19a12c93db8c21a75c6b8f5bf2eded72ee3bbf17bb664002c15a680"
    sha256 cellar: :any, arm64_sequoia: "0cfc85062a2cb1ccfbba44e28cc714e1a7529a1abc59472e2a70f6742ff04ac9"
    sha256 cellar: :any, arm64_sonoma:  "20f00b073e2243a147bde3cf910ca95b1b3407b1807d2413f633ef37c1974a03"
    sha256 cellar: :any, sonoma:        "cb91156d287ef75a47e3ce0ca3f1b870af2b82f7cae432f0cfcaae1d948f1b4a"
    sha256               arm64_linux:   "b0943031a534cba652e42a5a33ad4d52de40586195e3b22e14ac1bd628817f80"
    sha256               x86_64_linux:  "d1e499cc1ae84d17684d1898ca282803dc3661fb89f3574e8f63a89f37e90210"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  def python3 = "python3.14"

  def install
    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.bm3d"
  end
end
