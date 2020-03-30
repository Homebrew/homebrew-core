class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R49.tar.gz"
  sha256 "126d1e68d3a3e80d1e215c8a2a5dc8773f5fcac70a6c22dadc837bccb603bccd"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "c894f8d87246e2c0589b928f628ee7298af63e753ccb280ed80c1513773d569e" => :catalina
    sha256 "7ab0e793a388da6609c1857b8b16479952e1765f3fd3133dc82184cc0700a048" => :mojave
    sha256 "d1df199256931db3d1a1bc84c60496b2f4426aa9a5567556ca12dbcb31ee91a4" => :high_sierra
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
