class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://linuxtv.org/downloads/zbar/"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.93.tar.bz2"
  sha256 "83be8f85fc7c288fd91f98d52fc55db7eedbddcf10a83d9221d7034636683fa0"
  license "LGPL-2.1-only"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?zbar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b9b91bc4b8cf90973914291cd2c8a2c6d674188fb2e1129c6d3f162822ad7430"
    sha256 arm64_sequoia: "a664b0c509afcc382dedc4c7a4e76f5d0177b8f0ab02f2d6ca89dd058b707430"
    sha256 arm64_sonoma:  "f33f0c3e2046ecca88f96066a3e5fcd3a1c7d3d4f0acfc18bb98cb2dce51a70a"
    sha256 sonoma:        "0b393b4b6aa6a645c82403834a89b5fe55a083fa34e946e9b4100f60da0fb212"
    sha256 arm64_linux:   "26598780ca5835279c251ba7621eec3862b12e4c65c4e15a23c7d69545bd376a"
    sha256 x86_64_linux:  "dfcb2b10e388d041fc4259db2d2fa4202a6eb8211acf5d6095a6e3e0d4fdf93f"
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
