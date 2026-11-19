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

  depends_on "at-spi2-core"
  depends_on "autoconf"
  depends_on "automake"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "libtool"
  depends_on "pango"
  depends_on "pkgconf"

  deny_network_access!

  def install
    system "./autogen.sh"
    if OS.mac?
      system "./configure", "--disable-opengl", *std_configure_args
    elsif OS.linux?
      system "./configure", *std_configure_args
    end
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"dipole.nec").write <<~EOF
      CM Half-wave dipole for 146 MHz (2m band) in free space
      CE
      GW 1 21 0.0 -0.485 0.0 0.0 0.485 0.0 0.001
      GE 0
      EX 0 1 11 0 1.0 0.0
      FR 0 21 0 0 140.0 0.6
      RP 0 37 73 1000 0.0 0.0 5.0 5.0
      EN
    EOF
    system bin/"xnec2c", "-i", "dipole.nec", "--write-csv", "dipole.out", "-b"
    assert_path_exists testpath/"dipole.out"
  end
end
