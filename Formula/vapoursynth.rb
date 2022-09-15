class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R60.tar.gz"
  sha256 "d0ff9b7d88d4b944d35dd7743d72ffcea5faa687f6157b160f57be45f4403a30"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ff4ad9d154967259f74778f6839ceb19b6f24762e64121c94bd97d604de8572e"
    sha256 cellar: :any,                 arm64_big_sur:  "465ce5e57344b718de9ccb99b0617df0e00fb1616f0e63279ddab6203692d1d1"
    sha256 cellar: :any,                 monterey:       "d4566d03e29d3767163e2fb47e18561ce50d62be719b93e10a9b300d8058e093"
    sha256 cellar: :any,                 big_sur:        "e7f5270ca06a338376e07a002832de390f454f650af375def36b148dc2d61d19"
    sha256 cellar: :any,                 catalina:       "f4aacbf3bb948ddb75d3e768cd1f4680a1ced6c66511c2aa989ac5c3b2809eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9884eb0ed18d814b9a378bf3ad53b1cd6a3a369b471085fc37b8401174fc5e5"
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
