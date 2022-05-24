class XcbUtilKeysyms < Formula
  desc "Standard X constants and conversion to/from keycodes"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2"
  sha256 "0ef8490ff1dede52b7de533158547f8b454b241aa3e4dcca369507f66f216dd9"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69a84ccc0447bbdc514eedac2af0215a24d48311bf9c246afdd0bc8ede0ac0fd"
    sha256 cellar: :any,                 arm64_big_sur:  "dd74abb9e12be716ae5d6007a734710eb4b1974c34c14b851cf0184079b1136f"
    sha256 cellar: :any,                 monterey:       "33eedf949073b6c2cd62f03119b3a99951aa27b9c5bed62d705779c3dd8d1f37"
    sha256 cellar: :any,                 big_sur:        "702425d6d222f48788f38ab247dd84664f5a4d349484634a9f775b64045cbaca"
    sha256 cellar: :any,                 catalina:       "6ad4d1328c04a6ef44033161542d0f27f94160cb326af4572c86473e8d0cba09"
    sha256 cellar: :any,                 mojave:         "a6abcd84a8ded46e939d3551642e08a87fddb9fd8a2744071351086ddd35170c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a2fd627120ba5f0c2112dee13affe8f9fc6d4f65ca9160b2e196522181475b"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
