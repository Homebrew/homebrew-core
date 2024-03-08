class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R66.tar.gz"
  sha256 "e2c82b1f583adbc33dabbe59c0dc65e6aede70dedebe79be94155cb38d418b2c"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "488520c4bcd844726c38cf93f822f254f5c91c0c89f0396b65efcdeab25e8f0f"
    sha256 cellar: :any,                 arm64_ventura:  "a13bd15b7f6d470fcb26466e0ac5f7bbd33c1eb4458b8d3353af4080b06b5b05"
    sha256 cellar: :any,                 arm64_monterey: "12231c5fd5eabe738da5b8f001e8af4e46ad5ee4112728250f350b0cb04e185c"
    sha256 cellar: :any,                 sonoma:         "d31698d725b9eb31354aaf74515d27603528fe5d11b21a6e5315d4ec689c3b14"
    sha256 cellar: :any,                 ventura:        "78231197d76f85e0364f5584ee369a9213732ae3b68a5135ded5d4bbae9a7fc2"
    sha256 cellar: :any,                 monterey:       "ab2c1865c7cfc0d07fc680b3b6f3b29501cfcfa6cb322d3cb8b8d0abeaaa14d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68ae2af45bec8169c03b442f8885724a887f013a5640367b8639601d23d7a174"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
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
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
