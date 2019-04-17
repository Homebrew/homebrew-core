class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R45.1.tar.gz"
  sha256 "4f43e5bb8c4817fdebe572d82febe4abac892918c54e1cb71aa6f6eb3677a877"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "521193ca2eae647c44b10b5d7cb35412648a9597783c386a6a5e7092f9ea6f0b" => :mojave
    sha256 "70b9d58584a6ab74962105699c63f08c291eeb0871ed0777c1b112bdad065110" => :high_sierra
    sha256 "a97cac8bd38657bc16572d9611f1088465ecc09efb10cba714ef9e896fe38e65" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/f0/66/6309291b19b498b672817bd237caec787d1b18013ee659f17b1ec5844887/Cython-0.29.tar.gz"
    sha256 "94916d1ede67682638d3cc0feb10648ff14dc51fb7a7f147f4fedce78eaaea97"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", "python3")
    venv.pip_install "Cython"
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{buildpath}/cython/bin/cython",
                          "--with-plugindir=#{HOMEBREW_PREFIX}/lib/vapoursynth"
    system "make", "install"
    %w[eedi3 miscfilters morpho removegrain vinverse vivtc].each do |filter|
      rm prefix/"vapoursynth/lib#{filter}.la"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    %w[eedi3 miscfilters morpho removegrain vinverse vivtc].each do |filter|
      (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/lib#{filter}.dylib" => "lib#{filter}.dylib"
    end
  end

  def caveats; <<~EOS
    This formula does not contain optional filters that require extra dependencies.
    To use \x1B[3m\x1B[1mvapoursynth.core.sub\x1B[0m, execute:
      brew install vapoursynth-sub
    To use \x1B[3m\x1B[1mvapoursynth.core.ocr\x1B[0m, execute:
      brew install vapoursynth-ocr
    To use \x1B[3m\x1B[1mvapoursynth.core.imwri\x1B[0m, execute:
      brew install vapoursynth-imwri
    To use \x1B[3m\x1B[1mvapoursynth.core.ffms2\x1B[0m, execute the following:
      brew install ffms2
      ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/libffms2.dylib"
    For more information regarding plugins, please visit:
      \x1B[4mhttp://www.vapoursynth.com/doc/pluginlist.html\x1B[0m
  EOS
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
