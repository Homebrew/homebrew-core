class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R72.tar.gz"
  sha256 "650f77feebfd08842b521273f59e0c88f7ba9d7cb5f151d89b79b8dfdd4ce633"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e25798f5037641754cc810363dfb6c171ad60db37149c15d581de01bd85d975"
    sha256 cellar: :any,                 arm64_sequoia: "1be3b17dd888bd35931e513d9501c1ae3d13ca8df129360400e9a37e28c19122"
    sha256 cellar: :any,                 arm64_sonoma:  "b019ea2a813d43818d534d047a82ca353915ffa336517f822212fb7802c700b6"
    sha256 cellar: :any,                 sonoma:        "363c3069fd1c227f6940de2bd5bece455ee1ddb9578ea2fc82cf3d2036aba8f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee99112759f86db2f64bc4a6966731dd60a863450af3c3f71f0c26c6aef3348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f6ecf50c9407e1740250ac54fa75bceaf6e936432c265140776703b585cd78f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14"
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
    system Formula["python@3.14"].opt_bin/"python3.14", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
