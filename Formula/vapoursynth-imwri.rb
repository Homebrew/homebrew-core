class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R49.tar.gz"
  sha256 "126d1e68d3a3e80d1e215c8a2a5dc8773f5fcac70a6c22dadc837bccb603bccd"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "4c6f6f8ecd2d6387b5f820ecf893d41b022e048f2a7bdbe342941a6f4e0bf4d7" => :catalina
    sha256 "ff2f432b2347c1898d1f458acd2ffc15ab16b116010c6c583eb06cdd58280d63" => :mojave
    sha256 "96c5d9127b174bf63b15d80ecab74d9b433463e9ce1ee467ee761e3db3ceb969" => :high_sierra
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
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
