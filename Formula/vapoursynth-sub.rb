class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R46.tar.gz"
  sha256 "e0b6e538cc54a021935e89a88c5fdae23c018873413501785c80b343c455fe7f"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "3f18667ff79b4320548cbbd584b5ea37493fd819e1946f83e48aaad8649e406f" => :mojave
    sha256 "4dc5ed3a87f9eb830fabcbb45a13857ac90db6efcd6de33159c6c98e656b349a" => :high_sierra
    sha256 "a2f0a16cbfd13c6852afcb7602b60f15e849db51782ffc7aad46255903ed43c6" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-core",
                          "--disable-vsscript",
                          "--disable-plugins",
                          "--enable-subtext"
    system "make", "install"
    rm prefix/"vapoursynth/libsubtext.la"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/libsubtext.dylib" => "libsubtext.dylib"
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "from vapoursynth import core; core.sub"
  end
end
