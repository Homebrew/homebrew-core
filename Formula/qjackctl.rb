class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.4.tar.gz"
  sha256 "531db2f7eca654fd8769a1281dccb54ebca57a0b2a575734d1bafc3896a46ba5"
  revision 1
  head "http://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "6c02e0e43466d750b511a79a2518305314f271f05d2d9428166348f5630277c1" => :sierra
    sha256 "9548ef1c55b7ccbcec30d975cb5abb2e1563fd0ae17200bed12025d261b07bbc" => :el_capitan
    sha256 "14b930438f32b9726697f9db7e18c53b3d5e6dc23b5503d4f0b85420610f3879" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt5"
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
                          "--with-qt5=#{Formula["qt5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
