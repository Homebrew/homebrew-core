class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://zbar.sourceforge.io"

  stable do
    url "https://www.linuxtv.org/downloads/zbar/zbar-0.20.1.tar.bz2"
    sha256 "a0081a9b473d9e44e029d948a8d7f22deb1bf128980f3fc4e185298066e62a6c"
  end

  bottle do
    cellar :any
    sha256 "43b41e062704914a007017d7d35dfb518f6c04141a52eb2c146a5e908a75334c" => :high_sierra
    sha256 "64d9816afc8e6fd898c402f152a9847b4e265da078cf27fa6b1fb289ec3d963c" => :sierra
    sha256 "8a6c2c77063e98986a8b6d6a5eb19333cd39efccb03af08493d6b5e8a60d57b7" => :el_capitan
  end

  head do
    url "https://git.linuxtv.org/zbar.git"
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  depends_on :x11 => :optional
  depends_on "jpeg"
  depends_on "graphicsmagick"
  depends_on "ufraw"
  depends_on "xz"
  depends_on "freetype"
  depends_on "libtool"

  def install
    gettext = Formula["gettext"]
    system "autoreconf", "-fvi", "-I", "#{gettext.opt_share}/aclocal"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-python2
      --without-qt
      --disable-video
      --without-gtk
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
