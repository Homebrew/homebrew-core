class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.5.2.tar.gz"
  sha256 "5ffd2fc629bdd30b06a5fa12e9652ca412c435ceb571e42289c3672a902b195b"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "68bec1308340a0b002fc348af954a2d0e483338e348f6915191ace10672bd27d" => :high_sierra
    sha256 "692ea322b8e86461766cc8ea2201031b139a5a0229bc9ec8c660389393843414" => :sierra
    sha256 "a95e2b7015b3d23bd07dae5ead3d396ba83e85ebf76ec6b02feee16bd635eb14" => :el_capitan
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
