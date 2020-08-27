class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.1.tar.gz"
  sha256 "297439f8859089d2248f55ab95b2a90bba35687975365385c87364c77fdb19f3"
  license "LGPL-2.1-only"
  revision 10
  head "https://github.com/mchehab/zbar.git"

  bottle do
    cellar :any
    sha256 "43b41e062704914a007017d7d35dfb518f6c04141a52eb2c146a5e908a75334c" => :high_sierra
    sha256 "64d9816afc8e6fd898c402f152a9847b4e265da078cf27fa6b1fb289ec3d963c" => :sierra
    sha256 "8a6c2c77063e98986a8b6d6a5eb19333cd39efccb03af08493d6b5e8a60d57b7" => :el_capitan
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
