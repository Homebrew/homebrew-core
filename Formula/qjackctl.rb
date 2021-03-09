class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.1/qjackctl-0.9.1.tar.gz"
  sha256 "4fbe4c98ec5ce45efdd6a1088e2f5b208f5bcce994a8697b0bc96ecee99be254"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.code.sf.net/p/qjackctl/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 big_sur:  "3d0e211da2cf24780f1e53cbd768027483f03c97fa5e58c8beb665c47ec5082a"
    sha256 catalina: "fdb3a1dca5d31c3839081d8e8d453c92e8ca60e4f0b7f2a45c41ffdfbfdb166c"
    sha256 mojave:   "e482b9cf1424f3d5c4905cd9f789dd699bb50a72b39bce3e9a58169c8cd645f9"
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt@5"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt@5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
