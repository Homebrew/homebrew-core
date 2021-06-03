class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R53.tar.gz"
  sha256 "78e2c5311b2572349ff7fec2e16311e9e4f6acdda78673872206ab660eadf7c8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b18dd1a4f43d95579c48d35f8ec579a706f6ed0ea104cf25dee995defd426ec8"
    sha256 cellar: :any, big_sur:       "e9e17493e1e3f2ab020be8425ab9d17266b53f91e0c5277c156a2970f665ba75"
    sha256 cellar: :any, catalina:      "be4e734c5d4cb506ff006ddd17d9fd536f3035f26315bac49bb151088b8ead71"
    sha256 cellar: :any, mojave:        "e109782020a18bcf8b8a3c9ddddbd593abfabbc8e3513bee26abcfd1bf35d4d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-core",
                          "--disable-vsscript",
                          "--disable-plugins",
                          "--enable-imwri"
    system "make", "install"
    rm prefix/"vapoursynth/libimwri.la"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/libimwri.dylib" => "libimwri.dylib"
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
