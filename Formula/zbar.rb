class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.90.tar.bz2"
  sha256 "9152c8fb302b3891e1cb9cc719883d2f4ccd2483e3430783a2cf2d93bd5901ad"
  license "LGPL-2.1-only"
  revision 4

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "8e47931ef4322523fbcd9ed08a53774ebba3bb778609cac5e1f7be32d44c37a0"
    sha256 arm64_monterey: "071cf2dd5834b5aa37d64720e4225f0147be2ffd26ac5d12810eff69e01023b9"
    sha256 arm64_big_sur:  "d05d32d19ebed228a56c77ff4b96a28191061d3b368955310693bf9cfea668de"
    sha256 ventura:        "994bde16e7eb7479fe5f467c88d635fddc43493ac9ff834cf178a5f34019a2fa"
    sha256 monterey:       "a549684b74c2b6b5baa7d8b572035b1e30ea6c13d3d5e314bbbeeec06207b555"
    sha256 big_sur:        "854f0c484c327120712dcc4d92de26167b82f988db8da4a95ed2403f324a0fc7"
    sha256 x86_64_linux:   "9d2bd79a442b04a651f35d2b6e77c3668fafdea6ff59edc6036d3e74b472a990"
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

  on_linux do
    depends_on "dbus"
  end

  fails_with gcc: "5" # imagemagick is built with GCC

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-video",
                          "--without-python",
                          "--without-qt",
                          "--without-gtk",
                          "--without-x"
    system "make", "install"
  end

  test do
    system bin/"zbarimg", "-h"
  end
end
