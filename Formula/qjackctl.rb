class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "http://qjackctl.sourceforge.net"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.4.tar.gz"
  sha256 "531db2f7eca654fd8769a1281dccb54ebca57a0b2a575734d1bafc3896a46ba5"
  head "http://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "6c7bf88956be30bf0c2598ea0382142284e82837d51c4248cc8b720d3e962740" => :sierra
    sha256 "67ed21adb3ce0b47b7e2b64663dfc49a801ea906f8707bdd7320db8ccd3be5bf" => :el_capitan
    sha256 "f24586ac79810807e4326555f93c0b53976d78c2fe215a13d464f01c0d3d318b" => :yosemite
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
