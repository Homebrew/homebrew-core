class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 1
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c4084f311c842c5f446e6ae6607b8dc376846059214170ce2b71eea14ec594aa"
    sha256 cellar: :any, arm64_ventura:  "6455b43165b08648bf8fe0ed4b3ad768e40064229b453ea6ee20ba2a6c2c4062"
    sha256 cellar: :any, arm64_monterey: "980ce869ee1e94b7070352ed72f5156afac59eea2a35426f7316a584f58a7a93"
    sha256 cellar: :any, sonoma:         "d342a83a4f966b388e17429302530c94269e6d51f597a22c85405047078bda2d"
    sha256 cellar: :any, ventura:        "30191e100adb12d68249787bbbc4cb5471a5f6a45879641599c72aaf75d923a3"
    sha256 cellar: :any, monterey:       "2bcafef5efb598bf38a30ebb84b6343fbb10aa56e659fdc16f09a5a102a5ee67"
    sha256               x86_64_linux:   "ba39999734846bede76c7e49e48dff0dc1b4f8555d178fa747cfbbe412fc4ef8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  fails_with gcc: "5"

  def install
    # Upstream build system wants to install directly into vapoursynth's libdir and does not respect
    # prefix, but we want it in a Cellar location instead.
    inreplace "meson.build",
              "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'",
              "install_dir = '#{lib}/vapoursynth'"

    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "-v"
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
