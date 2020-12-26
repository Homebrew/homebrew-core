class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-362.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_362.orig.tar.gz"
  sha256 "1d4ffe226fa8f021859bbc3007788ff63a46a31242d9bd9a7bd7ebe24e81aca2"
  license :cannot_represent

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "3c3eddaf030860352a88988fbaf010dca4b2fd915b4722e655b98ce37c7416a6" => :big_sur
    sha256 "28e883a95daea3c12aa593cabb9f359e54eed2b6d99c80c0d940cfef36f6d154" => :arm64_big_sur
    sha256 "c1ce2cda8a209fea2a12480a7c01c4344b8aa482a0ed3cbb61a300d6a94e0a2d" => :catalina
    sha256 "20aebf8514d2fd937b20bf8951334d79dd86d0c1882226aa805c4996623073fa" => :mojave
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
