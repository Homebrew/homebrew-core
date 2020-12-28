class XcbUtilKeysyms < Formula
  desc "Standard X constants and conversion to/from keycodes"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2"
  sha256 "0ef8490ff1dede52b7de533158547f8b454b241aa3e4dcca369507f66f216dd9"
  license "X11"

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "702425d6d222f48788f38ab247dd84664f5a4d349484634a9f775b64045cbaca" => :big_sur
    sha256 "dd74abb9e12be716ae5d6007a734710eb4b1974c34c14b851cf0184079b1136f" => :arm64_big_sur
    sha256 "6ad4d1328c04a6ef44033161542d0f27f94160cb326af4572c86473e8d0cba09" => :catalina
    sha256 "a6abcd84a8ded46e939d3551642e08a87fddb9fd8a2744071351086ddd35170c" => :mojave
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libxcb"

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
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-keysyms")
  end
end
