class XcbUtilImage < Formula
  desc "XCB port of Xlib's XImage and XShmImage"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2"
  sha256 "2db96a37d78831d643538dd1b595d7d712e04bdccf8896a5e18ce0f398ea2ffc"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "781bc1666bfdcbb20db4ed78d805853806139b483b7c79b17d1318ebce3b0174"
    sha256 cellar: :any,                 arm64_big_sur:  "d6d1fa4758e6e7f5cb8a2d738259cd63d8f5e165ca9dc0731e4fc74198948a06"
    sha256 cellar: :any,                 monterey:       "b3d4fd8cd60922f641fb36ddf5039e6140300eeb2acfb2c4e18f389643058ba0"
    sha256 cellar: :any,                 big_sur:        "be6e0bdd4cd0ddde48bca0e424da9661ca5ecfa6f64f8184e88f1df4e44186f2"
    sha256 cellar: :any,                 catalina:       "556a8960b5ee6b2290eb223df2dda18054b113b3284b91c4d10cdc3f905ef75c"
    sha256 cellar: :any,                 mojave:         "3aeb055928e61fddb3473ea17005774aa6f0b0f32af8323f3da8963d836c7baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257c444348495e9fe4832ef14d7c800888981be7bb39929ade0cfe18ce5f45c8"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-image.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
