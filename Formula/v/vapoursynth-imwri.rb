class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 3
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc90cc4f2d65c9f885c7fe4557766fdfb19a868f1a6ef9166803851a3fb8d798"
    sha256 cellar: :any, arm64_sequoia: "05e577ee12e4337fb9af5870c39c485e5e7a5ac4b56365361e9c2e7e35eca388"
    sha256 cellar: :any, arm64_sonoma:  "2bbe0c55617799e49cfd693a838565894dc7ecb5fbcaef0b72e9103da674999d"
    sha256 cellar: :any, arm64_ventura: "8795d8f3142e89ca1785f5d83312ab82ae4c24dc0e92b54aae294dbca1d14d0c"
    sha256 cellar: :any, sonoma:        "6ffe0859ceae64e20741fb000a0319b456dd51d437e35e79f354eabcdface889"
    sha256 cellar: :any, ventura:       "92866496e81b76604e8f4fbd5cab2d6d94d2f83cb4521e731802445ebcbd86e6"
    sha256               arm64_linux:   "f90a76a7b71b8d829a4f90c0969b2f7321f849f1ab9616f136cf943ffe198d10"
    sha256               x86_64_linux:  "099e77da73bbc6d8333e6067705d531ba193d3a496d8c99fc5287f7bec4f5ac2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "imagemagick"
  depends_on "vapoursynth"

  on_macos do
    depends_on "jpeg-xl"
    depends_on "libheif"
    depends_on "libtiff"
  end

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", "from vapoursynth import core; core.imwri"
  end
end
