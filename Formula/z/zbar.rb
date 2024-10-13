class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.93.tar.bz2"
  sha256 "83be8f85fc7c288fd91f98d52fc55db7eedbddcf10a83d9221d7034636683fa0"
  license "LGPL-2.1-only"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "d75d246b7e2aafd6bd913171bd443a474616c47d73b3c7364d5c2d227161aee9"
    sha256 arm64_sonoma:   "23bfbc0c9ae6d16727058825feb8147bb7384cd4307fb6f4642ff94c9cf99c13"
    sha256 arm64_ventura:  "6d791bf71b217d0c7558f7becd6b38fcd6d3721002dd164bf01a23a356225259"
    sha256 arm64_monterey: "c7f601f54d7c8609406cb2e1fcbbb4abd8321b58849c64ba5622a6b8ac68a850"
    sha256 sonoma:         "bd76b39f1dc8bf551d535759fa3f86e9de3266a26939a42bca82cf9270ce3d87"
    sha256 ventura:        "fd8701195bca0fbbaab5c5c28b06b93f79d3efb3f60a8a45ff927c95ba8f8e29"
    sha256 monterey:       "b262f392f862ff8f4ba5808c70f77f2b857a95f392e8d2bad9e0c670b329e519"
    sha256 x86_64_linux:   "b3f1842dfca655978646c83cdf8e58163ee2a3e5d1a9926314b5c8102817d528"
  end

  head do
    url "https://github.com/mchehab/zbar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "dbus"
  end

  fails_with gcc: "5" # imagemagick is built with GCC

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--disable-video",
                          "--without-python",
                          "--without-qt",
                          "--without-gtk",
                          "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
