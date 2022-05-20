class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "24bc4288088c7cc01da77deda5ee0432b0b8b07f55b84a4523badf70252ba748"
    sha256 arm64_big_sur:  "60817bdb8aa8d86d4ab03c741c397e57b8ab6cd8ce0d1b194ac98f0531f252e5"
    sha256 monterey:       "cc8881a5256556cbcec044ac586eaf1cc1f20cb2f45260b9ecbce55e9e4dcce2"
    sha256 big_sur:        "642d8bea823991fc36954c5e9c9a19725b2e6b5d39009ce219d02968b307ed33"
    sha256 catalina:       "ffa7221ba94ccfe78f5004d633abf8b0196314ddf5d0288e606063082852ad6b"
    sha256 x86_64_linux:   "89bc3c77db2045536328aed602942558e497ad9baa91890066223bc282dd8f85"
  end

  depends_on "fig2dev"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxaw3d"
  depends_on "libxi"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-appdefaultdir=#{etc}/X11/app-defaults
    ]

    system "./configure", *args
    # "LDFLAGS" argument can be deleted the next release after 3.2.8a. See discussion at
    # https://sourceforge.net/p/mcj/discussion/general/thread/36ff8854e8/#fa9d.
    system "make", "LDFLAGS=-ltiff -ljpeg -lpng", "install-strip"
  end

  test do
    assert_equal "Xfig #{version}", shell_output("#{bin}/xfig -V 2>&1").strip
  end
end
