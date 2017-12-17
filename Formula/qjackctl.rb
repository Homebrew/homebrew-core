class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.5.0.tar.gz"
  sha256 "9a74f33f6643bea8bf742ea54f9b40f08ed339887f076ff3068159c55d0ba853"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "54ff7d2592ffeb84822d8ccfd2b2d143dfe79fc971d0272e2b4d79559c3efbd5" => :high_sierra
    sha256 "916c1421965be60c8bbef853e7111c69f111f698f04fda455148b293a7bbded5" => :sierra
    sha256 "9c172b06e49ef31184b6330aee463fa76cb94bdc902c7275d9fc50683f072449" => :el_capitan
    sha256 "1e72a2901d1a254c499dfaaf22c89cfad8d0b0871fd5c9bf9bb0d6fc57992e63" => :yosemite
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
