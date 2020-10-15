class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.1.tar.gz"
  sha256 "297439f8859089d2248f55ab95b2a90bba35687975365385c87364c77fdb19f3"
  license "LGPL-2.1-only"
  revision 10
  head "https://github.com/mchehab/zbar.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/zbar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "1d045da2a7bd7f348a19643fa203e3bac2a41f3b4b913acf6c3dcbfd8ab451f0" => :catalina
    sha256 "9494f562f1fca7e00c461e46768f61305802facfc4127d7253d7ffa1690af485" => :mojave
    sha256 "6cc127961a7a4047fa3b10f5ffcdccbc15a26b13f43d232a18aa7e5fea131e01" => :high_sierra
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
