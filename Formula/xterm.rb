class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-367.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_367.orig.tar.gz"
  sha256 "27f1a8b1c756e269fd5684e60802b545f0be9b36b8b5d6bdbc840c6b000dc51f"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ded2f89424402fd1c80609c83cf8aaec6d19bbd45a3a7689949c1cfc3f42bb73"
    sha256 big_sur:       "599bab961c5731b31d87df0800a16238e67d437092cd6f5d75de990e0fb23736"
    sha256 catalina:      "3ca1ebfd5e334791f3f8d36388fe5856cc37dc337a36f51d1d12e7a1124e0e6a"
    sha256 mojave:        "0a52f271e119b5c0a27f2a3ec384b7c212a8f85f297377742af86dd861881b26"
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
