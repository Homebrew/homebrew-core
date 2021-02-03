class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R52.tar.gz"
  sha256 "4d5dc7950f4357da695d29708bc98013bc3e0bd72fc5d697f8c91ce3c4a4b2ac"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "782155d813a8584308bac2c8e5f18b5d89676f525ce6d8a86e39690112ccf931"
    sha256 cellar: :any, big_sur:       "29844547cbad34f1adf37b43d840f4201449c7fd75a01bedba147dcfebc680f0"
    sha256 cellar: :any, catalina:      "eced781162afdd0a6ac92a1e0e065fc51e69f5bee44e4e6faa163dbfb29a2752"
    sha256 cellar: :any, mojave:        "da208b8b7ca90df94dfd831f7928f9000f9f8b04434f0cdc3ed416c271eb6031"
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
