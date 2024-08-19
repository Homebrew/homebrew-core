class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R69.tar.gz"
  sha256 "cbd5421df85ba58228ea373cc452ca677e0e2ec61b59944d7e514234633057d9"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c068b4aae76a49f75fa69f2a0c912b2c42cae12e23633a62790b236e521c853c"
    sha256 cellar: :any,                 arm64_ventura:  "f0c7cdf6870a2ca1ad28375c56ad558be931a857eeab8e3e6ab6c44bd83d0614"
    sha256 cellar: :any,                 arm64_monterey: "6959ec30fec16d7dab2c8ca24f1194242a5ea676bc9faf10971c53dea36bf4da"
    sha256 cellar: :any,                 sonoma:         "8e1b3d94df8e77be8657080738cde6d93e854bbf879ed020fd4dadde8881788e"
    sha256 cellar: :any,                 ventura:        "2eef107de5fea6860c811323416bc0ff931297edce5c1df27fdb9ab8c8a37796"
    sha256 cellar: :any,                 monterey:       "e62b9b2e233f8da7eb1ba3125214897efa17df41787d47f12d420fbbd55bd342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3320b2db9df43d7dbd5029026fc555da39d1b8c698d2460155bda5d49336eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12"
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
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
