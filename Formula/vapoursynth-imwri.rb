class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R49.tar.gz"
  sha256 "126d1e68d3a3e80d1e215c8a2a5dc8773f5fcac70a6c22dadc837bccb603bccd"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "4e7d54dff9c16d7065706c1a45e234345b02843318cb350647c3d062c1702fdc" => :catalina
    sha256 "34dffc0e96bd5ee14577c227aa76ae5f41db46837e5172e361d6e48522a83c0e" => :mojave
    sha256 "7da1b0a97f2f2766b850927bf8e55db18d7ced470be6e47cc2df9d8f139847ee" => :high_sierra
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
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
