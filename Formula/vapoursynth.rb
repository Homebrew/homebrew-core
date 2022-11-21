class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R61.tar.gz"
  sha256 "a5d4feeb056679dd1204153250d7c1d38e5a639e995d3c4e3a8e2e8fe1425b75"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbed556fcb06ece7435e3ee1b07f05b2975064162d849362fd175f4e20e085a3"
    sha256 cellar: :any,                 arm64_monterey: "c4eaf67aa81f58cc03bba831e78bc58ec34bafc3b893916466700af6d8196fb5"
    sha256 cellar: :any,                 arm64_big_sur:  "5920e6e2e47d365a54fcf7b8ba530d63ab8d582117a5348a345c521c464c5233"
    sha256 cellar: :any,                 ventura:        "48bdd5555529f2b13efb1134790ec72057935067b79ad005e29ca55674666b25"
    sha256 cellar: :any,                 monterey:       "4b7bd0b44eb0086e766efeff9129d7fef118b6ddf0a88701c4c94f643083e70a"
    sha256 cellar: :any,                 big_sur:        "404d71359e917d42ce78fe3b37c4588ca14a64a91a4da417c9baab025d3b23f5"
    sha256 cellar: :any,                 catalina:       "6284a9174f2cabde880f828e093a690700457bb31f40b65b40b0dec221d17e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eca219f5145507ceebe8144c401cbe48d0dd1cc75e1257cc5071577e92a9aef"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "zimg"

  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--with-cython=#{Formula["cython"].bin}/cython",
                          "--with-plugindir=#{HOMEBREW_PREFIX}/lib/vapoursynth",
                          "--with-python_prefix=#{prefix}",
                          "--with-python_exec_prefix=#{prefix}"
    system "make", "install"
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
        ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        \x1B[4mhttp://www.vapoursynth.com/doc/plugins.html\x1B[0m
    EOS
  end

  test do
    system Formula["python@3.10"].opt_bin/"python3.10", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
