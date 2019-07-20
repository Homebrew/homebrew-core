class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R46.tar.gz"
  sha256 "e0b6e538cc54a021935e89a88c5fdae23c018873413501785c80b343c455fe7f"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "b83e6f52e9d28bcc3a6ec60381572afc6944b1bee70dd98c2bf7df6539cb31d3" => :mojave
    sha256 "ac77292baaaab9738700d405d38062c3aaacddb0e9178310bf0c2ab3ba78b2ae" => :high_sierra
    sha256 "00d84652c2abb769faeccfd1dcfc15a800609ad563b0679cdd0b8e93c0780b23" => :sierra
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
    url "https://files.pythonhosted.org/packages/5b/5b/6cba7123a089c4174f944dd05ea7984c8d908aba8746a99f2340dde8662f/Cython-0.29.12.tar.gz"
    sha256 "20da832a5e9a8e93d1e1eb64650258956723940968eb585506531719b55b804f"
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
