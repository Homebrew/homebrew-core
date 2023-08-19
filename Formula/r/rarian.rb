class Rarian < Formula
  desc "Documentation metadata library"
  homepage "https://rarian.freedesktop.org/"
  url "https://gitlab.freedesktop.org/rarian/rarian/-/releases/0.8.4/downloads/assets/rarian-0.8.4.tar.bz2"
  sha256 "55624f9001fce8f6c8032d7d57bf2acfe7c150bafb3b1bb715319a1b2eb9b2c5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?rarian[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "eda0147443cb518888be9c20fa4ff238097be7be79aaee194571e497ceae778a"
    sha256 arm64_monterey: "d20a0dbb13100d47eca91cb31325d73f15fa3830204232c663bb3abd762a43b4"
    sha256 arm64_big_sur:  "70ac2150b3510f9ba5d7f268be40ecd8b4eebd20db220662e3b7090b5cff58bc"
    sha256 ventura:        "c4330088c8052bb965deb144e17971c787d8b3ad05f377af68d0de4659832280"
    sha256 monterey:       "80dc622fecf306b992ecc05271a7c9e9997db3cb88a7a60243d495e97507b71d"
    sha256 big_sur:        "485eaddd1330015597331ce44b76d210bf714aae93764525f9f5f22c374f8f59"
    sha256 x86_64_linux:   "bf0d04b4bfcc1868a63864a24107ac20c00c4eddd30ffe737a6ff15100b4aa4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "tinyxml"

  conflicts_with "scrollkeeper",
    because: "rarian and scrollkeeper install the same binaries"

  def install
    # Regenerate `configure` to fix `-flat_namespace` bug.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    seriesid1 = shell_output("#{bin}/rarian-sk-gen-uuid").strip
    sleep 5
    seriesid2 = shell_output("#{bin}/rarian-sk-gen-uuid").strip
    assert_match(/^\h+(?:-\h+)+$/, seriesid1)
    assert_match(/^\h+(?:-\h+)+$/, seriesid2)
    refute_equal seriesid1, seriesid2
  end
end
