class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R68.tar.gz"
  sha256 "3bd787f7d1e5feb9e57861b6b9a4646b88300e26a3b9302fe21c6102b1f193f0"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6af7f3246a37d2f88c11c498b7e93fab25066d1bfd4f131d3a5b779f57b06cdd"
    sha256 cellar: :any,                 arm64_ventura:  "98705aeafbbd18332d2e67a3326791392989919c9f8b6f512853280c5b5fea7d"
    sha256 cellar: :any,                 arm64_monterey: "e5b86c9886666ee3a244a478c707f86a3e66e6f615608efa3cb0fce2707faaea"
    sha256 cellar: :any,                 sonoma:         "429fce3b48d45ed3007819ff9bf5fe1210ab2965001af4e2d83b76c9879b9314"
    sha256 cellar: :any,                 ventura:        "985347586afc1a76ae4bebf3fe59b573174a3cbb089af62f36a7d40d9ca72947"
    sha256 cellar: :any,                 monterey:       "37623c6c1c173419fbbe14c90f5da3fde6918b87314c84e7041a499307ac7600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438c4ec1f03fb63fddebd4a2cc7f1a530f91f8406a98f87a1f2919897038ad99"
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
