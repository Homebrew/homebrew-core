class VapoursynthBm3d < Formula
  desc "BM3D denoising filter for VapourSynth"
  homepage "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D"
  url "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D/archive/refs/tags/r9.tar.gz"
  sha256 "3eb38c9e4578059042c96b408f5336b18d1f3df44896954713532cff735f1188"
  license "MIT"
  head "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ed1ce1b7d70147548a3084f5ea3f6e566dcd3eec95a73f8bebeae11dddcf068"
    sha256 cellar: :any, arm64_sequoia: "cd74bd0883bfce060f6339296d2818ef27176ca0c90e4976e52360cb5ed4b607"
    sha256 cellar: :any, arm64_sonoma:  "4e8e0734041246802ffa524cf6d0c69ef6f5d3442474f9f48a492118272ae989"
    sha256 cellar: :any, sonoma:        "c6b1ef17861ac5132ddfb4e79d21dd626a28427f768184de39ff112ba11bca18"
    sha256               arm64_linux:   "379ddc96676ca5ab83823fb53e8ea11793764e33706ca648cf2f9fc8a74f4fc7"
    sha256               x86_64_linux:  "6171db118b9fd5383ba2b35f3a13bfa6f2c358c952cfacebf600ef1bb552c4a2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth'),",
              "install_dir : '#{lib}/vapoursynth',"

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
