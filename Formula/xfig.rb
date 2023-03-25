class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "6370dff6e8be68d328e7d435b42eb5eb9100646e9507ecd04a0e3f21234df3f1"
    sha256 arm64_monterey: "abc67f4c87043170e4af0cc4ccca8ab6b0d21e1f0a046a90c49a485ed64ca63c"
    sha256 arm64_big_sur:  "415522b532fe5c1b34a271d737a37f6a2421313a9fd88ba51d05959c40e096df"
    sha256 ventura:        "c3154a3b6da96286c2467d46820874c74dd552231782e31ba7b3af095187d11e"
    sha256 monterey:       "4f5aa07456b8655ad92e75c76e5f6cf1df478c4fb534ddf8e7a34e5a1ca15998"
    sha256 big_sur:        "a5934bd641f906aa2d69cf5fdaa136f274f8fefd8513a7dafe531c0a2903200a"
    sha256 x86_64_linux:   "24b447641abd85c52a518a997da468f32aaae3b40401f10577e1240abf84d8d5"
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxi"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--with-appdefaultdir=#{etc}/X11/app-defaults",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install-strip"
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
  end
end
