class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R59.tar.gz"
  sha256 "d713f767195cb3a9a7ccb97b1e61e0cf5a9332eed86c6362badfff6857792a86"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9894cd9ff110eae2b332204dcaaf0d7f3c5ebc3131a4514f681e9bfcb65f0c8e"
    sha256 cellar: :any,                 arm64_big_sur:  "5500c1674c2514326b4917eb3065efc63de8c3140aa40b36dd25e47336a041eb"
    sha256 cellar: :any,                 monterey:       "51935240f0d7f7c94e70f1bd17c8688b9a2f3334a04227d7711653b7f3234b80"
    sha256 cellar: :any,                 big_sur:        "ecd4f3a72fe3e91db6aa54959e502fe3bf9a2caf57687ab87b4c4cbf67cb9ee2"
    sha256 cellar: :any,                 catalina:       "204e0894877eb6de2f94aae111c3f358ff612a512fc42e59914d6d308b642e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3176c295b69fcdc5adb51d0dd447f6d648660877d16888f7fcfeb24ff013368"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "zimg"

  on_linux do
    depends_on "gcc"
  end

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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
