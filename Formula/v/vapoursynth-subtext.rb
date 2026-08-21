class VapoursynthSubtext < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R7.tar.gz"
  sha256 "5390048844b6bfaa2ef574a52158f5a31f5568790d98e64c99ac5543bf45d38d"
  license "MIT"
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9f29f7504fe5e4e57df7b88f10de0cedadc6f285d1ec2a993962041bdf2bf04"
    sha256 cellar: :any, arm64_sequoia: "025a0c9350739d4c374f6ce6bc43732fe1841f790422bef94a11d2a502c8fcc3"
    sha256 cellar: :any, arm64_sonoma:  "1eda85dc44e2d2a54850fd66b902b0c2430cb7a6d11e76f02a3a92aa1028e026"
    sha256 cellar: :any, sonoma:        "e01a455d1d0a845058684d83cc60e6da29d8e51b0b13d2fe3a3bfed718a7bdc5"
    sha256               arm64_linux:   "4edd416f3074325d593c6ba69d7c21a8d2c7eeb1f5f6f36ea0c02c398b271e77"
    sha256               x86_64_linux:  "6438542fc719db43f50784021fc9c2c4f424396496b4d466978ac42705e686ab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libass"
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
    system python3, "-c", "from vapoursynth import core; core.sub"
  end
end
