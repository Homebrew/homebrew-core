class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R53.tar.gz"
  sha256 "78e2c5311b2572349ff7fec2e16311e9e4f6acdda78673872206ab660eadf7c8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5601a793accfb1cba1376f9307d8c9e87356d974d389e1c415f75666f9d1cc19"
    sha256 cellar: :any, big_sur:       "b37640258be83b5951cfe8c77cb9e34c00c37c04814df7f108da0280a63e2e3d"
    sha256 cellar: :any, catalina:      "ac5547b7872e34409f4ed5a9f7d11985eaffc7c690f95c06ac2c596c9609b3ca"
    sha256 cellar: :any, mojave:        "2e2b12d1569d8c4b6a4ccf6b49b7e3a7c7ab41fbd57ed5279b55c06e223d824a"
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
