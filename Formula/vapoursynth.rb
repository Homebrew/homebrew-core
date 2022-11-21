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
    sha256 cellar: :any,                 arm64_ventura:  "4ec2c7527a8005b82010c2094f842db805276395c67aff3bdb077f3716712ad6"
    sha256 cellar: :any,                 arm64_monterey: "cb2bac5759ef81702178c25a6be35bb14ed18e69ff4e0ef5c34911d67c013880"
    sha256 cellar: :any,                 arm64_big_sur:  "532b4272e50d571934f18597e92113c6fefae1313201d05703fa3de021bad000"
    sha256 cellar: :any,                 ventura:        "fda32be9017874a18d2564d9470c9aa92a65f92c0af29d0636cc6b37ae3ceb04"
    sha256 cellar: :any,                 monterey:       "265216c789a54f780ada7d12ff6f53172cf24094cb653cff240e7b1100e44cdd"
    sha256 cellar: :any,                 big_sur:        "2e8ea488f9152e0bca718d9a244cda426d1481c6a264f142f07e0748a18a0fdd"
    sha256 cellar: :any,                 catalina:       "0a5d7d81c8f5a61293eb115a2f1874d019cfd472d34edc6f6ab2a4eae760a776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1136401f6f7d77c52872cfbbcfda0ec1216c8ec0bcf302cca023f02ef21be19"
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
