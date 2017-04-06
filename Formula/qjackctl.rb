class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.4.tar.gz"
  sha256 "531db2f7eca654fd8769a1281dccb54ebca57a0b2a575734d1bafc3896a46ba5"
  revision 2
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "a1ca2fa7ede8255ecc93d603fc03288edb2c76bf9fa1b0ab04f6ea94554624d9" => :sierra
    sha256 "9eee408da628e6006fd9ddbd360f2327771b563c6547b6b3d6fd8e0bfb45db86" => :el_capitan
    sha256 "4f684b6f62ee1dc61e78659e357419d9135b2d630200b8d1ba94175a7fbc0eb5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "jack"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt5=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
