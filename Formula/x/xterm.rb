class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-387.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_387.orig.tar.gz"
  sha256 "81dd59cc2ecef1e849ed21722e37a24756e02b54ec19d157cb545b273813f4b8"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "3a72bd48ea472e880da4594d48927636a4a88f756caf8a369542c0b290fa4cc5"
    sha256 arm64_ventura:  "29d03f441ffd1486f20beae87b936de3de7363273e4e2b958f22f5874456bfab"
    sha256 arm64_monterey: "003eb509f11e161023cecd46fe51caffc25f3c438a3508f2378c2410d9c8143f"
    sha256 sonoma:         "196801dfcf458d05b875123680279f6cd4504a1e597eb10d302d514a55ea450a"
    sha256 ventura:        "69699a080824b530eca0cf09dfa218d9a4ecd6b58f4f7d452d4d7a42023069e4"
    sha256 monterey:       "5abb230c90dcd5ba2ec613b038d9fbf2fff07194521870eed30badeffc572319"
    sha256 x86_64_linux:   "4332b243af82622fc814813cdc4c8d3c267814c6f1dc8b5e81cc114d494c79b1"
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
