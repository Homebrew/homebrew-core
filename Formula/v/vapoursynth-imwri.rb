class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 4
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "741d14cb00892c51017db89d9d6282bc27d819cf515f1d438021329a8c953daa"
    sha256 cellar: :any, arm64_sequoia: "15772647abe3ac7014dd7c172df5bab501c2fd2d77fea844c1a73cae83e41163"
    sha256 cellar: :any, arm64_sonoma:  "af27a43d46f0b920914e63a0c0c869e33ccad92ceadd6d163ac7d7fb787d5ede"
    sha256 cellar: :any, sonoma:        "82a3b82baf9bcef234ff74ce531066bc00822cfb15ae9b2731c10c5acf64cb7f"
    sha256               arm64_linux:   "a6f007ebff290fde0639f18e84209257904caa71ab3b2c637917afef351077be"
    sha256               x86_64_linux:  "06b8af0cd92ae0c33c058575712a7f4cc37767962ebf3423a25bf20d2a0db6fd"
  end

  # "This repository was archived by the owner on Apr 9, 2026"
  deprecate! date: "2026-05-25", because: :repo_archived, replacement_formula: "vapoursynth-bestsource"
  disable! date: "2027-05-25", because: :repo_archived, replacement_formula: "vapoursynth-bestsource"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "imagemagick"
  depends_on "libheif"
  depends_on "python@3.14"
  depends_on "vapoursynth"

  on_macos do
    depends_on "jpeg-xl"
    depends_on "libtiff"
  end

  def python3 = "python3.14"

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
