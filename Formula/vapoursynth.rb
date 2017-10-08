class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R39.tar.gz"
  sha256 "792a0002c71a7fc9d1d366df8d463f0b9918df4f871e4ab9a87120163a44c5c7"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "4bf55e943468c6c4762ec465c967e45eee7f9a11cab3d80531e99984cc2f3f41" => :high_sierra
    sha256 "2f4e594a69fc13a455b2e1fd4f0dbce3a4af71d58cd52758f648c2b0bb7d9e84" => :sierra
    sha256 "70cb07c8f48ceec36ece8e3505bb540cc79847e36c37ae07edefa008a4297351" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "nasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/10/32/21873ff231e069f860098b1602bb9e3ae2806d2f73ba661b5d806f200243/Cython-0.27.1.tar.gz"
    sha256 "e6840a2ba2704f4ffb40e454c36f73aeb440a4005453ee8d7ff6a00d812ba176"
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
