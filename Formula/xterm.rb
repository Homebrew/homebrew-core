class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-376.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_376.orig.tar.gz"
  sha256 "1e5bb7aad068fb31d6d3cbb77f80c7ad1526cd4c956a4ddcf2c5cf28af5334e1"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dded4bd4842a91dc7195418150b42908e21e8dba60b9e123c49a3af5d87489d6"
    sha256 arm64_monterey: "70169d3c78cb3a8b6d0439ea2e678030ed3446a7285896ca6c02d9b920e9bf76"
    sha256 arm64_big_sur:  "047aeac12e14d456732d1739cc112dfcbe8d7749ff0835c41edbacc016da9654"
    sha256 ventura:        "db5f11c76394d09dd4b257de417d53c469ba46e308a9aca50292c1700a8c3fee"
    sha256 monterey:       "7f77e87c77f31d953c667203daa07c4cec77d232c60bbf6ccc5b3006e2339fa7"
    sha256 big_sur:        "ad6c1eb32cc5850d2205cde5272bc446583b98bbb2832b561d14b1f263be1b91"
    sha256 catalina:       "821cccff346994c2143d5f745800a148b1022d9674ca0e6861d0aed819dbd13f"
    sha256 x86_64_linux:   "97bbfc0d6a56446f2efab85f608a383e7904c331cc097fda4f149a43f299516f"
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
