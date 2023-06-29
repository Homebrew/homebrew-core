class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-383.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_383.orig.tar.gz"
  sha256 "a06613bcda508c2a1bff6d4230895da74a798799a2e39a23bac82089d7b9a998"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "45cff3a7b0a2ba9e339d5b3d43f2503dc6b20fc6031f809e26c6776b3a89a4a1"
    sha256 arm64_monterey: "0e257b047d0e70fefc9446e66e59539ac3e4c4f8bd1c37ea4d7a94fd970bf1de"
    sha256 arm64_big_sur:  "b6f1a7f155cb1bbb43c14b07de1a4201391ee916816e63ba256f2bcf6519eacd"
    sha256 ventura:        "bfed5788ade4e1dab41b72a851bd317c9fefa3dbefe7c1800327466e9fd8db80"
    sha256 monterey:       "6d1d22619d641619f866f40d2fa80f74962307af37ed19778fad61de2257d906"
    sha256 big_sur:        "8e70d24963210987e9be746e75b7545d6b83c63bebdbbc877fc30ddeb163b2e5"
    sha256 x86_64_linux:   "19aa4639df1b0c2a435916779420e9f100cd9edd5b102b49e49f5ecbd5c32960"
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
