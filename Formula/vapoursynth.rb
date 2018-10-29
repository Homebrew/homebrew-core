class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R44.tar.gz"
  sha256 "3459aa903c42b2f87a634ee705fcc3dd251729bd179e8ab4684a50bd7415930a"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "b16e68ed8a05dd20c443f95b79fc6caf649e95e29686ac15c0716a5411ad1f09" => :mojave
    sha256 "c4f984494fea9c1223ee805a4df586c65329e77b4f27b7c73c917262a30159da" => :high_sierra
    sha256 "622b59439336763b728fca6ffcdf07f256d0afa86ab1eec7261611f83824739a" => :sierra
    sha256 "ffca8c514999e2d72fc925c9be4a17fa342f579cbab80e7ad772fa92da0e0156" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python"
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/d2/12/8ef44cede251b93322e8503fd6e1b25a0249fa498bebec191a5a06adbe51/Cython-0.28.4.tar.gz"
    sha256 "76ac2b08d3d956d77b574bb43cbf1d37bd58b9d50c04ba281303e695854ebc46"
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
