class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.90.tar.gz"
  sha256 "25fdd6726d5c4c6f95c95d37591bfbb2dde63d13d0b10cb1350923ea8b11963b"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mchehab/zbar.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "da7a7d53d15640ef06f7479abdd322e2a5efeebf3947d8a818fc1184f2367797"
    sha256 big_sur:       "7d99550adb7819400686e8d43cddc41bcc8b16281571b76028b0621b8458b07f"
    sha256 catalina:      "edf2bd674be776af3ee0be04f9ad86365413ba57afc513ef51eab4eb88f73743"
    sha256 mojave:        "8e6433e54110979d17f47332faf44881822e1c31bb1a6cc012c6c10a86e84842"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libtool"
  depends_on "ufraw"
  depends_on "xz"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "autoreconf", "-fvi"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python
      --without-qt
      --disable-video
      --without-gtk
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
