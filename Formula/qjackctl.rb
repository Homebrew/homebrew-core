class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.5.0.tar.gz"
  sha256 "9a74f33f6643bea8bf742ea54f9b40f08ed339887f076ff3068159c55d0ba853"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "00a9841ed8fdaf1b6e52b54e1ee1711ca2737485175d84480a0dc848e356f4a6" => :high_sierra
    sha256 "27a7963a4c5e9a5cbf844f0284064a28e3b275c843a703c99e8a161d4260dda1" => :sierra
    sha256 "9d4e866c9eaecc6301c4b715eb807893c87df9ad9a680cc70fa16d9b62412885" => :el_capitan
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
