class VapoursynthImwri < Formula
  desc "VapourSynth filters - ImageMagick HDRI writer/reader"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R46.tar.gz"
  sha256 "e0b6e538cc54a021935e89a88c5fdae23c018873413501785c80b343c455fe7f"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "4b74c31f8c292a7151a85a8bcfcd187ab78c5e29dcae3b953a57bd4658c24727" => :mojave
    sha256 "9f3984dc4b3fc382a9cadbced0676b975035807f3c4bfc945bc2aa353e08bc10" => :high_sierra
    sha256 "429d80c42d846d6693148d2354e50bcc1ec86b8466a69f531a4f37fd8fc7d7f2" => :sierra
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
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "from vapoursynth import core; core.imwri"
  end
end
