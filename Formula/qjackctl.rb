class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.3.tar.gz"
  sha256 "6bfdc3452f3c48d1ce40bd4164be0caa1c716474fbd3fb408d3308dfadf79e07"
  head "http://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    rebuild 1
    sha256 "73b7c2190a0b08964a72ace5ef02176a7c827da7fc2abd7fc80b41f0e2ea84a6" => :sierra
    sha256 "e27bb026a0a677ce7dbe4483fbf53a0bdad929da0007166790b6006cee0cf27a" => :el_capitan
    sha256 "531fcdb68a7436858e2b891dd0edacceed7bf084b0aadba046879d44fbf03bcd" => :yosemite
    sha256 "1b12ec7026cf50ed6b29726c60731f4bb1f22e39e62efe1569547dcb0f2b239a" => :mavericks
  end

  depends_on "qt5"
  depends_on "jack"

  def install
    system "./configure", "--disable-debug",
                          "--enable-qt5",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt5=#{Formula["qt5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
