class Xnec2c < Formula
  desc "Multi-threaded EM tool based on NEC2 to model antenna radiation patterns"
  homepage "https://www.xnec2c.org/"
  url "https://www.xnec2c.org/releases/xnec2c-v4.4.18.tar.gz"
  sha256 "0e1b05dddee94854c32955b8189a7f0a9e0281c7f5888dc96c1a154a882f1116"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.xnec2c.org/releases/"
    regex(/href=.*?xnec2c[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "autoconf"
  depends_on "automake"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libtool"
  depends_on "pkgconf"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-opengl", *std_configure_args
    system "make"
    system "make", "install"
    system "make", "desktop-install"
  end

  test do
    system bin/"xnec2c", "-h"
  end
end
