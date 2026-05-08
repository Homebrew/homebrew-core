class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/refs/tags/r10.1.tar.gz"
  sha256 "3a340c23f4d77559d7c766a2a14f4a1e408752a785958930eb4ca41e13392c85"
  license "MIT"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d66a5b9cdcfd04fd2ba1bb26d0534d24840e43af534aca2047f56c9980b53c8f"
    sha256 cellar: :any, arm64_sequoia: "f089a6d524a754aac646203216c65958d2733369781c4f289eddec950d09801a"
    sha256 cellar: :any, arm64_sonoma:  "205173809d3bc30389b1b3f1caf4a036aee54ab1472ee0337e22be01702b696b"
    sha256 cellar: :any, sonoma:        "a8a84fff097131d528f37735a48106fa3bf9da188a8f16a82e6be09fa378e725"
    sha256               arm64_linux:   "9469cda709c6fe9e3ed9857899d32753bdd79997906e57518a988da7e387d470"
    sha256               x86_64_linux:  "361e6094fd9dc6f044cbb771fe14a35b5994cfd7923354f3e3f0e0fd181701f7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build" do |s|
      s.gsub!(/^incdir = include_directories\(.*?^\)/m,
              "incdir = include_directories('#{Formula["vapoursynth"].opt_include}/vapoursynth', 'include')")
      s.gsub! "install_dir: py.get_install_dir() / 'vapoursynth/plugins'", "install_dir: '#{lib}/vapoursynth'"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.bm3d"
  end
end
