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
    sha256 cellar: :any,                 arm64_sonoma:   "c09bd9de06ad9404815f70a6e8ce8d2d5eb01df800695ea0e79f8dd10dae290f"
    sha256 cellar: :any,                 arm64_ventura:  "56e70fb775d6d5311ae6238c2e3813ed788588f470917ec76cab24ecedf1547b"
    sha256 cellar: :any,                 arm64_monterey: "42991a4a81c7be8c83b0621d34fa180a7b2801feb25d628d105d0cfb87613fa3"
    sha256 cellar: :any,                 sonoma:         "d56be557678de66d0332462bf5a44f2de5f1b01ac88adea1db3293f0c5f56460"
    sha256 cellar: :any,                 ventura:        "5727b4617a5014e77a6fa44e2701b66d738ea0645cb4af561b3dc24028bfc3bc"
    sha256 cellar: :any,                 monterey:       "498ecff638a4e015d5b52111448c89f4603a1631523d6756ed7034bcdf0a59a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc32bb12522f26c2582b0ab97b147227e31886c2476e47cb3f86923c5be4eedf"
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
