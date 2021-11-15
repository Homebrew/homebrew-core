class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R57.tar.gz"
  sha256 "9bed2ab1823050cfcbdbb1a57414e39507fd6c73f07ee4b5986fcbf0f6cb2d07"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "108ae8bf93ed9fb5452f6abab3eea4e64ff45e1c56c16dbcf9f2e58a635f01ff"
    sha256 cellar: :any,                 arm64_big_sur:  "5a1894344106815d7e56ea97f3c10261c6c5d9f381a1e22c8ba84b5449462c80"
    sha256 cellar: :any,                 monterey:       "249af500801e3279913bc998f58f064d4ffa73c5ec826ba4035d23fcdc1123cc"
    sha256 cellar: :any,                 big_sur:        "1048c34d749d82dcc5e8bee5ceb6d3301c1e707a2c3bfe792ffcf245d20efe0f"
    sha256 cellar: :any,                 catalina:       "2b83c33807217758941fd9d83226057e5a8e4baf71c75c01ae27917150cf14db"
    sha256 cellar: :any,                 mojave:         "780814b825bb7b83c68a6d9d5c2b3aca4e24b448e3be0cf17dfcd9623124f382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f95a015ee64ea7eb0c9219082e96e5a0ee7c2e0063a5ee9277aa11389bb1772"
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
