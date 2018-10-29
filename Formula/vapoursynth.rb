class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R44.tar.gz"
  sha256 "3459aa903c42b2f87a634ee705fcc3dd251729bd179e8ab4684a50bd7415930a"
  revision 1
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
