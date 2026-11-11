class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 6
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cabbaa214eab04da81eaa2d838a89726f7712e6ae4a13b3ed4d5dfce430f1072"
    sha256 cellar: :any, arm64_tahoe:       "5b2981f5e1ad699181ba63885b46ca98920a3fe138a13e77a9e988051886f583"
    sha256 cellar: :any, arm64_sequoia:     "df76c6fcda88dd6ee3476480d529f03afe941fa72317dcf96b0274b8eccb74d6"
    sha256 cellar: :any, arm64_linux:       "aa5ec887015508a7eade5624a7cebd4468eda4c73b4233de0b4a2c06ad1e2232"
    sha256 cellar: :any, x86_64_linux:      "f48a451c1a1c92de9a6f43787d88a57760a75095617b8716a15fcf6ed7987a63"
  end

  # "This repository was archived by the owner on Apr 9, 2026"
  deprecate! date: "2026-05-25", because: :repo_archived, replacement_formula: "vapoursynth-bestsource"
  disable! date: "2027-05-25", because: :repo_archived, replacement_formula: "vapoursynth-bestsource"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "imagemagick"
  depends_on "libheif"
  depends_on "python@3.15"
  depends_on "vapoursynth"

  on_macos do
    depends_on "jpeg-xl"
    depends_on "libtiff"
  end

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{prefix/Language::Python.site_packages(python3)}/vapoursynth/plugins'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system python3, "-c", "from vapoursynth import core; core.imwri"
  end
end
