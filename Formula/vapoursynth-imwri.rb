class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R52.tar.gz"
  sha256 "4d5dc7950f4357da695d29708bc98013bc3e0bd72fc5d697f8c91ce3c4a4b2ac"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "20b6a0b07a2e4cbb8fe60a87a839f43f466514b2c5dc9198424774edec57f7e0"
    sha256 cellar: :any, big_sur:       "11991f437ab02ddd68dec46cde3ecc78d79db72773486c4858b72151fc8c2cf3"
    sha256 cellar: :any, catalina:      "6530be1c73bf93d1ab1d52f338d36fc1a18471a8f9f779cd8b3d74bed667b08b"
    sha256 cellar: :any, mojave:        "88087c485608b4c72cf17bbc6b6be447be06e895caea683a6e1c49fae7bc61e4"
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
