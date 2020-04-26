class VapoursynthOcr < Formula
  desc "VapourSynth filters - Tesseract OCR filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R49.tar.gz"
  sha256 "126d1e68d3a3e80d1e215c8a2a5dc8773f5fcac70a6c22dadc837bccb603bccd"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "605f0803589d425a97f72d3930ca0f85859ef955aa914072c259db18cff26b72" => :catalina
    sha256 "bb6ff386fad03adde9f782293be331f286b87634abe1da23198b3e3c1f48b782" => :mojave
    sha256 "69e70bca123a0f0b627c0e117df9611c0fbf66d42d45e54e31728b7681f28ba0" => :high_sierra
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
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "from vapoursynth import core; core.ocr"
  end
end
