class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8a.tar.xz"
  sha256 "ba43c0ea85b230d3efa5a951a3239e206d0b033d044c590a56208f875f888578"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
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
