class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-369.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_369.orig.tar.gz"
  sha256 "71ed6a48d064893d2149741a002781a973496fd24d52dadd364f63439a764e26"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "90232405e3095d13a2e393b5951d02904f2a2ed97e67f3984840f83ec7d00b71"
    sha256 big_sur:       "31b64d34048b7a98fe3ca796760840febe1f4098d038d465376a6c40576fb598"
    sha256 catalina:      "2cf6cbe5b3b21c791663ab08d2c3b9238ebfca8286a86160280639c7f94615eb"
    sha256 mojave:        "4b41c6be48cced5fda17b34d010338fdba8214924d726195870918d5e97c726b"
    sha256 x86_64_linux:  "1b71617753972ebc7bb96f13c5fe664a36f464134305c9a5b455b5797762db63"
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
