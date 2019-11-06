class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R47.2.tar.gz"
  sha256 "8ce4553f9fc5e5bbfb26ec9c0c5bf94be307530f947424c713ef67bc8a6d22b2"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "2361af01402dbcd098a20978aefed8e4d497c9d29d2554060e05bb88751b4955" => :catalina
    sha256 "494bd78b57291fb751aace8971a2a6fe1995a51df4835adbbd7a3d20e96eb839" => :mojave
    sha256 "6ef2db3d5d777a0fdeb8d4decfdefcaf9bac4a730ccab1153503f9df69f77678" => :high_sierra
    sha256 "543950a6ccd90c2e87085c03ca8bfa80b3b247ab89cddfec286a892ce669aa6b" => :sierra
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
