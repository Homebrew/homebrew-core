class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.00/suite3270-4.0ga12-src.tgz"
  sha256 "d2e5030b67f01aed7c74dd906114d44dbc89a103d32ed0db564bf80033b8e4fb"
  license "BSD-3-Clause"

  livecheck do
    url "http://x3270.bgp.nu/download.html"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 "1207876192b9bd7bcf06c7811cb376426e47028027a47718dc32224972352e80" => :catalina
    sha256 "d2d31ed1a62515d6acd00b2d3fa72a821b1d94bb13b581830e30664fe72f2626" => :mojave
    sha256 "c68394dce8fc34be49786ebfd1c0beb914b1f894611fc97163ca5a3097967151" => :high_sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
