class XcbUtilWm < Formula
  desc "Client and window-manager helpers for EWMH and ICCCM"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.gz"
  sha256 "dcecaaa535802fd57c84cceeff50c64efe7f2326bf752e16d2b77945649c8cd7"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e8b4f5a806743173240d8259ac7f8ac502e945df8f9269aa40d5f35fc2140291"
    sha256 cellar: :any,                 arm64_monterey: "1774d0e39c97fc328e73411c8ad083d1bc0592576c427c2f6cea4ae9f1f7ba1b"
    sha256 cellar: :any,                 arm64_big_sur:  "92ea8e6f41fca2b1bf1a4e25783a0c1cf45e93f3ce99e4bffa078f9ef54b81d4"
    sha256 cellar: :any,                 ventura:        "7526c01904f1a9a658e1ec38f1ecc3d20c14e8a164e5ce891fe9f0b5df5d93d4"
    sha256 cellar: :any,                 monterey:       "a6cd012acf4ff3199b3866e93c3b930e399f33eea2a5e49220f4214c31e8d15f"
    sha256 cellar: :any,                 big_sur:        "7bad0c4c7883daaba35df770a5a544d935d6531292c02a6df2c956ef3e8a2b42"
    sha256 cellar: :any,                 catalina:       "aa6fc4ef555883fac180c46b4e6d5e03096bd9369640fbe8f6ec8fa9f63c70c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1045d2418ab117484c0645ced40c1c7dfe9751443b56e1fdff639a2591732acb"
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
