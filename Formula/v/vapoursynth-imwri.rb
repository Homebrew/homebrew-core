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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7a8829c333c4d82d927f3cfc9c88a5d162b230924f17003b44b86f8b61966ff8"
    sha256 cellar: :any, arm64_sequoia: "04dc93bb5a1c4a49b90f29800901f4c6cc00f6a024512e3a94f06864724524df"
    sha256 cellar: :any, arm64_sonoma:  "90d9c3dbeceab3b486f1a73273079fff14e4b70ee85e70a766b672ffa25df7f2"
    sha256 cellar: :any, sonoma:        "11435523067bbf5c1cfd7c9597b1340afe4f34c94c64f8d0667e3d580c84ebe5"
    sha256               arm64_linux:   "b72bf4ebcdaade6cb9e1ac993c2334fda6aa69b54dab5c5deb58b804fd193d5d"
    sha256               x86_64_linux:  "21b4c595a5528b6d61eaba2d223e2f51bdf2b69ff50d623a915fc55a98263513"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "imagemagick"
  depends_on "libheif"
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
