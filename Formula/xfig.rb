class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "895af35392b744f5bb1e836834ce28456f923c2b69f4850967c001d3f999f602"
    sha256 arm64_big_sur:  "8c3325a340d627863effb670513f067e9249e5d6a3f9f30744fd2e1034305c47"
    sha256 monterey:       "9409bd9f70bcbbe48509267a31462a64b5c97ccbd305892fccc57efd81585456"
    sha256 big_sur:        "88947e162b3798d1e715a87d3867250b94ab6372e3139b4cca3055ea901631fa"
    sha256 catalina:       "6517059167e6ce939bf2a99699cc519070cbda539074eec680d741e277a54697"
    sha256 mojave:         "3a27245c030faa4ed3648fb44b06d095eb88a4e6d38bf2bf4a50bc2d90f22ad3"
    sha256 x86_64_linux:   "2131fe0421c31080c784ab17d4e770ab69b1e840ba44a05f11b8f827d6539887"
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
