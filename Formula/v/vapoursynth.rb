class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R70.11.tar.gz"
  sha256 "41af974964a20aec670f5d2b235e043cb9c3a68db90fa39cc57c609c7d8baa91"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ee5adc2d1dbf7d498288d7985f4cb0c8864839da236f488589d3cafbac790298"
    sha256 cellar: :any,                 arm64_sonoma:  "b2871cef73318ec5e2c6d1ecddbb5c6076234f780168b629383dca0bb6454dcf"
    sha256 cellar: :any,                 arm64_ventura: "9067216d100a77925d1dc08f8c0e2e299b278dff4dc4d0a6c606d44e98ae60df"
    sha256 cellar: :any,                 sonoma:        "65d657bc9182c090778de56296d0c1de271c090bcea3594eba6e0857fbb9936f"
    sha256 cellar: :any,                 ventura:       "67ec89b25a5740650272adf4efd902856c956e83698190d8687d07222b40ace0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7220852e6334b59bb248017f896ba23d16e559c672db7a5953e9fb48535ef07a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13"
  depends_on "zimg"

  # std::to_chars requires at least MACOSX_DEPLOYMENT_TARGET=13.3
  # so it is possible to avoid LLVM dependency on Ventura but the
  # bottle would have issues if system was on macOS 13.2 or older.
  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang
  end

  fails_with gcc: "5"

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++"
    end

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
    system Formula["python@3.13"].opt_bin/"python3.13", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
