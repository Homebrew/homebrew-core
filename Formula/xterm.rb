class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-368.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_368.orig.tar.gz"
  sha256 "2ff5169930b6b49ef0bafb5e1331c94f1a98c310442bba7798add821c76ae712"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "247e385f6e3c57ad3ca5b26ab42fb19478455cb8d433e1ea0cd40790e31656ef"
    sha256 big_sur:       "fa0d460d525b384564567cb60a6b9d826f930aa3e585f4e1a3fa068789138832"
    sha256 catalina:      "9a5ec1a7eba5b567c0d967bf7fa1f8381a25dca040e3e05f4cda01db67ed8cf5"
    sha256 mojave:        "47e9e7749b215fa33ec20551b76174164d96ab24118602e02e89b1c317bc7981"
    sha256 x86_64_linux:  "6af50645b4a7d28b46c2ede7cdf9a1b3d04006105a66c4d4603d13d190d87771"
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
