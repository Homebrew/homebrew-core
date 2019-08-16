class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.2.tar.gz"
  sha256 "8ce4553f9fc5e5bbfb26ec9c0c5bf94be307530f947424c713ef67bc8a6d22b2"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "e426560984862430199351fa15aa602f6c66088a182236fcc861062562b61876" => :mojave
    sha256 "ec3b4bdfd2124dac280fc882db961f8008c71d719f0abf383111e8bdb75c535a" => :high_sierra
    sha256 "4bf2ab368fbe6a11d2e5a870093fab3215d69625cebb2f9103ef30fb9feeb155" => :sierra
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
