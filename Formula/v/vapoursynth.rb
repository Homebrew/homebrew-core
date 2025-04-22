class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R71.tar.gz"
  sha256 "c56d6de16d0a24db7eee1bd5e633229b0bd8a746eafcfe41945a22f9d44f8bd6"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c811e68a0a4c74b0f5dd95251de2e2a371bee226248464d812eb8fb4e286c369"
    sha256 cellar: :any,                 arm64_sonoma:  "ad4ec393ca8107f78d57aaf86443351b358eb241628409e245a85a3c9ecdc987"
    sha256 cellar: :any,                 arm64_ventura: "e48bcb4e7917b3e94fd2e807033b74cde7442b8424f74ccb5a3be4d0cb07ad40"
    sha256 cellar: :any,                 sonoma:        "1cfae7c19a2e90651be720f5de5115bb53fcaf4cadd30f9c42345860250f6ab7"
    sha256 cellar: :any,                 ventura:       "cdebbe7fcdcde1d9b2b497f95d5f4a4a0c726ae169603d3ff1b0847eab96f6be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6d9ebf6663b9f7eabfc1099f4bc075d6a468db6f53f1214ed49637458bd81bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b6eb19bb2166cc0c976f621ba133f357e3629b2a2bbc0f30031e3ec7473671"
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
