class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8a.tar.xz"
  sha256 "ba43c0ea85b230d3efa5a951a3239e206d0b033d044c590a56208f875f888578"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "6a43d6e59266c06db6e95d612731dce290baca35ccdc885411ff01224c0dc6b2"
    sha256 big_sur:       "2f87098117a52ae19f9260f6d0a8413378eb790ced684221dc190a36f7c919a2"
    sha256 catalina:      "011b226be3e0e49599871b19cb8528a168cb91d5b37557eb6856f7e9d20f3506"
    sha256 mojave:        "70d31a321c35921fb64a15a0634b6159d4918498d5a2b743659635e3067bfb9a"
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
