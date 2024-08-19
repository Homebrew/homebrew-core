class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "https://github.com/vapoursynth/vs-imwri"
  url "https://github.com/vapoursynth/vs-imwri/archive/refs/tags/R2.tar.gz"
  sha256 "f4d2965d32877005d0709bd8339828f951885a0cb51e0c006d123ede0b74307b"
  license "LGPL-2.1-or-later"
  revision 2
  version_scheme 1
  head "https://github.com/vapoursynth/vs-imwri.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0f9ad6460cb2b4176e9f938e9b6bc187b46a341eb13072e6df668c987e198035"
    sha256 cellar: :any, arm64_ventura:  "65bf37034b9c0b98dc82cfb26a227293d44e961c353a5699c47a879b86fa3e77"
    sha256 cellar: :any, arm64_monterey: "4a2a21d3632b637d78718a2990b27583ee6b29d4884eb85660ef75696212c5e0"
    sha256 cellar: :any, sonoma:         "b2a4bbfbaae66cc512e94e448470c1e37da854c54fe486239ab38fe0ae22d44f"
    sha256 cellar: :any, ventura:        "3d4761b4242cc2bdec54d8dd2d54e830083faa4939217a67c5ee693cb4ee60d6"
    sha256 cellar: :any, monterey:       "90cf83a8209771ffe476d9a4950693ec190edaa3cf6d7d0af02b70d770fcdd98"
    sha256               x86_64_linux:   "ddcbf221b69cd9a1dd5bae38d04f951bd1096897a9af4192b90a72ffad84a468"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "imagemagick"
  depends_on "vapoursynth"

  on_macos do
    depends_on "jpeg-xl"
    depends_on "libheif"
    depends_on "libtiff"
  end

  fails_with gcc: "5"

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
