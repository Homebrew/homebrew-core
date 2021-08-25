class Xfig < Formula
  desc "Facility for interactive generation of figures"
  homepage "https://mcj.sourceforge.io"
  url "https://downloads.sourceforge.net/mcj/xfig-3.2.8b.tar.xz"
  sha256 "b2cc8181cfb356f6b75cc28771970447f69aba1d728a2dac0e0bcf1aea7acd3a"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/xfig[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "b5b1cb44d874b54803d40a74d3dfed853f84fd9aef25fb592405c4baf85b70a0"
    sha256 big_sur:       "d7c37dccd5e37725dedb44b09e35b58012032c9363d45237434cb7195df477c8"
    sha256 catalina:      "8bb1ae517dc9f6b845b5fa991f6264d94396e24410f387579e7fc89cd3210559"
    sha256 mojave:        "7dda7fca1b9524128292409321f7a1614faabff17cc02c62bbc351cac8f45969"
    sha256 x86_64_linux:  "dcfffe75f2f42a482f9b37c6d6e76b588da469b3118a37382046d83ddd303bdf"
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
