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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "168b8535fa080eaf1f31ab7f9067d4a9d2da34ec71f5ba6edef5b6915d3cd605"
    sha256 cellar: :any,                 arm64_monterey: "ea994ffe530d5ca8dfa7346c7e72c0d7d641c484ec097ec3ac4cebee22163a53"
    sha256 cellar: :any,                 arm64_big_sur:  "ed111308a209ef8a1c9579d7a3e0ce80aed70c03966356f1d4340165ba1d9776"
    sha256 cellar: :any,                 ventura:        "c0771cfc95ce712bfd36b40ff3c49181256074ecdc6d7cfe1a899c95113c1b42"
    sha256 cellar: :any,                 monterey:       "6ebbd237599d0efcad2a0d928f6b35dad8e5d079a98a254e2d0f4dcbe3ac2e07"
    sha256 cellar: :any,                 big_sur:        "12680cc137631e3a5e785b3350c3129b8ece6bb8b17530242aba5e0097abf4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5a702042cf9f7d3161f67b7b4a7beb48589fba1cd9bdfe9ca6bbe5ac99762b"
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
