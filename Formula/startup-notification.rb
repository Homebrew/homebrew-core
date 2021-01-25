class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any
    sha256 "17601558b8e72930f3917e9c7373d620a37e6cbf987172e3134f87a2ccc60af0" => :big_sur
    sha256 "d5cb6d07fb21b5bf6c2276de876642a3b8579c4d4f4b962532b3c1c831ba4f93" => :arm64_big_sur
    sha256 "bdb8f9123099562853461f5299108f7cbfac9be39ea3ab9ad6b3853c288ba5c9" => :catalina
    sha256 "c4fcbad957b22a8999a0bc87a3c2b0b2b6b94654b3f6213f5903025574ae4c76" => :mojave
    sha256 "60f0a0ce0a2954f53fa9f4b5dfc3aeb99aa5607801f340b506ea172bb1e381f3" => :high_sierra
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
