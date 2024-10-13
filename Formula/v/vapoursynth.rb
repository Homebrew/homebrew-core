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
    sha256 cellar: :any,                 arm64_sequoia: "00f8997cd247f6641329259f623e336b4feb18fae032c019be475ae1cc3c8258"
    sha256 cellar: :any,                 arm64_sonoma:  "edd1d5fb540852a089b5057ca3e3944b1345f36f5757a856f697e41b46631e66"
    sha256 cellar: :any,                 arm64_ventura: "40c48176bf091f4948180c5b723b6076dc7a535e41b7a74f01134f8e8f0bbcfe"
    sha256 cellar: :any,                 sonoma:        "409300fef9042815e20413da07b62ad3a11466dda308dbed4d2efc48862390b6"
    sha256 cellar: :any,                 ventura:       "e8165b80231eca4a2b62332ec5708e0ab4fd0966d2bddff5a13a1b3daa3720a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd5fade367963b7decaa5e8022319b8f2a8996e9941aac1d492d5e71d9a8bac"
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
