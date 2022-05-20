class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-372.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_372.orig.tar.gz"
  sha256 "c6d08127cb2409c3a04bcae559b7025196ed770bb7bf26630abcb45d95f60ab1"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8777bf4b0d816aa1f5d3b97af989f408c17004410b45d91ab3c1fca7634397cb"
    sha256 arm64_big_sur:  "c6a6bc4089c043cb806c47201931fd03508b181b591ad6b9f0800e3c4acab2b9"
    sha256 monterey:       "b12e5eebb766e0711b2615cc148d91a19a2d7c602052cdd3812ae4b63f0c8cd1"
    sha256 big_sur:        "97817ff7fbaf2ce0fdf0725fdacc163cbb84d29b1e783613e67a24f2c91a068f"
    sha256 catalina:       "a5e2b36250af85d48df3745eb34aa3ca74f3f8bf6db449da76668bafc1761c4c"
    sha256 x86_64_linux:   "8f514c7c980670eecb001022ae8104507022ca19c3da7a1d3c1359b9bad0713b"
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
