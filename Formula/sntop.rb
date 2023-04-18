class Sntop < Formula
  desc "Curses-based utility that polls hosts to determine connectivity"
  homepage "https://sntop.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sntop/sntop/1.4.3/sntop-1.4.3.tar.gz"
  sha256 "943a5af1905c3ae7ead064e531cde6e9b3dc82598bbda26ed4a43788d81d6d89"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/sntop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "b482ea74af9def4d942033c23ddacc43c16935bcd7e9094506e0008e8c69eed0"
    sha256 arm64_monterey: "88c1bf529d00acd5093a911407aae68da341df753371f81d319862e9bafe2407"
    sha256 arm64_big_sur:  "0674ad1a5387fadc27e9132d36bef2178e3ea821e9e05fadcc3a4d97b90a5758"
    sha256 ventura:        "20498a6ce6ef87de7400188bcbc095b7ea0fb1e2c90e02c35042b324835110ab"
    sha256 monterey:       "339487a2777504f99d3a3d9b9ae4f9d10de35d4e694a1708784e55ca2c586e09"
    sha256 big_sur:        "ea8df8c0dbf95ed5686009df6bd7742d6f4a4a2e4c6132a02e6273ccfd21cc67"
    sha256 catalina:       "886a981f2c95a8a17d4bfb44c27d99cde66faeb4f2942d1c43757e8d702509c6"
    sha256 mojave:         "d010bc2fa761320d0d0f4948d5f95392d892e7bd7815418e9881ec90049d4036"
    sha256 high_sierra:    "c22d769ddb8599acf3f03db2ef85eef5ee28e41f9ec3011e9b23f6168ceb0a76"
    sha256 sierra:         "f15c15a4e2251e86e55c3bd2c75f660448e38efe9b0b57edd6d3e9301377929c"
    sha256 el_capitan:     "c3f19036cf2d42ce9fa07ed6db6264b3e52ba475827903972877a8131eae60e9"
    sha256 x86_64_linux:   "15e6f3f42a8d6afa68d48744f2673142104a0cfb84daff23c6706db8adbe6536"
  end

  depends_on "fping"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}"
    etc.mkpath
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      sntop uses fping by default and fping can only be run by root by default.
      You can run `sudo sntop` (or `sntop -p` which uses standard ping).
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    system "#{bin}/sntop", "--version"
  end
end
