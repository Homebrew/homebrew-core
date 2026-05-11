class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/refs/tags/r10.tar.gz"
  sha256 "3582f8c0aa00c710b4d4d484da2716207f2e1f305124a9c365fc7530461c25f3"
  license "MIT"
  revision 1
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6dc3874d1369504afab69b13d6bf21bbc3437088f6052fade1beaee5d64992ed"
    sha256 cellar: :any, arm64_sequoia: "4d938bb02801e8fba0ef24ce2b5ff9d614b2ae773a35fb33d558e23130cb4d82"
    sha256 cellar: :any, arm64_sonoma:  "b539cb6c0dfcdf1e7d01c350f1a492b778b5b091cb295283873d0adb17e65e34"
    sha256 cellar: :any, sonoma:        "af2cdf5852a16ea43d7f32f0504d15792893cc524401bd3f2b939bbfd1ae5b64"
    sha256               arm64_linux:   "f13ad83cd04d8a1c6a0e4160d83a8c678522b300e2e00910b2da79ef2a119fe3"
    sha256               x86_64_linux:  "aad7240c647d28093efc2cb64cc17ccd8f60a939185ccef62c8a85aa84a38ee8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  def python3
    Formula["vapoursynth"].deps
                          .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                          .to_formula
                          .opt_libexec/"bin/python"
  end

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build" do |s|
      s.gsub!(/^incdir = include_directories\(.*?^\)/m,
              "incdir = include_directories('#{Formula["vapoursynth"].opt_include}', 'include')")
    end

    site_packages = Language::Python.site_packages(python3)

    args = %W[
      -Dpython.platlibdir=#{site_packages}
      -Dpython.purelibdir=#{site_packages}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.bm3d"
  end
end
