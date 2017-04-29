class Qjackctl < Formula
  desc "simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.4.5.tar.gz"
  sha256 "c50da569ec8466ac6cc72c65e2d8212eb9c40149daed0a10fb7795ff9ddc4ab7"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
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
