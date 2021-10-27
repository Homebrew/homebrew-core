class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://github.com/mchehab/zbar/archive/0.23.90.tar.gz"
  sha256 "25fdd6726d5c4c6f95c95d37591bfbb2dde63d13d0b10cb1350923ea8b11963b"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/mchehab/zbar.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "a8c52a7dede836b5ec86f3a7ef42463b684a0d6882e898e810424004b5440ffe"
    sha256 arm64_big_sur:  "baa3cd1c3c1f3942f21809ce8da4135007a447a5c00162962fe7ed2a86eb3221"
    sha256 monterey:       "56ff6ecef94a14d19f42acb9077d3a48a9b34aa2dae7d84a22a2df8eb65d770e"
    sha256 big_sur:        "4bdea261367d272a41f9546056eb9b6ba65f1d88fbbeb07fbea7f2ac8da225bb"
    sha256 catalina:       "e49e72eb04239895bbd43b085c03f24ddf86288530d1d7afedbd933fee8b172f"
    sha256 mojave:         "cb9d3b6678c961ae919859751707682658a1cb40b268d329ace6c64e3dbb9c12"
    sha256 x86_64_linux:   "7f6956b81e35c47342447c03fc27ee441d9babb705e4ce9832a0418d6275310e"
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
