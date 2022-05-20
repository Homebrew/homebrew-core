class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R58.tar.gz"
  sha256 "19c1169eba61d7044354da3247a3a7c02a058220054ef2a8f501bfac5fed3bfc"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd38fc1ce263ed72f76ab34db2717ab2be4bc691bbfe4599fdd9b3c4911749c8"
    sha256 cellar: :any,                 arm64_big_sur:  "3fb908d387a892e45c760f6a30e4e85c0f0a5b7b87a1534a5513be7b08f0050c"
    sha256 cellar: :any,                 monterey:       "bbc0b3589957c2adbb6670335645fab8c3faadbe569dc8fedbd50bc884d6027e"
    sha256 cellar: :any,                 big_sur:        "84ad22f1eaec9772502f8261e1a3bc0bcafe38fd272e517c3739a1543ef08c84"
    sha256 cellar: :any,                 catalina:       "f4475a32bd8660322e79d429add5b379dfac24bf647607b538919df1d500766b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce937cc5e5072bd15bafae2a7db5fe26357657b10fde9bffb0e9525f21d628a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cython" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"
  depends_on "zimg"

  on_linux do
    depends_on "gcc"
  end

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
      To use \x1B[3m\x1B[1mvapoursynth.core.sub\x1B[0m, execute:
        brew install vapoursynth-sub
      To use \x1B[3m\x1B[1mvapoursynth.core.ocr\x1B[0m, execute:
        brew install vapoursynth-ocr
      To use \x1B[3m\x1B[1mvapoursynth.core.imwri\x1B[0m, execute:
        brew install vapoursynth-imwri
      To use \x1B[3m\x1B[1mvapoursynth.core.ffms2\x1B[0m, execute the following:
        brew install ffms2
        ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        \x1B[4mhttp://www.vapoursynth.com/doc/plugins.html\x1B[0m
    EOS
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
