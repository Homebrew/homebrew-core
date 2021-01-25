class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.1.tar.gz"
  sha256 "297439f8859089d2248f55ab95b2a90bba35687975365385c87364c77fdb19f3"
  license "LGPL-2.1-only"
  revision 11
  head "https://github.com/mchehab/zbar.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "0107f9d5bba2e9585acf35c4df3885e3310828c7665526521a9f84fd79ad38a3" => :big_sur
    sha256 "b533efe9ea7470c01bb2f7dc02b52349df82030748f92cfd96bdd1d422af9c70" => :arm64_big_sur
    sha256 "24145f43665e55e719161c6cae3fe23be591912bff2343f07f8eec88ee0b9760" => :catalina
    sha256 "8aa8edbbdd7ba716f74986a67f0b33eb369fe0f06a4ae20aee3b7383498fcd72" => :mojave
    sha256 "401610f57821c4f6ce548695a4736750cced275cc6fc51978adb89f17903d1fd" => :high_sierra
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
