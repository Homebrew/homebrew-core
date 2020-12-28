class XcbUtilImage < Formula
  desc "XCB port of Xlib's XImage and XShmImage"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2"
  sha256 "2db96a37d78831d643538dd1b595d7d712e04bdccf8896a5e18ce0f398ea2ffc"
  license "X11"

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-image.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "be6e0bdd4cd0ddde48bca0e424da9661ca5ecfa6f64f8184e88f1df4e44186f2" => :big_sur
    sha256 "d6d1fa4758e6e7f5cb8a2d738259cd63d8f5e165ca9dc0731e4fc74198948a06" => :arm64_big_sur
    sha256 "556a8960b5ee6b2290eb223df2dda18054b113b3284b91c4d10cdc3f905ef75c" => :catalina
    sha256 "3aeb055928e61fddb3473ea17005774aa6f0b0f32af8323f3da8963d836c7baf" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"
  depends_on "xcb-util"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-image")
  end
end
