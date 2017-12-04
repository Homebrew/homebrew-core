class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R40.tar.gz"
  sha256 "a5e4260abff95c4bf33cc7ff3203e8001f7b3be7bb5ccc3a6fc2b18523823e50"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "09ca14a45e20eab587488ac63dfc2f33140518fdf65f2ed594f361971f1ce854" => :high_sierra
    sha256 "f62b157f6bacfb55141b9813da133f912cdb8f75392f7bfaecab82764e136627" => :sierra
    sha256 "7694080f35dd4a719f677da865d0e4f8b73e74009a8ed9554828b3e7304dae5f" => :el_capitan
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
