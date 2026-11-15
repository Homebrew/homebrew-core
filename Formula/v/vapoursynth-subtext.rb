class VapoursynthSubtext < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R7.tar.gz"
  sha256 "5390048844b6bfaa2ef574a52158f5a31f5568790d98e64c99ac5543bf45d38d"
  license "MIT"
  revision 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7804cd81ddc9dfc4cb555a77cb4c4edeba47e0ccfabb865070c2ec27ce26e38"
    sha256 cellar: :any, arm64_tahoe:       "c4978b4e598786655954effc2a6502546c80db1ecd48ec84b7ce5618ca0f4fca"
    sha256 cellar: :any, arm64_sequoia:     "87843464f868f4f027bfeaf6d0282f4c56d41066f80b4286bf019fb43dd06d3a"
    sha256 cellar: :any, arm64_linux:       "a34407b4a756f7f62caaa7ab6bc28d6caa2a6ce436364413e4f4fd42b574f752"
    sha256 cellar: :any, x86_64_linux:      "fe764e1dfa5cc2760a8849d5a486a94f93fcc940879f07712cbb453afa2da291"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  def install
    # Work around Homebrew's python prefix patch
    args = %W[-Dpython.platlibdir=#{prefix/Language::Python.site_packages(python3)}]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.sub"
  end
end
