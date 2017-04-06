class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.4.tar.gz"
  sha256 "531db2f7eca654fd8769a1281dccb54ebca57a0b2a575734d1bafc3896a46ba5"
  revision 2
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "5a0d5ca2e9b76d767d87b87df1fc595ef99995084998af2e6b374549ba9325bf" => :sierra
    sha256 "a148d86c836504cb34694ef7670418d0885c42912d3284e89376f4eee8d43f8e" => :el_capitan
    sha256 "d7bf65e4635543f4f45244a0ecf82883d612e09f182907b681d8a09c20877573" => :yosemite
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
