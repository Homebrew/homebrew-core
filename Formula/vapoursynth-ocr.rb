class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R53.tar.gz"
  sha256 "78e2c5311b2572349ff7fec2e16311e9e4f6acdda78673872206ab660eadf7c8"
  license "ISC"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f47ed98e6b770f53a458c4fa8bb12c38c221de1e864a1227d3b1a08f2557fcf"
    sha256 cellar: :any, big_sur:       "09c4405c9221feef7fa8a09e8f7a1d8bd6ab7fcc8b9feddc3a9a338d91fe1edf"
    sha256 cellar: :any, catalina:      "99b1665bc4dea00f8984e748d814cd88f904b9fbe220e3d0bb0d5affde8430fd"
    sha256 cellar: :any, mojave:        "ec7fa75affd62d2a864e3613a4833981d1d40301d5ea8a95be642bc7969fe5da"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "tesseract"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-core",
                          "--disable-vsscript",
                          "--disable-plugins",
                          "--enable-ocr"
    system "make", "install"
    rm prefix/"vapoursynth/libocr.la"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/libocr.dylib" => "libocr.dylib"
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.ocr"
  end
end
