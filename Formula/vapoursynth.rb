class Vapoursynth < Formula
  include Language::Python::Virtualenv

  desc "Video processing framework with simplicity in mind"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R33.1.tar.gz"
  sha256 "8c448e67bccbb56af96ed0e6ba65f0ec60bc33482efd0534f5b4614fb8920494"
  revision 1

  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    sha256 "39a5933621f0656e858ba8352088f819bd9b4f4a048936caae682f39a19b0da7" => :sierra
    sha256 "3c7f28c274b0ba202f0f2a455c689621fa847d04af3ca5f1ada3fa7480f4cf19" => :el_capitan
    sha256 "e452d48c3a5fae1d64ac1ef210bbf779c13df47126573f142fa2481ad2c5ac9c" => :yosemite
    sha256 "8a019dc33d5697b8a57248be2996ac255fc4d21e3ba7c90c956f7806bf0b570f" => :mavericks
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
