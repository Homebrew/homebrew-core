class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://download.sourceforge.net/qjackctl/qjackctl-0.6.1.tar.gz"
  sha256 "dec2b1d98cc06bce6bc714a57521b15bafa2718835a1afffb6f0b1eb07d1c027"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "4d98a6cb0d8daf2dbf5b32c98c4f8168b77a55346bf92c036e701de3b24105d2" => :catalina
    sha256 "7b658d986d16dd31c24899081396d91c645eebd6fb40bfcc18ad494e864c13e8" => :mojave
    sha256 "d1444c4f9ac82682034ad2b895acd46e8227027b983a04bbbfaec2c7968a9646" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
