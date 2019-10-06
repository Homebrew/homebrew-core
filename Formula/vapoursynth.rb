class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.2.tar.gz"
  sha256 "8ce4553f9fc5e5bbfb26ec9c0c5bf94be307530f947424c713ef67bc8a6d22b2"
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
    url "https://files.pythonhosted.org/packages/a5/1f/c7c5450c60a90ce058b47ecf60bb5be2bfe46f952ed1d3b95d1d677588be/Cython-0.29.13.tar.gz"
    sha256 "c29d069a4a30f472482343c866f7486731ad638ef9af92bfe5fca9c7323d638e"
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
