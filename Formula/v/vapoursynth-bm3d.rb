class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://files.pythonhosted.org/packages/5b/16/6f1d0e05ceff921106281db6866d45e1b7eb284f078886e463ca9a1e6566/vapoursynth_bm3d-11.0.tar.gz"
  sha256 "a1d02dd4bf7e2b5bfaa2b3c6744e5093b225e8562a39d183a6ba239554cd876c"
  license "MIT"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a5e60dde90038691650f7c53f381df99785318179f20b23ac8ba7db293ef0298"
    sha256 cellar: :any, arm64_tahoe:       "d3b873d6c2906cbeeef57a6841800d0246b13ce44a1788a31bac833bf003aee9"
    sha256 cellar: :any, arm64_sequoia:     "f517d09ad1bd774e0b90c25b363412b2de491ad3fcedf2d701f443c9a0284e5f"
    sha256 cellar: :any, arm64_linux:       "63c157268ec452547c8b08d73d6e658880b8df2799260a2647dae401a3ff2cf3"
    sha256 cellar: :any, x86_64_linux:      "f51c018381b52974e446e5a7b2713a7b4580c50045be062abf1c713e51a803c5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  deny_network_access!

  def install
    (buildpath/"python.ini").write "[binaries]\npython = '#{python3}'\n"

    # Work around Homebrew's python prefix patch
    args = %W[
      --native-file=python.ini
      -Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import vapoursynth as vs
      clip = vs.core.std.BlankClip(width=32, height=32, format=vs.GRAYS, length=1, color=[0.25])
      filtered = vs.core.bm3d.Basic(clip, sigma=[3])
      frame = filtered.get_frame(0)
      assert frame.width == 32 and frame.height == 32
      assert abs(frame[0][0, 0] - 0.25) < 1e-6
    PYTHON
  end
end
