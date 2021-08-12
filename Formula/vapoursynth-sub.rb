class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R54.tar.gz"
  sha256 "ad0c446adcb3877c253dc8c1372a053ad35022bcf42600889b927d2797c5330b"
  license "ISC"
  head "https://github.com/vapoursynth/vapoursynth.git"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e00dd437364121c4633ac304e1494bffa20a9fad1e4f4fee4de3cd16015a17f2"
    sha256 cellar: :any, big_sur:       "40eda0329ae57f8deaac051521a8ee8f1fe6f5106db3ef024f2fce9ce3432f09"
    sha256 cellar: :any, catalina:      "29204e101abc88a961a53518abc868c67af788b1369e3fc07e8df439442859d7"
    sha256 cellar: :any, mojave:        "291ec2fad5ccca0b0046b29a2bcb842a700e8395d106747058faf60032735cd4"
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
