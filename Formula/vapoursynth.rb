class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R42.1.tar.gz"
  sha256 "2da653c3956d6e61b2232975ebad7e060c717ad09b08d09694e4bb4eab64f8a7"
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "12c12030adeff25ce2ac59e2d5b531ae6759bd27f2b44d39b8ae0fb1d73bdcaa" => :high_sierra
    sha256 "2d850df6fea69c4c121b89dc13e7223199e55db4e8dba6b52359f0c4af382a91" => :sierra
    sha256 "c7886f8f63f687d9b400df11134d2c34414619b68e113721b2ea56c4ddd79bab" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "nasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on "python3"
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
