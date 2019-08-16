class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.2.tar.gz"
  sha256 "8ce4553f9fc5e5bbfb26ec9c0c5bf94be307530f947424c713ef67bc8a6d22b2"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "e3812411db7d24289712a92a1331301050d8e6e0dd98bcf7c4d76c877b586868" => :mojave
    sha256 "f2d2c515196ed550dc2b804091ce43ac4d365e85931b0bb5a385d43ba44a824f" => :high_sierra
    sha256 "6e21cc9a74b07b1afca8c1f35b3293f51127bb1cfd255dd112bb664f41475b94" => :sierra
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
