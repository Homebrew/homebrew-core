class XcbUtilWm < Formula
  desc "Client and window-manager helpers for EWMH and ICCCM"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.gz"
  sha256 "dcecaaa535802fd57c84cceeff50c64efe7f2326bf752e16d2b77945649c8cd7"
  license "X11"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e0dff8d281d331ac4088b195cef01ccd933f8f6c655452e3825c0a18f7be97fa"
    sha256 cellar: :any,                 arm64_sequoia:  "78b8c05d6a387da472f24f9b4fa8a60eb3c1815a2b013a5cd9c379d54362f058"
    sha256 cellar: :any,                 arm64_sonoma:   "f2e885b4eefb54d3e9b5f2d4a8dbf4fd93141e8b3c12fbcaa99b318a3dfdad1e"
    sha256 cellar: :any,                 arm64_ventura:  "e8b4f5a806743173240d8259ac7f8ac502e945df8f9269aa40d5f35fc2140291"
    sha256 cellar: :any,                 arm64_monterey: "1774d0e39c97fc328e73411c8ad083d1bc0592576c427c2f6cea4ae9f1f7ba1b"
    sha256 cellar: :any,                 arm64_big_sur:  "92ea8e6f41fca2b1bf1a4e25783a0c1cf45e93f3ce99e4bffa078f9ef54b81d4"
    sha256 cellar: :any,                 sonoma:         "b489feeec0cf557cb44928ca8e805b7c25a86754dde295abc9795108b17d800c"
    sha256 cellar: :any,                 ventura:        "7526c01904f1a9a658e1ec38f1ecc3d20c14e8a164e5ce891fe9f0b5df5d93d4"
    sha256 cellar: :any,                 monterey:       "a6cd012acf4ff3199b3866e93c3b930e399f33eea2a5e49220f4214c31e8d15f"
    sha256 cellar: :any,                 big_sur:        "7bad0c4c7883daaba35df770a5a544d935d6531292c02a6df2c956ef3e8a2b42"
    sha256 cellar: :any,                 catalina:       "aa6fc4ef555883fac180c46b4e6d5e03096bd9369640fbe8f6ec8fa9f63c70c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f11f34a4be29819b423e16998acd71c598b901090252da96b7d7a6b554edb9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1045d2418ab117484c0645ced40c1c7dfe9751443b56e1fdff639a2591732acb"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-wm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"

  uses_from_macos "m4" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-ewmh")
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-icccm")
  end
end
