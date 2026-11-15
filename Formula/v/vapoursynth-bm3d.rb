class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://files.pythonhosted.org/packages/7b/b5/f7c6b2035409be2c3417f44426f29d9434075a42e5fcfd477ad765183f11/vapoursynth_bm3d-12.0.tar.gz"
  sha256 "576abdee38944001a545804b4fbecd65d8789dd2ebc11eaea13e0b4e95223896"
  license "MIT"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "100bbe3525e64f05a9519fad09cbe8bef1d5951e45c4cd2442ae606c847cd450"
    sha256 cellar: :any, arm64_tahoe:       "4baa36264f436024e6aebe7a6910ec07aaa5e587ea09a8ba97471110ecafef1b"
    sha256 cellar: :any, arm64_sequoia:     "7bd087bd90cc07f0054820a50ef74b593afe44fafa8c20f074cd8a961d3a9c64"
    sha256 cellar: :any, arm64_linux:       "fd10236149ed5690afcbc99f80cd60f017db3e900e8c32833db4a6086371b479"
    sha256 cellar: :any, x86_64_linux:      "a93819a5ca7475d16c06170e733acd77fb3eb601c625365e8012326bb957d269"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  pypi_packages exclude_packages: "vapoursynth"

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
