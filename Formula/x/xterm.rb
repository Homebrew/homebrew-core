class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-384.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_384.orig.tar.gz"
  sha256 "31ef870740ceae020c3c4b4a9601c7f47bfd46672c1aaf2d213a565d64cbc373"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "237ed591ac78166be805c164fa81cbc6edf015c831f59f1136925429c1f807a4"
    sha256 arm64_monterey: "d9f66a51ae4ac93eb953fb1f69662c8a8ec53a31cc422061e7a59051528d95d9"
    sha256 arm64_big_sur:  "9e76b30e573658633a989391e56ef02d93220a946be21bd1999b72accfc18483"
    sha256 ventura:        "8d5e32b06ff89d6a39074778c14246c1c5593fdc98b7af8253e44fb728365209"
    sha256 monterey:       "379dcd7ca034170c42ede65ee4b00e3ab1e1cd958485904760c92feea65aff9e"
    sha256 big_sur:        "ce78a86fe3e7abbf1375b217d2122eeee7cfc50a19247e41df34f4335790f2b0"
    sha256 x86_64_linux:   "763d87094f32ca3ee8364d2259375716dd2e3fc1c58d0cc9087fd5eec06894c3"
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
