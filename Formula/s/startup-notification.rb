class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10d94fd081a6867bae73ef9bf9a47b7abb32d92aa50ed920c423cf1f35163265"
    sha256 cellar: :any,                 arm64_monterey: "9272c92348ee82fc166a46ad129d860019f9dbacbd1effc8f612cbd1dff3f049"
    sha256 cellar: :any,                 arm64_big_sur:  "d5cb6d07fb21b5bf6c2276de876642a3b8579c4d4f4b962532b3c1c831ba4f93"
    sha256 cellar: :any,                 ventura:        "c7482a5c88b46b7750fa230fafea803b65666b824dff3e9c2d3364dea929410e"
    sha256 cellar: :any,                 monterey:       "7f062ed1316540ed9d9cd75f190954b57fc8eba9ee5394eb624a6748e9c4289d"
    sha256 cellar: :any,                 big_sur:        "17601558b8e72930f3917e9c7373d620a37e6cbf987172e3134f87a2ccc60af0"
    sha256 cellar: :any,                 catalina:       "bdb8f9123099562853461f5299108f7cbfac9be39ea3ab9ad6b3853c288ba5c9"
    sha256 cellar: :any,                 mojave:         "c4fcbad957b22a8999a0bc87a3c2b0b2b6b94654b3f6213f5903025574ae4c76"
    sha256 cellar: :any,                 high_sierra:    "60f0a0ce0a2954f53fa9f4b5dfc3aeb99aa5607801f340b506ea172bb1e381f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45873a4a273a11b66436459b7130de94bcb32470a3a4376ef74b2803e2494462"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "xcb-util"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags libstartup-notification-1.0").chomp
  end
end
