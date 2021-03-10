class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.90.tar.gz"
  sha256 "25fdd6726d5c4c6f95c95d37591bfbb2dde63d13d0b10cb1350923ea8b11963b"
  license "LGPL-2.1-only"
  head "https://github.com/mchehab/zbar.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "6326e5663dc3ff4a15d2b1da61280f58878a7340990e065c5c3ac020046951b2"
    sha256 big_sur:       "f331d1b54eeabaa2fac58568eb5eb75dbc1958cfa30898cf2270ea4847c1e96b"
    sha256 catalina:      "b55d61b6b252c0591ca14881ea2cd8d2e008fdd1be0822be2c18a9d7c537230b"
    sha256 mojave:        "60a4c4fe9de4b65381c4a69e7bbf469ebc8a5c13f0581ba8dbbe2262218b235f"
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
