class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R50.tar.gz"
  sha256 "b9dc7ce904c6a3432df7491b7052bc4cf09ccf1e7a703053f8079a2267522f97"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "8a4c0a3d08c576610946a396388561d6ce46a24af9ea2954cf592aba914b0ebf" => :catalina
    sha256 "c1045eb58f7b9793cdb4e622dfadca7c2308fe16c1845ed7b074d647cac6b118" => :mojave
    sha256 "9e4cfb9328289c67833192af426b263e7aa25572ab81f6ab1fbd7243867b5579" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python@3.8"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/99/36/a3dc962cc6d08749aa4b9d85af08b6e354d09c5468a3e0edc610f44c856b/Cython-0.29.17.tar.gz"
    sha256 "6361588cb1d82875bcfbad83d7dd66c442099759f895cf547995f00601f9caf2"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", Formula["python@3.8"].opt_bin/"python3")
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
      (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink \
        prefix/"vapoursynth/lib#{filter}.dylib" => "lib#{filter}.dylib"
    end
  end

  def caveats
    <<~EOS
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
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
