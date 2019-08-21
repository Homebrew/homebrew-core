class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.2.tar.gz"
  sha256 "8ce4553f9fc5e5bbfb26ec9c0c5bf94be307530f947424c713ef67bc8a6d22b2"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "711b7cd653960c7a5bdca03cf61f65762263f5f671d31643f07855b081830f39" => :mojave
    sha256 "13674a1418e1d94518e8bfc800929c6e48cddd021c8329277e61599e05393255" => :high_sierra
    sha256 "f65b3c9f3e67840a1217956994cb4e58be18d3058a2731d7e2701b2e763efede" => :sierra
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
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "from vapoursynth import core; core.ocr"
  end
end
