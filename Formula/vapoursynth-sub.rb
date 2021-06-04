class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R53.tar.gz"
  sha256 "78e2c5311b2572349ff7fec2e16311e9e4f6acdda78673872206ab660eadf7c8"
  license "ISC"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8997efb28016a3897f6d87b25593e85e4ce18564e02887ecb61470e297ad19d4"
    sha256 cellar: :any, big_sur:       "20ec986d2fccfbf6e5a16d52b9bf068ede8344a37aec6009bb458d1cf35bf7af"
    sha256 cellar: :any, catalina:      "2d7635e1c0b355df9246e4cf6a6c3184172cbbb0987f4435a25ca4c1f6b9b6e1"
    sha256 cellar: :any, mojave:        "066237ae4b3f714be5120d491364c08aeced42026c472af7b2fcb5a50f144b4f"
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
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.sub"
  end
end
