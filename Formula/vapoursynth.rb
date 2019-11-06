class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R48.tar.gz"
  sha256 "3e98d134e16af894cf7040e4383e4ef753cafede34d5d77c42a2bb89790c50a8"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "fe7f5b0167d3b2d5c441b4f1a1f62af7da63671cbe4b162e23ce72ccafec9a9f" => :catalina
    sha256 "dd32c56e6a0e7b1cab9648e4c03f967dad7738b4d39861b992610b0954f24369" => :mojave
    sha256 "00eb68a475c8ab46c5d6d10a7ee64280514b6caa0f84a0eb4369a665baf517d0" => :high_sierra
    sha256 "2f16a946f0b5eb0c7e580c95f2dc89bb53f1e79841ad99db3c0c475a089cef1b" => :sierra
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
    url "https://files.pythonhosted.org/packages/9c/9b/706dac7338c2860cd063a28cdbf5e9670995eaea408abbf2e88ba070d90d/Cython-0.29.14.tar.gz"
    sha256 "e4d6bb8703d0319eb04b7319b12ea41580df44fd84d83ccda13ea463c6801414"
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
