class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-366.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_366.orig.tar.gz"
  sha256 "858b2885963fe97e712739066aadc1baeba2b33a0016303a7fec7d38bc73bf6e"
  license :cannot_represent

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a0905279eba3ea5f5ad2de0b454df07f1217c368eec8b381bb686cff25b6421b"
    sha256 big_sur:       "6cd76cbed59699793cdce801808a8722101671e0e6a94f495b10b2065a30d83a"
    sha256 catalina:      "b98220391a962aa74f56eb5f6c7389497e954cf9999f4e89949f39d13f6f3eb8"
    sha256 mojave:        "535e30142bb419de69f5bd9af69ad08ea0972ec783a8cf1d276992e1b9159788"
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
