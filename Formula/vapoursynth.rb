class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R45.1.tar.gz"
  sha256 "4f43e5bb8c4817fdebe572d82febe4abac892918c54e1cb71aa6f6eb3677a877"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "ab5725784f593a595d27ce8e4f573f77a11aa445e4699481bdc553878062a0a1" => :mojave
    sha256 "69876fa097e3ee3083239149ff38b64877c6a1f2a9a2bc4a30e2ab52369ff4fa" => :high_sierra
    sha256 "2e07dccdb76f05238b238388b87a9adb8cca291c8cfbf79f99fb10cdb1a97f8b" => :sierra
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
    url "https://files.pythonhosted.org/packages/f0/66/6309291b19b498b672817bd237caec787d1b18013ee659f17b1ec5844887/Cython-0.29.tar.gz"
    sha256 "94916d1ede67682638d3cc0feb10648ff14dc51fb7a7f147f4fedce78eaaea97"
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
