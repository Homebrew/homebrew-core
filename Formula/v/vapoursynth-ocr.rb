class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/refs/tags/R3.tar.gz"
  sha256 "e9da11b7f5f3e4acfee5890729769217aa5b385bb573cb303c2661d8d8a83712"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ccfbd44ff93e0f78643332c798346e6479fb87045fdcf50f29843155ad9c377"
    sha256 cellar: :any, arm64_sequoia: "5617d9225a32445a33dee971980b3cea4917b1b26ffc7d37811417daaed1d19a"
    sha256 cellar: :any, arm64_sonoma:  "5a0b6dbc7cf8fbb2cd5eea410badfa459ad28a09ea5b01d44e20b482fc427bb1"
    sha256 cellar: :any, sonoma:        "f704f5d1c64d57421f3b68e10cae855197757b841e232657ed387b6fa2410ba3"
    sha256               arm64_linux:   "be8cdbe8e26862454aff1e05c0b6edac7b05cebe5c22ed724908834ef667756a"
    sha256               x86_64_linux:  "6f48fa48839bcd4c6bfe4c6b0c687ee3ce91048b953096f0027bd136ba25ea5c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14"
  depends_on "tesseract"
  depends_on "vapoursynth"

  def python3 = "python3.14"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')",
              "install_dir : '#{prefix/Language::Python.site_packages(python3)}/vapoursynth/plugins'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.ocr"
  end
end
