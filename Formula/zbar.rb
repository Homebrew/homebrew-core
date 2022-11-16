class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://github.com/mchehab/zbar"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.90.tar.bz2"
  sha256 "9152c8fb302b3891e1cb9cc719883d2f4ccd2483e3430783a2cf2d93bd5901ad"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "82553f77ff4df652edf3c86b6b1e784eff6c20e6c296e581fb3be34c0572ab52"
    sha256 arm64_big_sur:  "338cc6e620aeed45382c97260f899e9f6ebe1260ff1e7fef6ef2392d938d516e"
    sha256 monterey:       "2683cf24b3435982d30041c0e3aca33d48a418e2b60085aca75d081fec5cfc38"
    sha256 big_sur:        "d2b9c6deb05916f73dffcf4f637160a96b82fa1ea67e5c188e34ff419768d798"
    sha256 catalina:       "f203dccfd3b1fdfa91c844a7e8cedab935a2e97b8527329f00f6816f1e32ff73"
    sha256 x86_64_linux:   "085302f322670cb77040a77645e1972ea14e8e6bc1f6e9ee3e010d53d48dbdd3"
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
