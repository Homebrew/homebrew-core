class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/refs/tags/R6.tar.gz"
  sha256 "536e2f056c7b318b0104b8b9050bb17c00d8ca60b0e5fdecf1ee92879c5f9165"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e72c530140ff3bce81a7456029227c2a3859fbae3c5091405b9dc6c6788ddd1e"
    sha256 cellar: :any, arm64_sequoia: "3df48df43f512e50f4763e543b95635a11a634e688ca408703a38e866e23d4f0"
    sha256 cellar: :any, arm64_sonoma:  "a5db7fd939deb265993977a742827c0a8cd5ba0ed99eebc9fc56b9fa7d5f7c02"
    sha256 cellar: :any, sonoma:        "396b89abb44cb82ae675eb8cd9e807a5d073c91a5d327ace62ef02d7173e647a"
    sha256               arm64_linux:   "49b9af9319e5d58e32704946ae287872b3a975825373d5affdc63d9ea9f1837a"
    sha256               x86_64_linux:  "a5dbbb47bb1afa5d0dba1422c737fb5e526330c9f91601d03d692854f945bc5a"
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
