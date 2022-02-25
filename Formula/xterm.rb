class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-371.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_371.orig.tar.gz"
  sha256 "32f888277b19e28ebc0a3112bff000607c07bed0679caa0beebb36f9cad484f5"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "93b5b0d6b7b3dfde6dcc38080f3340409e6c7beac957ebac2198c34c5258be70"
    sha256 arm64_big_sur:  "56154e7b27ed238a7bef2871a72becf2785ab1d83db69081284f689de276e63a"
    sha256 monterey:       "9c97ad56298f7aab1fa1392d949c74551e18fb4ade367f1810e352fa35bd17a9"
    sha256 big_sur:        "4eaf8819c1524860caf464f8bb301bcc5e50750b79f7f5071ff56763881af604"
    sha256 catalina:       "4307938ed026225c8bf972da662eb0b6a759668973b55d4efb5cfc135ff5c995"
    sha256 x86_64_linux:   "115c63d91feda6fe512ef9a27fe66c52a64cd1ab585b81392817a4f8697f1c91"
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
