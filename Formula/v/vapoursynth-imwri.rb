class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 5
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eed007ba02299a42baa81ec18ea8d7feda1998b2df09c85e3e9a3717b02f8e12"
    sha256 cellar: :any, arm64_tahoe:       "a141604500909e5f8c965268cd7a6eb9967e9cd465f9ece4ba523b23cff6cbe9"
    sha256 cellar: :any, arm64_sequoia:     "d2b655610e5974403466d19621c54f5300e292cbc3d623708c5e9749d9c42a53"
    sha256 cellar: :any, arm64_linux:       "cabea6a36b04f5065e0debd88e041ddeb9476da6fb4114b935a81fdcb88f73f2"
    sha256 cellar: :any, x86_64_linux:      "5fa5d17370a37adcf9229b2f7308513a28f17cd8eac768f0f35abf6dbd4a20ea"
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
