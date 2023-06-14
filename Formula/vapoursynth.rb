class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R63.tar.gz"
  sha256 "ed909b3c58e79bcbb056d07c5d301222ba8001222b4b40d5c1123be35fea9ae2"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e70596ad791ab8c4e07604df9a52aff1533580934050a0820123167d6df5d39e"
    sha256 cellar: :any,                 arm64_monterey: "166f33eb85fb222b494221332653557dd5d9e18bec3e3eed102253c6053740d2"
    sha256 cellar: :any,                 arm64_big_sur:  "38c1d4885525da2bac08584bb8579956f2c52d739347be65a8a8866956213146"
    sha256 cellar: :any,                 ventura:        "8bfafdad1dddfe52aaaadeac46f2e12f1a21c749712e009a572cfcb5eadd91d2"
    sha256 cellar: :any,                 monterey:       "b1004c0f029624d912b711b025248410cf1f0be1f8db070169e9183f81939531"
    sha256 cellar: :any,                 big_sur:        "6f168774e65db0dd68d88b27068feaf08a9ae0602d71ae190fd90e93a15cb94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a969dec3c05fd170e9cd4b599b69e0dd34cee41a238438168d21cf4035fc1d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"
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
      To use vapoursynth.core.sub, execute:
        brew install vapoursynth-sub
      To use vapoursynth.core.ocr, execute:
        brew install vapoursynth-ocr
      To use vapoursynth.core.imwri, execute:
        brew install vapoursynth-imwri
      To use vapoursynth.core.ffms2, execute the following:
        brew install ffms2
        ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        http://www.vapoursynth.com/doc/plugins.html
    EOS
  end

  test do
    system Formula["python@3.11"].opt_bin/"python3.11", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
