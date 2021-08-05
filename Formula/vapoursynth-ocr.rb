class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R54.tar.gz"
  sha256 "ad0c446adcb3877c253dc8c1372a053ad35022bcf42600889b927d2797c5330b"
  license "ISC"
  head "https://github.com/vapoursynth/vapoursynth.git"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0ee61239f71e594c05f6a93b675b9863ab53227715c355ef9b75ca1f92e577d5"
    sha256 cellar: :any, big_sur:       "c73eea38acf6dde0e271aa71393020d8f76c9c1c48607048c14b2ca53616d629"
    sha256 cellar: :any, catalina:      "939098378976ede311e6b3158928a64bdf2fc1283655c2349501bec9bcd3d2d8"
    sha256 cellar: :any, mojave:        "708071510107a61e077d3ff47019c32120c65cfcc91e8265ae2e692f04d490f3"
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
