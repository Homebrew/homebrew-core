class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-397.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_397.orig.tar.gz"
  sha256 "2e9b742b9cba44ecec58074e513237f6cd6d5923f1737cb36a4e5625f4ae8662"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "803caefe590cf40f979bf52cb02714530a45d8a0118610a8cc2a48eeb5b45958"
    sha256 arm64_sonoma:  "0ce8273bfb6bf5d63ca880d8cef4fefde2e9a3616c7f0428136d24a9bcee1f8d"
    sha256 arm64_ventura: "05b283d09d97a253433501436a4f6f02587d0fa820b9449ba7dfdcf19102acc8"
    sha256 sonoma:        "ef8d34366adbe5b875ce5bcbf42f987e40a9ca721734b39a2cd04334703ca9db"
    sha256 ventura:       "b8b2cc0219cf147eff1a5832691b910ac52778c7fb86e5550ab0002696c3f551"
    sha256 x86_64_linux:  "87a20371ba9a7e4c384d8614a4619424053cf519a058836ef7160187aa59f325"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end
