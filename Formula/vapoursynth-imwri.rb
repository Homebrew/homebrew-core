class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R54.tar.gz"
  sha256 "ad0c446adcb3877c253dc8c1372a053ad35022bcf42600889b927d2797c5330b"
  license "LGPL-2.1-or-later"
  head "https://github.com/vapoursynth/vapoursynth.git"

  livecheck do
    formula "vapoursynth"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5836132cd53eaa1767021d26597b1cfd3108f342abe0cad7f1ce40dd3fb6511d"
    sha256 cellar: :any, big_sur:       "01ffc95970768ce9c4b3197a0f60c51083299c44e8a46e596e85c31dc98c07a9"
    sha256 cellar: :any, catalina:      "2b0b833b8f808b3748249dc12a94a82394b5b4cd0ab4cbf4d2b092e491bf8b9f"
    sha256 cellar: :any, mojave:        "0bb81d8870a76270aff989d487896f0d651f7e13739c5598e9be9e9aa6cc633a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-core",
                          "--disable-vsscript",
                          "--disable-plugins",
                          "--enable-imwri"
    system "make", "install"
    rm prefix/"vapoursynth/libimwri.la"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/libimwri.dylib" => "libimwri.dylib"
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
