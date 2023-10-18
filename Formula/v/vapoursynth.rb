class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R64.tar.gz"
  sha256 "29e7972eace52bb83365cf9a14a5552df444090391f032de23b589ed8ff64213"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb9325bde74d46e3251fb4bdec7952dee4034cc60fb8864aea1acc5ce874d68f"
    sha256 cellar: :any,                 arm64_ventura:  "bc97fa477f1db4f4f1dea9ab7cdbc363163a1eb1a33ad69b6bc26a6558ba7e10"
    sha256 cellar: :any,                 arm64_monterey: "47cfda3b9a76a4f83ac0f8a546c5349f4699961d8167d92b595679ed65a5d3bc"
    sha256 cellar: :any,                 sonoma:         "93532ad647071a20e0a03220778139f86473ddba668c516a7530a40907646203"
    sha256 cellar: :any,                 ventura:        "34df6a1833133f3837b40abf1c791e27548460e0bb846ef6c59401635b06e479"
    sha256 cellar: :any,                 monterey:       "e4bb21dc33274bfaa3fc821760bec8eeeb4fa93aa688c470dc402687eea17630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bdd01971b91f2fad19fdaae04e9f628544c328f65bf0e2447688f507827f772"
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
