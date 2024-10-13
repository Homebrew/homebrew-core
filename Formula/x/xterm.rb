class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-394.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_394.orig.tar.gz"
  sha256 "a2a0cb206eb0423dedc34794f5c2d38c83390d2dd1106b66aba0960c3a976c7a"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "6cce03b4873df6499e88ae23adc0c49a584e0bb4ece451a8693ccfe9b523bc14"
    sha256 arm64_sonoma:   "63cd19fc458f0576cb3c33062a3a59cda38b17079bcdebd01de82d6c469a5f6b"
    sha256 arm64_ventura:  "e23747d37f601cb0cf5de5b7dec8ab637cb93885d1ca93e21fd3f39b4300e3e5"
    sha256 arm64_monterey: "9e7d00e0399c9cfc3ca6ac9ba2a7a06078a162db2df15c81b709df1770248831"
    sha256 sonoma:         "37cd98e0e48d5d28223351b7338293220e91bbbdfc9da8f27ed0a9f2e1c4a054"
    sha256 ventura:        "245a2fa5459903ae789e77ae56a0d515289e0650402638c3f5214da38b6c3faf"
    sha256 monterey:       "dfa13604b2ed71ef8155e788bce2cb0a1ad172f1156dbaac09838e75c3365c31"
    sha256 x86_64_linux:   "e5f2aaf508e55746fa8b104f76dcd4d2cd2aa6b06c981be93118cf0ca8f3279d"
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
