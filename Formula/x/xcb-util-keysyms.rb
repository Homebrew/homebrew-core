class XcbUtilKeysyms < Formula
  desc "Standard X constants and conversion to/from keycodes"
  homepage "https://xcb.freedesktop.org"
  url "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.1.tar.gz"
  sha256 "1fa21c0cea3060caee7612b6577c1730da470b88cbdf846fa4e3e0ff78948e54"
  license "X11"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "53daefbc9047587b5a2f2e41bd1ef7381593ee69e66193d4464041f45fe24429"
    sha256 cellar: :any,                 arm64_sequoia:  "bf1324e90b7abdb41f7a6dfa41ce477627ad5d069a09dcfeb51491c5a559b274"
    sha256 cellar: :any,                 arm64_sonoma:   "71f2367c5777c07deb7cf6edda8a7b7a0d9bf162a467b8ae930c2ad0cdb6c450"
    sha256 cellar: :any,                 arm64_ventura:  "4d62cd700f85b3ba39740bd2dd9872d45aef018e603db2907f9bd1c3e6213d88"
    sha256 cellar: :any,                 arm64_monterey: "8f81bf9c5f646f94ab25dfc84953ae28fc166316263eea913b00cf9e569d455a"
    sha256 cellar: :any,                 arm64_big_sur:  "fab1de02f3c8f6ca3b93921678f2c5c7317f230b05b27790b805d8e2585a1901"
    sha256 cellar: :any,                 sonoma:         "bbbd83881b3b35058415b32a952b4124e11dcfc48e6a6680920efef22c07fd36"
    sha256 cellar: :any,                 ventura:        "1d54ce19d60722d3b41fe752c4703876c8a17fa62d1be1d8840c8a943374afd7"
    sha256 cellar: :any,                 monterey:       "246f9361f2802f7dac2fdc20c762c2cb50a86c0393b519529b52201e69fff053"
    sha256 cellar: :any,                 big_sur:        "0e25691158d5d28c473634d285e0fbb7ae59eeca5ec55305ea814536e03cd069"
    sha256 cellar: :any,                 catalina:       "9b08f8c1ee577cea420903ab5593ed8367eedd92da4cddc0d4c6ef2235dd7c76"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2bd06b66ac056a9d7defd40425046fd621bcc86d1b1a7ee73a6f5ada247f17df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269947922f6128006e0201a6972c1cf622dc93200268c0dfa5801b8899902c35"
  end

  head do
    url "https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libxcb"

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
    assert_match "-I#{include}", shell_output("pkg-config --cflags xcb-keysyms")
  end
end
