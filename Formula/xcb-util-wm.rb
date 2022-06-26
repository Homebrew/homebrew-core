class XcbUtilWm < Formula
  desc "Client and window-manager helpers for EWMH and ICCCM"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2"
  sha256 "28bf8179640eaa89276d2b0f1ce4285103d136be6c98262b6151aaee1d3c2a3f"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b59414f996c84e36251d030389af68d2e8fac7c9541c64a92cb134799f7b0aac"
    sha256 cellar: :any,                 arm64_big_sur:  "88f837cbf6f6693bc54371d9fab65f211951023bd59dddfa2f2084e831abc4a1"
    sha256 cellar: :any,                 monterey:       "5d4db73e8c3f7d3fb19d39d523a3928cbdb1527c325a38568800a67b5fedbd66"
    sha256 cellar: :any,                 big_sur:        "d63a72b6a9714c0e1d92e1d0da59fc702f1f8aa44dba75c2dcf85fb5a291908d"
    sha256 cellar: :any,                 catalina:       "77611bd19da065ae3e1053ec9b581a52e93bc8669a8efee2d06719632695815f"
    sha256 cellar: :any,                 mojave:         "1423847ca100bb773cd5f85d1766abbf9004b88e85fc92cc25a30ea23341f0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e37f4dfb651ca6cafa956da7383c9f505acc530a3ce8da886746109a4cebe6"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-wm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

  uses_from_macos "m4" => :build

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
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-ewmh")
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-icccm")
  end
end
