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
    rebuild 1
    sha256 big_sur:  "ec56b0b6779dd308f047fdca09b7b749f11e39c802500550c9a01d82e86529d0"
    sha256 catalina: "337e4d35072fdcaf5f1a147e63b9c0454fa028ef8a937722c8a6489b2e515e75"
    sha256 mojave:   "f778fa333b3c5fc73d97bb25d297c842e816962328b60c164c7bf612da9384cc"
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
