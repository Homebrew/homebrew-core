class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R43.tar.gz"
  sha256 "5c80d583f6891f4f5840edf09bc207c2e71653786b07606fdb4a164fd67470c2"
  revision 2
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "b23db8a9a99c0f57bda6d79641197289c4c38d66cb8fcae65d9608805dc065d4" => :high_sierra
    sha256 "beb2305bd55ea4117ca94ee9e7a823e0890ced4521cf9aedd8b14aa8e6d55817" => :sierra
    sha256 "2ad952f93a073f73859a87cee182357f3b53d09bcc3349c47dbe896fc14c7e6c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "nasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python"
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/ee/2a/c4d2cdd19c84c32d978d18e9355d1ba9982a383de87d0fcb5928553d37f4/Cython-0.27.3.tar.gz"
    sha256 "6a00512de1f2e3ce66ba35c5420babaef1fe2d9c43a8faab4080b0dbcc26bc64"
  end

  def install
    venv = virtualenv_create(buildpath/"cython", "python3")
    venv.pip_install "Cython"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-cython=#{buildpath}/cython/bin/cython"
    system "make", "install"
  end

  test do
    py3 = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{py3}/site-packages"
    system "python3", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
