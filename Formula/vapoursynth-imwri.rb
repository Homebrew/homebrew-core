class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "5f9055a5a4e55cdbf1f103b09f6c4b77a7544fe15e27fdf64af23ac7e74cc60d"
    sha256 cellar: :any, arm64_monterey: "7ac213c90b5bdddce15d0e72b3f790560c9dcc3cd411874daa81bfe5164ddf67"
    sha256 cellar: :any, arm64_big_sur:  "a3bf24671c674731b767334263fc0a8ae86d8aca14d3c9e0f3e0425bed7e5e3a"
    sha256 cellar: :any, ventura:        "4594a357ab6099a587e746b28c54f38cc62aa02b1e42b7c26007edc2d6047e9d"
    sha256 cellar: :any, monterey:       "9f7a746dc9d06d744b246ab6486cb01dfc0862a239945c9da43f3fc2fd35a281"
    sha256 cellar: :any, big_sur:        "6e695d666d479b69bff01083f0a3ac68e79f055c26cc30ef5253dfaff7d6ac78"
    sha256 cellar: :any, catalina:       "83f865c98f2b83384a2714589824beddabe0f1180fc028fd529e01c1ba873655"
    sha256               x86_64_linux:   "b06f11cf0fe16bc8447d1d66a9c56c2fa19ec9900bed475f4330500fec591d6c"
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
