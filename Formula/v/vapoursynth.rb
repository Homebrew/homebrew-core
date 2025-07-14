class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R72.tar.gz"
  sha256 "650f77feebfd08842b521273f59e0c88f7ba9d7cb5f151d89b79b8dfdd4ce633"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7c657252db9a2a5f6d4adcaadbf37c7a9979745fee6633c275e62d8388fe5db"
    sha256 cellar: :any,                 arm64_sonoma:  "6418245eb21b047ef3243906fc8b8920daec576e27617ae3e260f5aaa3935549"
    sha256 cellar: :any,                 arm64_ventura: "667bf1b35450d14761f1405975065166584e71430afbfc0056f38707ae9fe7e4"
    sha256 cellar: :any,                 sonoma:        "9c83c302ce30772f27755efe89c1281951f8a13a93b16e80c3d23af65e3c4fe7"
    sha256 cellar: :any,                 ventura:       "6f5549f7761bc12a30a9da999373a7b0b683475781324f4c7e947ac2d6d30102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21d9be54130292ed7ffd0e1551da3f1cf0279d9c077c492f959e9bcadba23ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d30b9474d07672ee99fdb6502d3b51d9ee18081350e943e5d784af61180f850"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13"
  depends_on "zimg"

  # std::to_chars requires at least MACOSX_DEPLOYMENT_TARGET=13.3
  # so it is possible to avoid LLVM dependency on Ventura but the
  # bottle would have issues if system was on macOS 13.2 or older.
  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++"
    end

    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--disable-silent-rules",
                          "--with-cython=#{Formula["cython"].bin}/cython",
                          "--with-plugindir=#{HOMEBREW_PREFIX}/lib/vapoursynth",
                          "--with-python_prefix=#{prefix}",
                          "--with-python_exec_prefix=#{prefix}",
                          *std_configure_args
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
