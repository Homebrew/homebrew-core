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
    sha256 arm64_ventura:  "a556e1d3761eef86b007225b17c1e2e3bd3d8f5c0586c96b9db95261012623e5"
    sha256 arm64_monterey: "ecb4a7174906195486f0f9badabc2e5affd732022fc9e3b832c1b7a462a3e203"
    sha256 arm64_big_sur:  "2e7a16f085ca08bd70c1ab3b8d88683281ea51481c3f1c26402c2b59f949fa6d"
    sha256 ventura:        "8349004627c6741ecc50f1e9410be7ac4149ec7ad326c2c8e6896f23986d2f70"
    sha256 monterey:       "853aa15556c0ccd130dd35074cfd67840720583d3e8564f7c9c1fee101c5d9ac"
    sha256 big_sur:        "3b8169dcfeaed1f704084073f93c619510c415b37454d1a0858d5bd689b89911"
    sha256 x86_64_linux:   "ef7a2cf8345087907b68a3ba10874aca3bcc9a8f8f3bafcd30dc8df4c5255fab"
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
