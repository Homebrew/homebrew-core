class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R53.tar.gz"
  sha256 "78e2c5311b2572349ff7fec2e16311e9e4f6acdda78673872206ab660eadf7c8"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "79987efc9aa04472c4567b9ad708ef4e939a367099f9ed824d901649cbdc4214"
    sha256 cellar: :any, big_sur:       "1405ff1797a5bc77132d25f04ad1d67c54dea3f472f692445be9d68f96b55bce"
    sha256 cellar: :any, catalina:      "ae8eabe048ec75da1b9b28ee0aaf745aa098b60fe21340aaa89c104886fc4a13"
    sha256 cellar: :any, mojave:        "a42f53e1ac5f7d008e1685e02b6a9b94a9e466f19572ad8f7695df38349d4f37"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "zimg"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--with-cython=#{Formula["cython"].bin}/cython",
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
        \x1B[4mhttp://www.vapoursynth.com/doc/plugins.html\x1B[0m
    EOS
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
