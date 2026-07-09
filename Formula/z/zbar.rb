class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://linuxtv.org/downloads/zbar/"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.93.tar.bz2"
  sha256 "83be8f85fc7c288fd91f98d52fc55db7eedbddcf10a83d9221d7034636683fa0"
  license "LGPL-2.1-only"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?zbar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6f892b836c661d5946ab901d59995a422362d1cc262c461331585111d2807f92"
    sha256 arm64_sequoia: "159d9b6c58c9345e93556037a91a1013c5a7e5715f490a2cb73c20102da60dc8"
    sha256 arm64_sonoma:  "4282aa738dc1b13c39b37b4648e1bb7d5b563c37348b757b992201c4fcf1f476"
    sha256 sonoma:        "30bf0f173b8cecaaadfc4b8cbbdfcb5e920124a9bfb7543b5a377818fbb1456e"
    sha256 arm64_linux:   "3693e397645ab937b754f5d829107da689638043f5446c0ff35b91c880edd304"
    sha256 x86_64_linux:  "c7df27b5cbd790ed7182c56fe4544a451a2afbd4df71eb764cdcdde5d0b7ed28"
  end

  head do
    url "https://github.com/mchehab/zbar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # zbar uses gettext but upstream only links libintl on Windows, and the
    # newer macOS linker no longer resolves it transitively. Link it explicitly.
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

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
