class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"
  license "LGPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5b1edc25aff59c8a62cd1a6c9ffa21e63d6a0fd21fe6fdd108ae17d6207b357e"
    sha256 cellar: :any,                 arm64_sequoia:  "a8443bdbe68a6ad0d3cfb6e762cf01b88eb719d243691b8070b024ad5c8ab70e"
    sha256 cellar: :any,                 arm64_sonoma:   "688da3d5c9f204ab402e2d419b2925bdf6087a1d6fc8d604e0e11be639904be8"
    sha256 cellar: :any,                 arm64_ventura:  "10d94fd081a6867bae73ef9bf9a47b7abb32d92aa50ed920c423cf1f35163265"
    sha256 cellar: :any,                 arm64_monterey: "9272c92348ee82fc166a46ad129d860019f9dbacbd1effc8f612cbd1dff3f049"
    sha256 cellar: :any,                 arm64_big_sur:  "d5cb6d07fb21b5bf6c2276de876642a3b8579c4d4f4b962532b3c1c831ba4f93"
    sha256 cellar: :any,                 sonoma:         "adcbdcb253f346f127783d48c27ad9a2de9b080df6f9177daaf08bfc6ef8ab32"
    sha256 cellar: :any,                 ventura:        "c7482a5c88b46b7750fa230fafea803b65666b824dff3e9c2d3364dea929410e"
    sha256 cellar: :any,                 monterey:       "7f062ed1316540ed9d9cd75f190954b57fc8eba9ee5394eb624a6748e9c4289d"
    sha256 cellar: :any,                 big_sur:        "17601558b8e72930f3917e9c7373d620a37e6cbf987172e3134f87a2ccc60af0"
    sha256 cellar: :any,                 catalina:       "bdb8f9123099562853461f5299108f7cbfac9be39ea3ab9ad6b3853c288ba5c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7bf37bfbd3313320fd91577f056930b461e927b689eaeba4080ad67311d0f0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45873a4a273a11b66436459b7130de94bcb32470a3a4376ef74b2803e2494462"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "xcb-util"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkgconf --cflags libstartup-notification-1.0").chomp
  end
end
