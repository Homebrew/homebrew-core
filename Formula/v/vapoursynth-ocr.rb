class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vs-ocr/archive/refs/tags/R3.tar.gz"
  sha256 "e9da11b7f5f3e4acfee5890729769217aa5b385bb573cb303c2661d8d8a83712"
  license "MIT"
  revision 2
  version_scheme 1
  head "https://github.com/vapoursynth/vs-ocr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1fd7b4b155da4e95c9923f3d211ecf67d05b0aef9f6b4571399e97fa45ec42b4"
    sha256 cellar: :any, arm64_tahoe:       "c968f89e3c811a95fa7bfdefd19866ee5ddea675e9563a91454ebcd99ef0ecc8"
    sha256 cellar: :any, arm64_sequoia:     "3e12656a5afcb516b4aa9a93046623cb1ff03e01ba67be4ff49f8a8946204e6a"
    sha256 cellar: :any, arm64_linux:       "2f8e6160a413cbbf03898e47d3cd84482b1de8fd79967698958d8f9698be6e08"
    sha256 cellar: :any, x86_64_linux:      "0e082d5f8a530380212cd383bb135936c6757de6c9fa338db1b2bc77a6eff993"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15"
  depends_on "tesseract"
  depends_on "vapoursynth"

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
