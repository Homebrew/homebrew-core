class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R33.1.tar.gz"
  sha256 "8c448e67bccbb56af96ed0e6ba65f0ec60bc33482efd0534f5b4614fb8920494"
  revision 1

  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "17dc89e8795e08b1c58f7c1e08e53e35d02317e0942faa6d792704ac4eb8f2e2" => :sierra
    sha256 "90102da063f6d7f9c1dba45c8fc59cf646e4f17a6034c199d16da507db37357d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "libass"
  depends_on :macos => :el_capitan # due to zimg dependency
  depends_on :python3
  depends_on "tesseract"
  depends_on "zimg"

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/c6/fe/97319581905de40f1be7015a0ea1bd336a756f6249914b148a17eefa75dc/Cython-0.24.1.tar.gz"
    sha256 "84808fda00508757928e1feadcf41c9f78e9a9b7167b6649ab0933b76f75e7b9"
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
    system bin/"vspipe", "--version"
    system "python3", "-c", "import vapoursynth"
  end
end
